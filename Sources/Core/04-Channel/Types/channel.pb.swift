/*

TODO: substitute with the relevant proto generated file

*/

import Foundation
import Cosmos
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
    public let sourcePort: String
    // identifies the channel end on the sending chain.
    public let sourceChannel: String
    // identifies the port on the receiving chain.
    public let destinationPort: String
    // identifies the channel end on the receiving chain.
    public let destinationChannel: String
    // actual opaque bytes transferred directly to the application module
    public let data: Data
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

// Acknowledgement is the recommended acknowledgement format to be used by
// app-specific protocols.
// NOTE: The field numbers 21 and 22 were explicitly chosen to avoid accidental
// conflicts with other protobuf message formats used for acknowledgements.
// The first byte of any message with this format will be the non-ASCII values
// `0xaa` (result) or `0xb2` (error). Implemented as defined by ICS:
// https://github.com/cosmos/ics/tree/master/spec/ics-004-channel-and-packet-semantics#acknowledgement-envelope
public struct Acknowledgement: Codable {
    // response contains either a result or an error and must be non-empty
    //
    // Types that are valid to be assigned to Response:
    //    *Acknowledgement_Result
    //    *Acknowledgement_Error
    let response: AcknowledgementResponse
}

extension Acknowledgement {
    init(_ acknowledgement: Ibc_Core_Channel_V1_Acknowledgement) {
        switch acknowledgement.response {
        case .result(let data):
            self.response = .result(data)
        case .error(let error):
            self.response = .error(error)
        default:
            fatalError()
        }
    }
}

extension Ibc_Core_Channel_V1_Acknowledgement {
    init(_ acknowledgement: Acknowledgement) {
        self.init()
        
        switch acknowledgement.response {
        case .result(let data):
            self.response = .result(data)
        case .error(let error):
            self.response = .error(error)
        }
    }
}

public enum AcknowledgementResponse: Codable {
    case result(Data)
    case error(String)

    private enum CodingKeys: String, CodingKey {
        case type
        case value
    }
    
    private enum ResponseType: String, Codable {
        case result
        case error
    }
   
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ResponseType.self, forKey: .type)
        
        switch type {
        case .result:
            let data = try container.decode(Data.self, forKey: .value)
            self = .result(data)
        case .error:
            let error = try container.decode(String.self, forKey: .value)
            self = .error(error)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var containter = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .result(let result):
            try containter.encode(ResponseType.result, forKey: .type)
            try containter.encode(result, forKey: .value)
        case .error(let error):
            try containter.encode(ResponseType.error, forKey: .type)
            try containter.encode(error, forKey: .value)
        }
    }
    
    public var data: Data {
        Codec.channel.mustMarshalJSON(value: self)
    }
}
