//package types
//
//import (
//	sdk "github.com/cosmos/cosmos-sdk/types"
//
//	capabilitytypes "github.com/cosmos/cosmos-sdk/x/capability/types"
//	channeltypes "github.com/cosmos/ibc-go/modules/core/04-channel/types"
//)

import Cosmos
import Foundation
//import Capability
import CosmosProto

// IBCModule defines an interface that implements all the callbacks
// that modules must define as specified in ICS-26
public protocol IBCModule {
	func onChannelOpenInit(
		request: Request,
		order: CosmosProto.Ibc_Core_Channel_V1_Order,
		connectionHops: [String],
		portId: String,
		channelId: String,
//		channelCapability: Capability,
		counterparty: CosmosProto.Ibc_Core_Channel_V1_Counterparty,
		version: String
	) throws

	func onChannelOpenTry(
		request: Request,
		order: CosmosProto.Ibc_Core_Channel_V1_Order,
		connectionHops: [String],
		portId: String,
		channelId: String,
//		channelCapability: Capability,
		counterparty: CosmosProto.Ibc_Core_Channel_V1_Counterparty,
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
		packet: CosmosProto.Ibc_Core_Channel_V1_Packet
	) throws -> (Result, Data)

	func onAcknowledgementPacket(
		request: Request,
		packet: CosmosProto.Ibc_Core_Channel_V1_Packet,
		acknowledgement: Data
	) throws -> Result

	func onTimeoutPacket(
		request: Request,
		packet: CosmosProto.Ibc_Core_Channel_V1_Packet
	) throws -> Result
}
