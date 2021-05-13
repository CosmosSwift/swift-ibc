/*

TODO: substitute with the relevant proto generated file

*/

import CosmosProto

// GenesisState defines the ibc channel submodule's genesis state.
public struct ChannelGenesisState: Codable {
    let channels: [IdentifiedChannel]
    let acknowledgements: [PacketState]
    let commitments: [PacketState]
    let receipts: [PacketState]
    let sendSequences: [PacketSequence]
    let receiveSequences: [PacketSequence]
    let acknowledgementSequences: [PacketSequence]
    // the sequence for the next generated channel identifier
    let nextChannelSequence: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case channels
        case acknowledgements
        case commitments
        case receipts
        case sendSequences = "send_sequences"
        case receiveSequences = "recv_sequences"
        case acknowledgementSequences = "ack_sequences"
        case nextChannelSequence = "next_channel_sequence"
    }
}

extension ChannelGenesisState {
    public init(_ state: Ibc_Core_Channel_V1_GenesisState) {
        self.channels = state.channels.map(IdentifiedChannel.init)
        self.acknowledgements = state.acknowledgements.map(PacketState.init)
        self.commitments = state.commitments.map(PacketState.init)
        self.receipts = state.receipts.map(PacketState.init)
        self.sendSequences = state.sendSequences.map(PacketSequence.init)
        self.receiveSequences = state.recvSequences.map(PacketSequence.init)
        self.acknowledgementSequences = state.recvSequences.map(PacketSequence.init)
        self.nextChannelSequence = state.nextChannelSequence
    }
}

// PacketSequence defines the genesis type necessary to retrieve and store
// next send and receive sequences.
struct PacketSequence: Codable {
    let portId: String 
    let channelId: String 
    let sequence: UInt64 
    
    private enum CodingKeys: String, CodingKey {
        case portId = "port_id"
        case channelId = "channel_id"
        case sequence
    }
}

extension PacketSequence {
    init(_ sequence: Ibc_Core_Channel_V1_PacketSequence) {
        self.portId = sequence.portID
        self.channelId = sequence.channelID
        self.sequence = sequence.sequence
    }
}

