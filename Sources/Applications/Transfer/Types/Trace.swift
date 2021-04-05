import Tendermint
import Cosmos
import CosmosProto
import Host
import Crypto

//package types
//
//import (
//	"crypto/sha256"
//	"encoding/hex"
//	"fmt"
//	"sort"
//	"strings"
//
//	tmbytes "github.com/tendermint/tendermint/libs/bytes"
//	tmtypes "github.com/tendermint/tendermint/types"
//
//	sdk "github.com/cosmos/cosmos-sdk/types"
//	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
//	host "github.com/cosmos/ibc-go/modules/core/24-host"
//)

// DenomTrace contains the base denomination for ICS20 fungible tokens and the
// source tracing information path.
struct DenominationTrace: Equatable, Hashable, Codable {
    // path defines the chain of port/channel identifiers used for tracing the
    // source of the fungible token.
    let path: String
    // base denomination of the relayed fungible token.
    let baseDenomination: String
    
    enum CodingKeys: String, CodingKey {
        case path
        case baseDenomination = "base_denom"
    }
}

extension DenominationTrace {
    init(_ denominationTrace: Ibc_Applications_Transfer_V1_DenomTrace) {
        self.path = denominationTrace.path
        self.baseDenomination = denominationTrace.path
    }
}

extension Ibc_Applications_Transfer_V1_DenomTrace {
    init(_ denominationTrace: DenominationTrace) {
        self.init()
        self.path = denominationTrace.path
        self.baseDenom = denominationTrace.baseDenomination
    }
}

extension DenominationTrace {
    // ParseDenomTrace parses a string with the ibc prefix (denom trace) and the base denomination
    // into a DenomTrace type.
    //
    // Examples:
    //
    // 	- "portidone/channelidone/uatom" => DenomTrace{Path: "portidone/channelidone", BaseDenom: "uatom"}
    // 	- "uatom" => DenomTrace{Path: "", BaseDenom: "uatom"}
    init(rawDenomination: String) {
        let denominationSplit = rawDenomination.split(separator: "/")

        guard denominationSplit[0] != rawDenomination else {
            self.init(
                path: "",
                baseDenomination: rawDenomination
            )
            
            return
        }

        self.init(
            path: denominationSplit.dropLast().joined(separator: "/"),
            baseDenomination: String(denominationSplit.last!)
        )
    }

    // Hash returns the hex bytes of the SHA256 hash of the DenomTrace fields using the following formula:
    //
    // hash = sha256(tracePath + "/" + baseDenom)
    var hash: HexadecimalData {
        HexadecimalData(SHA256.hash(data: fullDenominationPath.data))
    }

    // GetPrefix returns the receiving denomination prefix composed by the trace info and a separator.
    var prefix: String {
        path + "/"
    }

    // IBCDenom a coin denomination for an ICS20 fungible token in the format
    // 'ibc/{hash(tracePath + baseDenom)}'. If the trace is empty, it will return the base denomination.
    var ibcDenomination: String {
        guard path == "" else {
            return "\(TransferKeys.denominationPrefix)/\(hash)"
        }
        
        return baseDenomination
    }

    // GetFullDenomPath returns the full denomination according to the ICS20 specification:
    // tracePath + "/" + baseDenom
    // If there exists no trace then the base denomination is returned.
    var fullDenominationPath: String {
        guard path != "" else {
            return baseDenomination
        }
        
        return prefix + baseDenomination
    }

    static func validate(traceIdentifiers identifiers: [(String, String)]) throws {
        guard !identifiers.isEmpty else {
            throw GenericError(description: "identifiers cannot be empty")
        }

        // validate correctness of port and channel identifiers
        for (index, identifier) in identifiers.enumerated() {
            do {
                try Host.portIdentifierValidator(id: identifier.0)
            } catch {
                throw CosmosError.wrap(
                    error: error,
                    description: "invalid port ID at position \(index)"
                )
            }
            
            do {
                try Host.channelIdentifierValidator(id: identifier.1)
            } catch {
                throw CosmosError.wrap(
                    error: error,
                    description: "invalid channel ID at position \(index)"
                )
            }
        }
    }

    // Validate performs a basic validation of the DenomTrace fields.
    func validate() throws {
        // empty trace is accepted when token lives on the original chain
        guard path != "" || baseDenomination == "" else {
            return
        }
        
        guard !baseDenomination.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw GenericError(description: "base denomination cannot be blank")
        }

