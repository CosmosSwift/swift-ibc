//import (
//	"context"
//	"encoding/json"
//	"fmt"
//	"math"
//	"math/rand"
//
//	"github.com/grpc-ecosystem/grpc-gateway/runtime"
//
//	"github.com/gorilla/mux"
//	"github.com/spf13/cobra"
//
//	abci "github.com/tendermint/tendermint/abci/types"
//
//	"github.com/cosmos/cosmos-sdk/client"
//	"github.com/cosmos/cosmos-sdk/codec"
//	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
//	sdk "github.com/cosmos/cosmos-sdk/types"
//	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
//	"github.com/cosmos/cosmos-sdk/types/module"
//	simtypes "github.com/cosmos/cosmos-sdk/types/simulation"
//	capabilitytypes "github.com/cosmos/cosmos-sdk/x/capability/types"
//	"github.com/cosmos/ibc-go/modules/apps/transfer/client/cli"
//	"github.com/cosmos/ibc-go/modules/apps/transfer/keeper"
//	"github.com/cosmos/ibc-go/modules/apps/transfer/simulation"
//	"github.com/cosmos/ibc-go/modules/apps/transfer/types"
//	channeltypes "github.com/cosmos/ibc-go/modules/core/04-channel/types"
//	porttypes "github.com/cosmos/ibc-go/modules/core/05-port/types"
//	host "github.com/cosmos/ibc-go/modules/core/24-host"
//)

import Foundation
import JSON
import ABCIMessages
import Cosmos
import CosmosProto
import Port

// AppModuleBasic is the IBC Transfer AppModuleBasic
public class TransferAppModuleBasic: AppModuleBasic {
	// Name implements AppModuleBasic interface
	public var name: String {
		TransferKeys.moduleName
	}

	// RegisterLegacyAminoCodec implements AppModuleBasic interface
	public func register(codec: Codec) {
		registerLegacyAminoCodec(codec: codec)
	}

//	// RegisterInterfaces registers module concrete types into protobuf Any.
//	func registerInterfaces(registry: InterfaceRegistry) {
//		registerInterfaces(registry: registry)
//	}

	// DefaultGenesis returns default genesis state as raw bytes for the ibc
	// transfer module.
	public func defaultGenesis() -> JSON? {
        let data = Codec.transferCodec.mustMarshalJSON(value: TransferGenesisState.default)
        return Codec.transferCodec.mustUnmarshalJSON(data: data)
	}

	// ValidateGenesis performs genesis state validation for the ibc transfer module.
	public func validateGenesis(json: JSON) throws {
        let data = Codec.transferCodec.mustMarshalJSON(value: json)
        let genesisState: TransferGenesisState = Codec.transferCodec.mustUnmarshalJSON(data: data)
		return try genesisState.validate()
	}

//	// RegisterRESTRoutes implements AppModuleBasic interface
//		func (AppModuleBasic) RegisterRESTRoutes(clientCtx client.Context, rtr *mux.Router) {
//	}
//
//	// RegisterGRPCGatewayRoutes registers the gRPC Gateway routes for the ibc-transfer module.
//	func (AppModuleBasic) RegisterGRPCGatewayRoutes(clientCtx client.Context, mux *runtime.ServeMux) {
//		types.RegisterQueryHandlerClient(context.Background(), mux, types.NewQueryClient(clientCtx))
//	}
//
//	// GetTxCmd implements AppModuleBasic interface
//	func (AppModuleBasic) GetTxCmd() *cobra.Command {
//		return cli.NewTxCmd()
//	}
//
//	// GetQueryCmd implements AppModuleBasic interface
//	func (AppModuleBasic) GetQueryCmd() *cobra.Command {
//		return cli.GetQueryCmd()
//	}
}

// AppModule represents the AppModule for this module
public final class TransferAppModule: TransferAppModuleBasic, AppModule, IBCModule {
	let keeper: TransferKeeper

	// NewAppModule creates a new 20-transfer module
	public init(keeper: TransferKeeper) {
		self.keeper = keeper
        super.init()
	}

	// RegisterInvariants implements the AppModule interface
	func registerInvariants(invariantRegistry: InvariantRegistry) {
		// TODO: Implement
	}

	// Route implements the AppModule interface
    public var route: String {
        TransferKeys.routerKey
        // TODO: Update protocol requirements to latest version and implement
//		Route(key: routerKey, handler: Handler(keeper))
	}

	// QuerierRoute implements the AppModule interface
	public var querierRoute: String {
        TransferKeys.querierRoute
	}

