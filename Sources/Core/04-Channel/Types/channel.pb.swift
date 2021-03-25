/*

TODO: substitute with the relevant proto generated file

*/

import Foundation
import CosmosProto
import Client

public enum Order: Int {
    case none = 0
    case unordered = 1
    case ordered = 2
}

extension Order {
    init(_ order: Ibc_Core_Channel_V1_Order) {
        self.init(rawValue: order.rawValue)!
    }
}

extension Ibc_Core_Channel_V1_Order {
    init(_ order: Order) {
        self.init(rawValue: order.rawValue)!
    }
}

// Counterparty defines a channel end counterparty
public struct Counterparty: Codable {
    // port on the counterparty chain which owns the other end of the channel.
    let portId: String
    // channel end on the counterparty chain
    let channelId: String
    
    private enum CodingKeys: String, CodingKey {
        case portId = "port_id"
        case channelId = "channel_id"
    }
}

extension Counterparty {
    init(_ counterparty: Ibc_Core_Channel_V1_Counterparty) {
        self.portId = counterparty.portID
        self.channelId = counterparty.channelID
    }
}

extension Ibc_Core_Channel_V1_Counterparty {
    init(_ counterparty: Counterparty) {
        self.init()
        self.portID = counterparty.portId
        self.channelID = counterparty.channelId
    }
}

// Packet defines a type that carries data across different chains through IBC
public struct Packet: Codable {
    // number corresponds to the order of sends and receives, where a Packet
    // with an earlier sequence number must be sent and received before a Packet
    // with a later sequence number.
    let sequence: UInt64
    // identifies the port on the sending chain.
    let sourcePort: String
    // identifies the channel end on the sending chain.
    let sourceChannel: String
    // identifies the port on the receiving chain.
    let destinationPort: String
    // identifies the channel end on the receiving chain.
    let destinationChannel: String
    // actual opaque bytes transferred directly to the application module
    let data: Data
    // block height after which the packet times out
    let timeoutHeight: Height
    // block timestamp (in nanoseconds) after which the packet times out
    let timeoutTimestamp: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case sequence
        case sourcePort = "source_port"
        case sourceChannel = "source_channel"
        case destinationPort = "destination_port"
        case destinationChannel = "destination_channel"
        case data
        case timeoutHeight = "timeout_height"
        case timeoutTimestamp = "timeout_timestamp"
    }
}

extension Packet {
    init(_ packet: Ibc_Core_Channel_V1_Packet) {
        self.sequence = packet.sequence
        self.sourcePort = packet.sourcePort
        self.sourceChannel = packet.sourceChannel
        self.destinationPort = packet.destinationPort
        self.destinationChannel = packet.destinationChannel
        self.data = packet.data
        self.timeoutHeight = Height(packet.timeoutHeight)
        self.timeoutTimestamp = packet.timeoutTimestamp
    }
}

extension Ibc_Core_Channel_V1_Packet {
    init(_ packet: Packet) {
        self.init()
        self.sequence = packet.sequence
        self.sourcePort = packet.sourcePort
        self.sourceChannel = packet.sourceChannel
        self.destinationPort = packet.destinationPort
        self.destinationChannel = packet.destinationChannel
        self.data = packet.data
        self.timeoutHeight = Ibc_Core_Client_V1_Height(packet.timeoutHeight)
        self.timeoutTimestamp = packet.timeoutTimestamp
    }
}
