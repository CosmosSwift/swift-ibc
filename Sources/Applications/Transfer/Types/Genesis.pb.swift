/*

TODO: substitute with the relevant proto generated file

*/

import CosmosProto

// GenesisState defines the ibc-transfer genesis state
struct TransferGenesisState: Codable {
    let portId: String
    let denominationTraces: Traces
    let parameters: TransferParameters
    
    private enum CodingKeys: String, CodingKey {
        case portId = "port_id"
        case denominationTraces = "denom_traces"
        case parameters = "params"
    }
}

extension TransferGenesisState {
    init(_ genesisState: Ibc_Applications_Transfer_V1_GenesisState) {
        // TODO: Implement
        fatalError()
    }
}

extension Ibc_Applications_Transfer_V1_GenesisState {
    init(_ genesisState: TransferGenesisState) {
        self.init()
        // TODO: Implement
        fatalError()
    }
}

