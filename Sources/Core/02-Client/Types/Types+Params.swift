//package types
//
//import (
//	"fmt"
//	"strings"
//
//	"github.com/cosmos/ibc-go/modules/core/exported"
//	paramtypes "github.com/cosmos/cosmos-sdk/x/params/types"
//)

import IBCCoreExported

extension ClientParams {
    // DefaultAllowedClients are "06-solomachine" and "07-tendermint"
    static let defaultAllowedClients: [String] = [ExportedClientKeys.solomachine, ExportedClientKeys.tendermint]

//	// KeyAllowedClients is store's key for AllowedClients Params
//	KeyAllowedClients = []byte("AllowedClients")
//)
//
//// ParamKeyTable type declaration for parameters
//func ParamKeyTable() paramtypes.KeyTable {
//	return paramtypes.NewKeyTable().RegisterParamSet(&Params{})
//}

//// NewParams creates a new parameter configuration for the ibc transfer module
//func NewParams(allowedClients ...string) Params {
//	return Params{
//		AllowedClients: allowedClients,
//	}
//}

    // DefaultParams is the default parameter configuration for the ibc-transfer module
    public static let `default` = ClientParams(
        allowedClients: defaultAllowedClients
    )

    // Validate all ibc-transfer module parameters
    public func validate() throws {
        try Self.validate(clients: allowedClients)
    }

//// ParamSetPairs implements params.ParamSet
//func (p *Params) ParamSetPairs() paramtypes.ParamSetPairs {
//	return paramtypes.ParamSetPairs{
//		paramtypes.NewParamSetPair(KeyAllowedClients, p.AllowedClients, validateClients),
//	}
//}

    // IsAllowedClient checks if the given client type is registered on the allowlist.
    public func isAllowed(client clientType: String) -> Bool {
        allowedClients.contains(clientType)
    }

    static func validate(clients: Any) throws {
        struct ValidationError: Error, CustomStringConvertible {
           var description: String
        }
        
        guard let clients = clients as? [String] else {
            throw ValidationError(description: "invalid parameter type: \(type(of: clients))")
        }

        for (i, clientType) in clients.enumerated() {
            guard !clientType.trimmingCharacters(in: .whitespaces).isEmpty else {
                throw ValidationError(description: "client type \(i) cannot be blank")
            }
        }
    }
}
