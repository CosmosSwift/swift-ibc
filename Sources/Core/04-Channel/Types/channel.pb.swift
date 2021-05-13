import Foundation
import Cosmos
import CosmosProto
import Client

// IdentifiedChannel defines a channel with additional port and channel
// identifier fields.
struct IdentifiedChannel: Codable {
    // current state of the channel end
    let state: ChannelState
    // whether the channel is ordered or unordered
    let ordering: Ordering
    // counterparty channel end
    let counterparty: ChannelCounterparty
    // list of connection identifiers, in order, along which packets sent on
    // this channel will travel
    let connectionHops: [String]
    // opaque channel version, which is agreed upon during the handshake
    let version: String
    // port identifier
    let portId: String
    // channel identifier
    let channelId: String
    
    private enum CodingKeys: String, CodingKey {
        case state
        case ordering
        case counterparty
        case connectionHops = "connection_hops"
        case version
        case portId = "port_id"
        case channelId = "channel_id"
    }
}

extension IdentifiedChannel {
    init(_ channel: Ibc_Core_Channel_V1_IdentifiedChannel) {
        self.state = ChannelState(channel.state)
        self.ordering = Ordering(channel.ordering)
        self.counterparty = ChannelCounterparty(channel.counterparty)
        self.connectionHops = channel.connectionHops
        self.version = channel.version
        self.portId = channel.portID
        self.channelId = channel.portID
    }
}

// State defines if a channel is in one of the following states:
// CLOSED, INIT, TRYOPEN, OPEN or UNINITIALIZED.
public enum ChannelState: Int, Codable {
    // Default State
    case unitinialized = 0
    // A channel has just started the opening handshake.
    case initialized = 1
    // A channel has acknowledged the handshake step on the counterparty chain.
    case tryOpen = 2
    // A channel has completed the handshake. Open channels are
    // ready to send and receive packets.
    case open = 3
    // A channel has been closed and can no longer be used to send or receive
    // packets.
    case closed = 4
}

extension ChannelState {
    init(_ state: Ibc_Core_Channel_V1_State) {
        self.init(rawValue: state.rawValue)!
    }
}

// Order defines if a channel is ORDERED or UNORDERED
public enum Ordering: Int, Codable {
    // zero-value for channel ordering
    case none = 0
    // packets can be delivered in any order, which may differ from the order in
    // which they were sent.
    case unordered = 1
    // packets are delivered exactly in the order which they were sent
    case ordered = 2
}

extension Ordering {
    init(_ ordering: Ibc_Core_Channel_V1_Order) {
        self.init(rawValue: ordering.rawValue)!
    }
}

extension Ibc_Core_Channel_V1_Order {
    init(_ ordering: Ordering) {
        self.init(rawValue: ordering.rawValue)!
    }
}

// PacketState defines the generic type necessary to retrieve and store
// packet commitments, acknowledgements, and receipts.
// Caller is responsible for knowing the context necessary to interpret this
// state as a commitment, acknowledgement, or a receipt.
struct PacketState: Codable {
    // channel port identifier.
    let portId: String
    // channel unique identifier.
    let channelId: String
    // packet sequence.
    let sequence: UInt64
    // embedded data that represents packet state.
    let data: Data
    
    private enum CodingKeys: String, CodingKey {
        case portId = "port_id"
        case channelId = "channel_id"
        case sequence
        case data
    }
}

extension PacketState {
    init(_ state: Ibc_Core_Channel_V1_PacketState) {
        self.portId = state.portID
        self.channelId = state.channelID
        self.sequence = state.sequence
        self.data = state.data
    }
}

// Counterparty defines a channel end counterparty
public struct ChannelCounterparty: Codable {
    // port on the counterparty chain which owns the other end of the channel.
    let portId: String
    // channel end on the counterparty chain
    let channelId: String
    
    private enum CodingKeys: String, CodingKey {
        case portId = "port_id"
        case channelId = "channel_id"
    }
}

extension ChannelCounterparty {
    init(_ counterparty: Ibc_Core_Channel_V1_Counterparty) {
        self.portId = counterparty.portID
        self.channelId = counterparty.channelID
    }
}

extension Ibc_Core_Channel_V1_Counterparty {
    init(_ counterparty: ChannelCounterparty) {
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
    public let response: AcknowledgementResponse
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
