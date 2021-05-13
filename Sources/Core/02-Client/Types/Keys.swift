//package types
//
//import (
//	"fmt"
//	"regexp"
//	"strconv"
//	"strings"
//
//	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
//	host "github.com/cosmos/ibc-go/modules/core/24-host"
//)

import Cosmos
import Host

public enum ClientKeys {
	// SubModuleName defines the IBC client name
    static let subModuleName = "client"
//
//	// RouterKey is the message route for IBC client
//	RouterKey string = SubModuleName
//
//	// QuerierRoute is the querier route for IBC client
//	QuerierRoute string = SubModuleName
//
//	// KeyNextClientSequence is the key used to store the next client sequence in
//	// the keeper.
//	KeyNextClientSequence = "nextClientSequence"
}

extension ClientKeys {
    // FormatClientIdentifier returns the client identifier with the sequence appended.
    // This is a SDK specific format not enforced by IBC protocol.
    public static func formatClientIdentifier(clientType: String, sequence: UInt64) -> String {
        "\(clientType)-\(sequence)"
    }

    // IsClientIDFormat checks if a clientID is in the format required on the SDK for
    // parsing client identifiers. The client identifier must be in the form: `{client-type}-{N}
    static func isClientIdFormat(_ clientId: String) -> Bool {
        clientId.range(of: #"^.*[^-]-[0-9]{1,20}$"#, options: .regularExpression) != nil
    }

    // IsValidClientID checks if the clientID is valid and can be parsed into the client
    // identifier format.
    public static func isValid(clientId: String) -> Bool {
        do {
            _ = try parse(clientIdentifier: clientId)
            return true
        } catch {
            return false
        }
    }

    // ParseClientIdentifier parses the client type and sequence from the client identifier.
    static public func parse(clientIdentifier clientId: String) throws -> (String, UInt64) {
        guard isClientIdFormat(clientId) else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "invalid client identifier \(clientId) is not in format: `{client-type}-{N}`"
            )
        }

        let splitString = clientId.split(separator: "-")
        let lastIndex = splitString.count - 1

        let clientType = splitString.dropLast().joined(separator: "-")
        
        guard !clientType.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "client identifier must be in format: `{client-type}-{N}` and client type cannot be blank"
            )
        }

        guard let sequence = UInt64(splitString[lastIndex]) else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "failed to parse client identifier sequence"
            )
        }

        return (clientType, sequence)
    }
}
