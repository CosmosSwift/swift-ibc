/*

TODO: substitute with the relevant proto generated file

*/

import CosmosProto

// Params defines the set of IBC transfer parameters.
// NOTE: To prevent a single token from being transferred, set the
// TransfersEnabled parameter to true and then set the bank module's SendEnabled
// parameter for the denomination to false.
struct TransferParameters: Codable {
    // send_enabled enables or disables all cross-chain token transfers from this
    // chain.
    let isSendEnabled: Bool
    // receive_enabled enables or disables all cross-chain token transfers to this
    // chain.
    let isReceiveEnabled: Bool
    
    private enum CodingKeys: String, CodingKey {
        case isSendEnabled = "send_enabled"
        case isReceiveEnabled = "receive_enabled"
    }
}

extension TransferParameters {
    init(_ parameters: Ibc_Applications_Transfer_V1_Params) {
        self.isSendEnabled = parameters.sendEnabled
        self.isReceiveEnabled = parameters.receiveEnabled
    }
}

extension Ibc_Applications_Transfer_V1_Params {
    init(_ parameters: TransferParameters) {
        self.init()
        self.sendEnabled = parameters.isSendEnabled
        self.receiveEnabled = parameters.isReceiveEnabled
    }
}
