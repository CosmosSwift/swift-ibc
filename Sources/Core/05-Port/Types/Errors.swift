import Cosmos

extension CosmosError {
    
    // IBC port sentinel errors
    static let portExists = register(codespace: PortKeys.subModuleName, code: 2, description: "port is already binded")
    static let portNotFound = register(codespace: PortKeys.subModuleName, code: 3, description: "port not found")
    static let invalidPort = register(codespace: PortKeys.subModuleName, code: 4, description: "invalid port")
    static let invalidRoute = register(codespace: PortKeys.subModuleName, code: 5, description: "route not found")

}

/*
package types

import (
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// IBC port sentinel errors
var (
	ErrPortExists   = sdkerrors.Register(SubModuleName, 2, "port is already binded")
	ErrPortNotFound = sdkerrors.Register(SubModuleName, 3, "port not found")
	ErrInvalidPort  = sdkerrors.Register(SubModuleName, 4, "invalid port")
	ErrInvalidRoute = sdkerrors.Register(SubModuleName, 5, "route not found")
)

*/
