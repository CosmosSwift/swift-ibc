
import Cosmos

fileprivate let subModuleName = "commitment"

extension CosmosError {
    
    // IBC port sentinel errors
    static let invalidProof = register(codespace: subModuleName, code: 2, description: "invalid proof")
    static let invalidPrefix = register(codespace: subModuleName, code: 3, description: "invalid prefix")
    static let invalidMerkleProof = register(codespace: subModuleName, code: 4, description: "invalid merkle proof")

}

/*
package types

import (
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// SubModuleName is the error codespace
const SubModuleName string = "commitment"

// IBC connection sentinel errors
var (
	ErrInvalidProof       = sdkerrors.Register(SubModuleName, 2, "invalid proof")
	ErrInvalidPrefix      = sdkerrors.Register(SubModuleName, 3, "invalid prefix")
	ErrInvalidMerkleProof = sdkerrors.Register(SubModuleName, 4, "invalid merkle proof")
)

*/
