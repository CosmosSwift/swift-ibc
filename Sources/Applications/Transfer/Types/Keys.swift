import Crypto
import Foundation
import Cosmos

public enum TransferKeys {
	// ModuleName defines the IBC transfer name
	static let moduleName = "transfer"

	// Version defines the current version the IBC tranfer
	// module supports
	static let version = "ics20-1"

	// PortID is the default port id that transfer module binds to
	static let portId = "transfer"

	// StoreKey is the store key string for IBC transfer
	static let storeKey = moduleName

	// RouterKey is the message route for IBC transfer
	static let routerKey = moduleName

	// QuerierRoute is the querier route for IBC transfer
	static let querierRoute = moduleName

	// DenomPrefix is the prefix used for internal SDK coin representation.
	static let denominationPrefix = "ibc"
}

extension TransferKeys {
	// PortKey defines the key to store the port ID in store
    static let portKey = Data([0x01])
	// DenomTraceKey defines the key to store the denomination trace info in store
	static let denominationTraceKey = Data([0x02])
}

extension TransferKeys {
    // GetEscrowAddress returns the escrow address for the specified channel.
    // The escrow address follows the format as outlined in ADR 028:
    // https://github.com/cosmos/cosmos-sdk/blob/master/docs/architecture/adr-028-public-key-addresses.md
    static func escrowAddress(portId: String, channelId: String) -> AccountAddress {
        // a slash is used to create domain separation between port and channel identifiers to
        // prevent address collisions between escrow addresses created for different channels
        let contents = "\(portId)/\(channelId)".data

        // ADR 028 AddressHash construction
        var preImage = version.data
        preImage.append(0)
        preImage.append(contentsOf: contents)
        let hash = SHA256.hash(data: preImage)
        // TODO: Check if this is correct
        return AccountAddress(data: Data(hash.prefix(20)))
//        return hash[:20]
    }
}
