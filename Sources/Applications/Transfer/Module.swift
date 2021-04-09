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
import Capability
import Channel
import Port
import Host

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
		order: Order,
		portId: String,
		channelId: String,
		version: String
	) throws {
		// NOTE: for escrow address security only 2^32 channels are allowed to be created
		// Issue: https://github.com/cosmos/cosmos-sdk/issues/7737
        let channelSequence = try ChannelKeys.parseChannelSequence(channelId: channelId)

		guard channelSequence <= UInt32.max else {
            throw CosmosError.wrap(
                error: TransferError.maxTransferChannels,
                description: "channel sequence \(channelSequence) is greater than max allowed transfer channels \(UInt32.max)"
            )
		}

		guard order == .unordered else {
            throw CosmosError.wrap(
                error: ChannelError.invalidChannelOrdering,
                description: "expected \(Order.unordered) channel, got \(order) "
            )
		}

		// Require portID is the portID transfer module is bound to
		let boundPort = keeper.port(request: request)

		guard boundPort == portId else {
            throw CosmosError.wrap(
                error: PortError.invalidPort,
                description: "invalid port: \(portId), expected \(boundPort)"
            )
		}

		guard version == TransferKeys.version else {
            throw CosmosError.wrap(
                error: TransferError.invalidVersion,
                description: "got \(version), expected \(TransferKeys.version)"
            )
		}
	}

	// OnChanOpenInit implements the IBCModule interface
	public func onChannelOpenInit(
		request: Request,
		order: Order,
		connectionHops: [String],
		portId: String,
		channelId: String,
		channelCapability: Capability,
        counterparty: Counterparty,
		version: String
	) throws {
		try validateTransferChannelParams(
			request: request,
			keeper: keeper,
			order: order,
			portId: portId,
			channelId: channelId,
			version: version
		)

		// Claim channel capability passed back by IBC module
		try keeper.claim(
			capability: channelCapability,
            name: HostKeys.channelCapabilityPath(portId: portId, channelId: channelId),
            request: request
		)
	}

	// OnChanOpenTry implements the IBCModule interface
	public func onChannelOpenTry(
		request: Request,
		order: Order,
		connectionHops: [String],
        portId: String,
        channelId: String,
		channelCapability: Capability,
		counterparty: Counterparty,
		version: String,
		counterpartyVersion: String
	) throws {
		try validateTransferChannelParams(
			request: request,
			keeper: keeper,
			order: order,
			portId: portId,
			channelId: channelId,
			version: version
		)

		guard counterpartyVersion == TransferKeys.version else {
            throw CosmosError.wrap(
                error: TransferError.invalidVersion,
                description: "invalid counterparty version: got: \(counterpartyVersion), expected \(TransferKeys.version)"
            )
		}

		// Module may have already claimed capability in OnChanOpenInit in the case of crossing hellos
		// (ie chainA and chainB both call ChanOpenInit before one of them calls ChanOpenTry)
		// If module can already authenticate the capability then module already owns it so we don't need to claim
		// Otherwise, module does not have channel capability and we must claim it from IBC
		let alreadyClaimedCapability = keeper.authenticate(
			capability: channelCapability,
            name: HostKeys.channelCapabilityPath(portId: portId, channelId: channelId),
            request: request
		)

		guard alreadyClaimedCapability else {
			// Only claim channel capability passed back by IBC module if we do not already own it
			return try keeper.claim(
                capability: channelCapability,
                name: HostKeys.channelCapabilityPath(portId: portId, channelId: channelId),
                request: request
			)
		}
	}

	// OnChanOpenAck implements the IBCModule interface
	public func onChannelOpenAcknowledgement(
		request: Request,
		portId: String,
		channelId: String,
		counterpartyVersion: String
	) throws {
		guard counterpartyVersion == TransferKeys.version else {
            throw CosmosError.wrap(
                error: TransferError.invalidVersion,
                description: "invalid counterparty version: \(counterpartyVersion), expected \(TransferKeys.version)"
            )
		}
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
		// Disallow user-initiated channel closing for transfer channels
        throw CosmosError.wrap(
            error: CosmosError.invalidRequest,
            description: "user cannot close channel"
        )
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
		packet: Packet
	) throws -> (Result, Data) {
        let data: FungibleTokenPacketData

		do {
			data = try JSONDecoder().decode(FungibleTokenPacketData.self, from: packet.data)
		} catch {
            throw CosmosError.wrap(
                error: CosmosError.unknownRequest,
                description: "cannot unmarshal ICS-20 transfer packet data: \(error)"
            )
		}

        var acknowledgement = AcknowledgementResponse.result(Data([1]))
        let acknowledgementSuccess: Bool
        
		do {
			try keeper.onReceive(
				packet: packet,
				data: data,
                request: request
			)
            acknowledgementSuccess = true
		} catch {
            acknowledgement = AcknowledgementResponse.error(error.localizedDescription)
            acknowledgementSuccess = false
		}

		let event = Event(
			type: TransferEventType.packet,
			attributes: [
                Attribute(key: AttributeKey.module, value: TransferKeys.moduleName),
                Attribute(key: TransferAttributeKey.receiver, value: data.receiver),
                Attribute(key: TransferAttributeKey.denomination, value: data.denomination),
                Attribute(key: TransferAttributeKey.amount, value: "\(data.amount)"),
                Attribute(key: TransferAttributeKey.acknowledgementSuccess, value: "\(acknowledgementSuccess)"),
			]
		)

		request.eventManager.emit(event: event)

		// NOTE: acknowledgement will be written synchronously during IBC handler execution.
		let result = Result(
            events: request.eventManager.events // .toABCIEvents()
		)

		return (result, acknowledgement.data)
	}

	// OnAcknowledgementPacket implements the IBCModule interface
	public func onAcknowledgementPacket(
		request: Request,
		packet: Packet,
		acknowledgement data: Data
	) throws -> Result {
		let acknowledgement: Acknowledgement

		do {
            acknowledgement = try Codec.transferCodec.unmarshalJSON(data: data)
		} catch {
            throw CosmosError.wrap(
                error: CosmosError.unknownRequest,
                description: "cannot unmarshal ICS-20 transfer packet acknowledgement: \(error)"
            )
		}

		let data: FungibleTokenPacketData

		do {
            data = try Codec.transferCodec.unmarshalJSON(data: packet.data)
		} catch {
            throw CosmosError.wrap(
                error: CosmosError.unknownRequest,
                description: "cannot unmarshal ICS-20 transfer packet data: \(error)"
			)
		}

		try keeper.onAcknowledgementPacket(
			request: request,
			packet: packet,
			data: data,
			acknowledgement: acknowledgement
		)

		let event = Event(
			type: TransferEventType.packet,
			attributes: [
                Attribute(key: AttributeKey.module, value: TransferKeys.moduleName),
                Attribute(key: TransferAttributeKey.receiver, value: data.receiver),
                Attribute(key: TransferAttributeKey.denomination, value: data.denomination),
                Attribute(key: TransferAttributeKey.amount, value: "\(data.amount)"),
                // TODO: Maybe we need to implement CustomStringConvertible on the Acknowledgement type
                // so that we have some specific string representation
                Attribute(key: TransferAttributeKey.acknowledgement, value: "\(acknowledgement)"),
			]
		)

		request.eventManager.emit(event: event)

		switch acknowledgement.response {
        case .result(let result):
                let event = Event(
					type: TransferEventType.packet,
					attributes: [
                        Attribute(key: TransferAttributeKey.acknowledgementSuccess, value: "\(result)"),
					]
				)

				request.eventManager.emit(event: event)
        case .error(let error):
				let event = Event(
					type: TransferEventType.packet,
					attributes: [
                        Attribute(key: TransferAttributeKey.acknowledgementError, value: error),
					]
				)

				request.eventManager.emit(event: event)
		}

		return Result(
			events: request.eventManager.events // .toABCIEvents()
		)
	}

	// OnTimeoutPacket implements the IBCModule interface
	public func onTimeoutPacket(
		request: Request,
		packet: Packet
	) throws -> Result {
		let data: FungibleTokenPacketData

		do {
            data = try Codec.transferCodec.unmarshalJSON(data: packet.data)
		} catch {
            throw CosmosError.wrap(
                error: CosmosError.unknownRequest,
                description: "cannot unmarshal ICS-20 transfer packet data: \(error)"
            )
		}

		// refund tokens
		try keeper.onTimeoutPacket(
			request: request,
			packet: packet,
			data: data
		)

		let event = Event(
			type: TransferEventType.timeout,
			attributes: [
                Attribute(key: AttributeKey.module, value: TransferKeys.moduleName),
                Attribute(key: TransferAttributeKey.refundReceiver, value: data.sender),
                Attribute(key: TransferAttributeKey.refundDenomination, value: data.denomination),
                Attribute(key: TransferAttributeKey.refundAmount, value: "\(data.amount)"),
			]
		)

		request.eventManager.emit(event: event)

		return Result(
			events: request.eventManager.events // .toABCIEvents()
		)
	}
}