	// LegacyQuerierHandler implements the AppModule interface
	func legacyQuerierHandler(codec: Codec) -> Querier {
        // TODO: Implement
        fatalError()
        // nil
	}

    // TODO: Update protocol requirements to latest version and implement
	// RegisterServices registers module services.
//	func registerServices(configurator: Configurator) {
//		register(messageServer: configurator.messageServer, keeper: keeper)
//		register(queryServer: configurator.queryServer, keeper: keeper)
//	}

	// InitGenesis performs genesis initialization for the ibc-transfer module. It returns
	// no validator updates.
	public func initGenesis(request: Request, json: JSON) -> [ValidatorUpdate] {
        let data = Codec.transferCodec.mustMarshalJSON(value: json)
        let genesisState: TransferGenesisState = Codec.transferCodec.mustUnmarshalJSON(data: data)
        keeper.initGenesis(request: request, genesisState: genesisState)
		return []
	}

	// ExportGenesis returns the exported genesis state as raw bytes for the ibc-transfer
	// module.
	public func exportGenesis(request: Request) -> JSON {
        let genesisState = keeper.exportGenesis(request: request)
        let data = Codec.transferCodec.mustMarshalJSON(value: genesisState)
        return Codec.transferCodec.mustUnmarshalJSON(data: data)
	}

	// ConsensusVersion implements AppModule/ConsensusVersion.
	public var consensusVersion: UInt64 {
		1
	}

	// BeginBlock implements the AppModule interface
	public func beginBlock(request: Request, beginBlockRequest: RequestBeginBlock) {}

	// EndBlock implements the AppModule interface
	public func endBlock(request: Request, endBlockRequest: RequestEndBlock) -> [ValidatorUpdate] {
        []
	}

	// AppModuleSimulation functions

//	// GenerateGenesisState creates a randomized GenState of the transfer module.
//	func (AppModule) GenerateGenesisState(simState *module.SimulationState) {
//		simulation.RandomizedGenState(simState)
//	}
//
//	// ProposalContents doesn't return any content functions for governance proposals.
//	func (AppModule) ProposalContents(_ module.SimulationState) []simtypes.WeightedProposalContent
//		return nil
//	}
//
//	// RandomizedParams creates randomized ibc-transfer param changes for the simulator.
//	func (AppModule) RandomizedParams(r *rand.Rand) []simtypes.ParamChange {
//		return simulation.ParamChanges(r)
//	}
//
//	// RegisterStoreDecoder registers a decoder for transfer module's types
//	func (am AppModule) RegisterStoreDecoder(sdr sdk.StoreDecoderRegistry) {
//		sdr[types.StoreKey] = simulation.NewDecodeStore(am.keeper)
//	}
//
//	// WeightedOperations returns the all the transfer module operations with their respective weights.
//	func (am AppModule) WeightedOperations(_ module.SimulationState) []simtypes.WeightedOperation {
//		return nil
//	}

	// ValidateTransferChannelParams does validation of a newly created transfer channel. A transfer
	// channel must be UNORDERED, use the correct port (by default 'transfer'), and use the current
	// supported version. Only 2^32 channels are allowed to be created.
	func validateTransferChannelParams(
		request: Request,
		keeper: TransferKeeper,
		order: CosmosProto.Ibc_Core_Channel_V1_Order,
		portId: String,
		channelId: String,
		version: String
	) throws {
        // TODO: Implement
        fatalError()
//		// NOTE: for escrow address security only 2^32 channels are allowed to be created
//		// Issue: https://github.com/cosmos/cosmos-sdk/issues/7737
//		let channelSequence = try parseChannelSequence(channelId)
//
//		guard channelSequence <= UInt32.max else {
//            throw CosmosError.wrap(
//                error: CosmosError.maxTransferChannels,
//                description: "channel sequence \(channelSequence) is greater than max allowed transfer channels \(UInt32.max)"
//            )
//		}
//
//		guard order == .unordered else {
//            throw CosmosError.wrap(
//                error: CosmosError.invalidChannelOrdering,
//                description: "expected \(CosmosProto.Ibc_Core_Channel_V1_Order.unordered) channel, got \(order) "
//            )
//		}
//
//		// Require portID is the portID transfer module is bound to
//		let boundPort = keeper.port(request: request)
//
//		guard boundPort == portId else {
//            throw CosmosError.wrap(
//                error: CosmosError.invalidPort,
//                description: "invalid port: \(portId), expected \(boundPort)"
//            )
//		}
//
//		guard version == Self.version else {
//            throw CosmosError.wrap(
//                error: CosmosError.invalidVersion,
//                description: "got \(version), expected \(Self.version)"
//            )
//		}
	}

