import Foundation
import Cosmos
import Capability
import Channel

// IBCModule defines an interface that implements all the callbacks
// that modules must define as specified in ICS-26
public protocol IBCModule {
	func onChannelOpenInit(
		request: Request,
		order: Order,
		connectionHops: [String],
		portId: String,
		channelId: String,
		channelCapability: Capability,
		counterparty: Counterparty,
		version: String
	) throws

	func onChannelOpenTry(
		request: Request,
		order: Order,
		connectionHops: [String],
		portId: String,
		channelId: String,
		channelCapability: Capability,
		counterparty: Counterparty,
		version: String,
		counterpartyVersion: String
	) throws

	func onChannelOpenAcknowledgement(
		request: Request,
		portId: String,
		channelId: String,
		counterpartyVersion: String
	) throws

	func onChannelOpenConfirm(
		request: Request,
		portId: String,
		channelId: String
	) throws

	func onChannelCloseInit(
		request: Request,
		portId: String,
		channelId: String
	) throws

	func onChannelCloseConfirm(
		request: Request,
		portId: String,
		channelId: String
	) throws

	// OnRecvPacket must return the acknowledgement bytes
	// In the case of an asynchronous acknowledgement, nil should be returned.
	func onReceivePacket(
		request: Request,
		packet: Packet
	) throws -> (Result, Data)

	func onAcknowledgementPacket(
		request: Request,
		packet: Packet,
		acknowledgement: Data
	) throws -> Result

	func onTimeoutPacket(
		request: Request,
		packet: Packet
	) throws -> Result
}
