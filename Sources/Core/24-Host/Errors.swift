import Cosmos

let SubModuleName = "host"

extension CosmosError {
    
    // IBC client sentinel errors
    static let invalidID = register(codespace: SubModuleName, code: 2, description: "invalid identifier")
    static let invalidPath = register(codespace: SubModuleName, code: 3, description: "invalid path")
    static let invalidPacket = register(codespace: SubModuleName, code: 4, description: "invalid packet")

}

/*
package host

import (
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// SubModuleName defines the ICS 24 host
const SubModuleName = "host"

// IBC client sentinel errors
var (
	ErrInvalidID     = sdkerrors.Register(SubModuleName, 2, "invalid identifier")
	ErrInvalidPath   = sdkerrors.Register(SubModuleName, 3, "invalid path")
	ErrInvalidPacket = sdkerrors.Register(SubModuleName, 4, "invalid packet")
)

*/