        // NOTE: no base denomination validation

        let identifiers = Array(path.split(separator: "/").map(String.init).pairs())
        try Self.validate(traceIdentifiers: identifiers)
    }
}

// Traces defines a wrapper type for a slice of DenomTrace.
typealias Traces = [DenominationTrace]

extension Traces {
    // Validate performs a basic validation of each denomination trace info.
    func validate() throws {
        var seenTraces: [String: Void] = [:]
        
        for (index, trace) in self.enumerated() {
            let hash = trace.hash.description
            
            guard seenTraces[hash] == nil else {
                throw GenericError(description: "duplicated denomination trace with hash \(hash)")
            }

            do {
                try trace.validate()
            } catch {
                throw CosmosError.wrap(
                    error: error,
                    description: "failed denom trace \(index) validation"
                )
            }
            
            seenTraces[hash] = ()
        }
    }
}

extension DenominationTrace: Comparable {
    static func < (lhs: DenominationTrace, rhs: DenominationTrace) -> Bool {
        lhs.fullDenominationPath.lexicographicallyPrecedes(rhs.fullDenominationPath)
    }
}

extension DenominationTrace {
    // ValidatePrefixedDenom checks that the denomination for an IBC fungible token packet denom is correctly prefixed.
    // The function will return no error if the given string follows one of the two formats:
    //
    //  - Prefixed denomination: '{portIDN}/{channelIDN}/.../{portID0}/{channelID0}/baseDenom'
    //  - Unprefixed denomination: 'baseDenom'
    static func validate(prefixedDenomination denomination: String) throws {
        let denominationSplit = denomination.split(separator: "/")
        
        guard denominationSplit[0] != denomination || denomination.trimmingCharacters(in: .whitespaces).isEmpty else {
            // NOTE: no base denomination validation
            return
        }

        guard !denominationSplit.last!.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw CosmosError.wrap(
                error: TransferError.invalidDenominationForTransfer,
                description: "base denomination cannot be blank"
            )
        }

        let identifiers = Array(denominationSplit.dropLast().map(String.init).pairs())
        try validate(traceIdentifiers: identifiers)
    }
}

extension Sequence {
    func pairs() -> UnfoldSequence<(Element, Element), Iterator> {
        return sequence(state: makeIterator()) { iterator in
            iterator.next().map { element in
                (element, iterator.next()!)
            }
        }
    }
}

extension DenominationTrace {
    // ValidateIBCDenom validates that the given denomination is either:
    //
    //  - A valid base denomination (eg: 'uatom')
    //  - A valid fungible token representation (i.e 'ibc/{hash}') per ADR 001 https://github.com/cosmos/cosmos-sdk/blob/master/docs/architecture/adr-001-coin-source-tracing.md
    static func validate(ibcDenomination denomination: String) throws {
        try Coins.validate(denomination: denomination)
        let denominationSplit = denomination.split(separator: "/", maxSplits: 1)

        if (denomination.trimmingCharacters(in: .whitespaces).isEmpty) ||
            (denominationSplit.count == 1 && denominationSplit[0] == TransferKeys.denominationPrefix) ||
            (denominationSplit.count == 2 && (denominationSplit[0] != TransferKeys.denominationPrefix || denominationSplit[1].trimmingCharacters(in: .whitespaces).isEmpty))
        {
            throw CosmosError.wrap(
                error: TransferError.invalidDenominationForTransfer,
                description: "denomination should be prefixed with the format 'ibc/{hash(trace + \"/\" + \(denomination)}'"
            )
        }

        if denominationSplit[0] == denomination && !denomination.trimmingCharacters(in: .whitespaces).isEmpty {
            return
        }

        do {
            _ = try HexadecimalData(hexadecimalHash: denominationSplit[1])
        } catch {
            throw CosmosError.wrap(
                error: error,
                description: "invalid denom trace hash \(denominationSplit[1])"
            )
        }
    }
}

// ParseHexHash parses a hex hash in string format to bytes and validates its correctness.
extension HexadecimalData {
    init<S: StringProtocol>(hexadecimalHash: S) throws {
        guard let hash = HexadecimalData(hexadecimalHash) else {
            throw GenericError(description: "Invalid hexadecimal encoded string \(hexadecimalHash).")
        }

        try Tendermint.validate(hash: hash)
        self = hash
    }
}