	// OnChanOpenInit implements the IBCModule interface
	public func onChannelOpenInit(
		request: Request,
		order: Ibc_Core_Channel_V1_Order,
		connectionHops: [String],
		portId: String,
		channelId: String,
//		channelCapability: Capability,
        counterparty: Ibc_Core_Channel_V1_Counterparty,
		version: String
	) throws {
        // TODO: Implement
        fatalError()
//		try validateTransferChannelParams(
//			request: request,
//			keeper: keeper,
//			order: order,
//			portId: portId,
//			channelId: channelId,
//			version: version
//		)
//
//		// Claim channel capability passed back by IBC module
//		try keeper.claimCapability(
//			request: request,
////			channelCapability: channelCapability,
//			name: channelCapabilityPath(portID: portID, channelID: channelID)
//		)
	}

	// OnChanOpenTry implements the IBCModule interface
	public func onChannelOpenTry(
		request: Request,
		order: Ibc_Core_Channel_V1_Order,
		connectionHops: [String],
        portId: String,
        channelId: String,
//		channelCapability: Capability,
		counterparty: Ibc_Core_Channel_V1_Counterparty,
		version: String,
		counterpartyVersion: String
	) throws {
        // TODO: Implement
        fatalError()
//		try validateTransferChannelParams(
//			request: request,
//			keeper: keeper,
//			order: order,
//			portID: portID,
//			channelID: channelID,
//			version: version
//		)
//
//		guard counterpartyVersion == Self.version else {
//			return sdkerrors.Wrapf(types.ErrInvalidVersion, "invalid counterparty version: got: %s, expected %s", counterpartyVersion, types.Version)
//		}
//
//		// Module may have already claimed capability in OnChanOpenInit in the case of crossing hellos
//		// (ie chainA and chainB both call ChanOpenInit before one of them calls ChanOpenTry)
//		// If module can already authenticate the capability then module already owns it so we don't need to claim
//		// Otherwise, module does not have channel capability and we must claim it from IBC
//		let alreadyClaimedCapability = keeper.authenticateCapability(
//			request: request,
////			channelCapability: channelCapability,
//			name: channelCapabilityPath(portID: portID, channelID: channelID)
//		)
//
//		guard alreadyClaimedCapability else {
//			// Only claim channel capability passed back by IBC module if we do not already own it
//			try keeper.claimCapability(
//				request: request,
////				channelCapability: channelCapability,
//				name: channelCapabilityPath(portID: portID, channelID: channelID)
//			)
//		}
	}

	// OnChanOpenAck implements the IBCModule interface
	public func onChannelOpenAcknowledgement(
		request: Request,
		portId: String,
		channelId: String,
		counterpartyVersion: String
	) throws {
        // TODO: Implement
        fatalError()
//		guard counterpartyVersion == Self.version else {
//			return sdkerrors.Wrapf(types.ErrInvalidVersion, "invalid counterparty version: %s, expected %s", counterpartyVersion, types.Version)
//		}
	}

	// OnChanOpenConfirm implements the IBCModule interface
	public func onChannelOpenConfirm(
		request: Request,
		portId: String,
		channelId: String
	) throws {}

	// OnChanCloseInit implements the IBCModule interface
	public func onChannelCloseInit(
		request: Request,
		portId: String,
		channelId: String
	) throws {
        // TODO: Implement
        fatalError()
//		// Disallow user-initiated channel closing for transfer channels
//		sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "user cannot close channel")
	}

	// OnChanCloseConfirm implements the IBCModule interface
	public func onChannelCloseConfirm(
		request: Request,
		portId: String,
		channelId: String
	) throws {}

