/*

TODO: substitute with the relevant proto generated file

*/

import CosmosProto

// GenesisState defines the ibc connection submodule's genesis state.
public struct ConnectionGenesisState: Codable {
    let connections: [IdentifiedConnection]
    let clientConnectionPaths: [ConnectionPaths]
    // the sequence for the next generated connection identifier
    let nextConnectionSequence: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case connections
        case clientConnectionPaths = "client_connection_paths"
        case nextConnectionSequence = "next_connection_sequence"
    }
}

extension ConnectionGenesisState {
    public init(_ state: CosmosProto.Ibc_Core_Connection_V1_GenesisState) {
        self.connections = state.connections.map(IdentifiedConnection.init)
        self.clientConnectionPaths = state.clientConnectionPaths.map(ConnectionPaths.init)
        self.nextConnectionSequence = state.nextConnectionSequence
    }
}

