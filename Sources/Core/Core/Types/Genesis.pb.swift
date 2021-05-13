/*

TODO: substitute with the relevant proto generated file

*/

import CosmosProto
import Client
import Connection
import Channel

// GenesisState defines the ibc module's genesis state.
struct IBCGenesisState: Codable {
    // ICS002 - Clients genesis state
    let clientGenesis: ClientGenesisState
    // ICS003 - Connections genesis state
    let connectionGenesis: ConnectionGenesisState
    // ICS004 - Channel genesis state
    let channelGenesis: ChannelGenesisState
    
    private enum CodingKeys: String, CodingKey {
        case clientGenesis = "client_genesis"
        case connectionGenesis = "connection_genesis"
        case channelGenesis = "channel_genesis"
    }
}

extension IBCGenesisState {
    init(state: Ibc_Core_Types_V1_GenesisState) {
        self.clientGenesis = ClientGenesisState(state.clientGenesis)
        self.connectionGenesis = ConnectionGenesisState(state.connectionGenesis)
        self.channelGenesis = ChannelGenesisState(state.channelGenesis)
    }
}
