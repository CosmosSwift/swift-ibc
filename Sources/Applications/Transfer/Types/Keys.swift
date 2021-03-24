//package types
//
//import (
//	"crypto/sha256"
//	"fmt"
//
//	sdk "github.com/cosmos/cosmos-sdk/types"
//)

import Foundation

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

//// GetEscrowAddress returns the escrow address for the specified channel.
//// The escrow address follows the format as outlined in ADR 028:
//// https://github.com/cosmos/cosmos-sdk/blob/master/docs/architecture/adr-028-public-key-addresses.md
//func GetEscrowAddress(portID, channelID string) sdk.AccAddress {
//	// a slash is used to create domain separation between port and channel identifiers to
//	// prevent address collisions between escrow addresses created for different channels
//	contents := fmt.Sprintf("%s/%s", portID, channelID)
//
//	// ADR 028 AddressHash construction
//	preImage := []byte(Version)
//	preImage = append(preImage, 0)
//	preImage = append(preImage, contents...)
//	hash := sha256.Sum256(preImage)
//	return hash[:20]
//}
//