	// OnRecvPacket implements the IBCModule interface
	public func onReceivePacket(
		request: Request,
		packet: Ibc_Core_Channel_V1_Packet
	) throws -> (Result, Data) {
        // TODO: Implement
        fatalError()
//        let data: FungibleTokenPacket
//
//		do {
//			data = try JSONDecoder().decode(FungibleTokenPacket.self, from: packet.data)
//		} catch {
//			throw sdkerrors.Wrapf(sdkerrors.ErrUnknownRequest, "cannot unmarshal ICS-20 transfer packet data: %s", err.Error())
//		}
//
//		var acknowledgement = AcknowledgementResult(data: Data([1]))
//
//		do {
//			try keeper.onReceivePacket(
//				request: request,
//				packet: packet,
//				data: data
//			)
//		} catch {
//			acknowledgement = AcknowledgementError(error: error)
//		}
//
//		let event = Event(
//			type: .packet,
//			attributes: [
//				Attribute(sdk.AttributeKeyModule, types.ModuleName),
//				Attribute(types.AttributeKeyReceiver, data.Receiver),
//				Attribute(types.AttributeKeyDenom, data.Denom),
//				Attribute(types.AttributeKeyAmount, fmt.Sprintf("%d", data.Amount)),
//				Attribute(types.AttributeKeyAckSuccess, fmt.Sprintf("%t", err != nil)),
//			]
//		)
//
//		request.eventManager.emit(event: event)
//
//		// NOTE: acknowledgement will be written synchronously during IBC handler execution.
//		let result = Result(
//			events: request.eventManager.events.toABCIEvents()
//		)
//
//		return (result, acknowledgement.data)
	}

	// OnAcknowledgementPacket implements the IBCModule interface
	public func onAcknowledgementPacket(
		request: Request,
		packet: Ibc_Core_Channel_V1_Packet,
		acknowledgement: Data
	) throws -> Result {
        // TODO: Implement
        fatalError()
//		let acknowledgement: Acknowledgement
//
//		do {
//			acknowledgement = try JSONDecoder().decode(Acknowledgement.self, from: acknowledgement)
//		} catch {
//			throw sdkerrors.Wrapf(sdkerrors.ErrUnknownRequest, "cannot unmarshal ICS-20 transfer packet acknowledgement: %v", err)
//		}
//
//		let data: FungibleTokenPacketData
//
//		do {
//			data = try JSONDecoder().decode(FungibleTokenPacketData.self, from: packet.data)
//		} catch {
//			throw sdkerrors.Wrapf(sdkerrors.ErrUnknownRequest, "cannot unmarshal ICS-20 transfer packet data: %s", err.Error())
//		}
//
//		try keeper.onAcknowledgementPacket(
//			request: request,
//			packet: packet,
//			data: data,
//			acknowledgement: acknowledgement
//		)
//
//		let event = Event(
//			type: .packet,
//			attributes: [
//				Attribute(sdk.AttributeKeyModule, types.ModuleName),
//				Attribute(types.AttributeKeyReceiver, data.Receiver),
//				Attribute(types.AttributeKeyDenom, data.Denom),
//				Attribute(types.AttributeKeyAmount, fmt.Sprintf("%d", data.Amount)),
//				Attribute(types.AttributeKeyAck, ack.String()),
//			]
//		)
//
//		request.eventManager.emitEvent(event: event)
//
//		switch acknowledgement.response {
//			case let response as Acknowledgement_Result:
//                let event = Event(
//					type: .packet,
//					attributes: [
//						Attribute(types.AttributeKeyAckSuccess, string(response.result)),
//					]
//				)
//
//				request.eventManager.emitEvent(event: event)
//			case is Acknowledgement_Error:
//				let event = Event(
//					type: .packet,
//					attributes: [
//						Attribute(types.AttributeKeyAckError, response.error),
//					]
//				)
//
//				request.eventManager.emitEvent(event: event)
//		}
//
//		return Result(
//			events: request.eventManager.events.toABCIEvents()
//		)
	}

	// OnTimeoutPacket implements the IBCModule interface
	public func onTimeoutPacket(
		request: Request,
		packet: Ibc_Core_Channel_V1_Packet
	) throws -> Result {
        // TODO: Implement
        fatalError()
//		let data: FungibleTokenPacketData
//
//		do {
//			data = try JSONDecoder().decode(FungibleTokenPacketData.self, from: packet.data)
//		} catch {
//			throw sdkerrors.Wrapf(sdkerrors.ErrUnknownRequest, "cannot unmarshal ICS-20 transfer packet data: %s", err.Error())
//		}
//
//		// refund tokens
//		try keeper.onTimeoutPacket(
//			request: request,
//			packet: packet,
//			data: data
//		)
//
//		let event = Event(
//			type: .timeout,
//			attributes: [
//				Attribute(sdk.AttributeKeyModule, types.ModuleName),
//				Attribute(types.AttributeKeyRefundReceiver, data.Sender),
//				Attribute(types.AttributeKeyRefundDenom, data.Denom),
//				Attribute(types.AttributeKeyRefundAmount, fmt.Sprintf("%d", data.Amount)),
//			]
//		)
//
//		request.eventManager.emitEvent(event: event)
//
//		return Result(
//			events: request.eventManager.events.toABCIEvents()
//		)
	}
}
