//package keeper
//
//import (
//	sdk "github.com/cosmos/cosmos-sdk/types"
//	"github.com/cosmos/ibc-go/modules/apps/transfer/types"
//)

import Cosmos

extension TransferKeeper {
    // GetSendEnabled retrieves the send enabled boolean from the paramstore
    func isSendEnabled(request: Request) -> Bool {
        parameterSpace.get(request: request, key: TransferKeys.isSendEnabledKey) ?? false
    }

    // GetReceiveEnabled retrieves the receive enabled boolean from the paramstore
    func isReceiveEnabled(request: Request) -> Bool {
        parameterSpace.get(request: request, key: TransferKeys.isReceiveEnabledKey) ?? false
    }

    // GetParams returns the total set of ibc-transfer parameters.
    func parameters(request: Request) -> TransferParameters {
        TransferParameters(
            isSendEnabled: isSendEnabled(request: request),
            isReceiveEnabled: isReceiveEnabled(request: request)
        )
    }

    // SetParams sets the total set of ibc-transfer parameters.
    func set(parameters: TransferParameters, request: Request) {
        parameterSpace.setParameterSet(request: request, parameterSet: parameters)
    }
}
