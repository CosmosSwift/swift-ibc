//package types
//
//import (
//	sdk "github.com/cosmos/cosmos-sdk/types"
//	"github.com/cosmos/cosmos-sdk/x/auth/types"
//	capabilitytypes "github.com/cosmos/cosmos-sdk/x/capability/types"
//	connectiontypes "github.com/cosmos/ibc-go/modules/core/03-connection/types"
//	channeltypes "github.com/cosmos/ibc-go/modules/core/04-channel/types"
//	ibcexported "github.com/cosmos/ibc-go/modules/core/exported"
//)

import Cosmos
import Auth
import Capability

// AccountKeeper defines the contract required for account APIs.
protocol AccountKeeper {
    func moduleAddress(name: String) -> AccountAddress
    func moduleAccount(request: Request, name: String) -> ModuleAccount?
}

// BankKeeper defines the expected bank keeper
protocol BankKeeper {
    func sendCoins(
        request: Request,
        from address: AccountAddress,
        to address: AccountAddress,
        amount: [Coin]
    ) throws
    
    func mintCoins(
        request: Request,
        moduleName: String,
        amount: [Coin]
    ) throws
    
	func burnCoins(
        request: Request,
        moduleName: String,
        amount: Coins
    ) throws
    
	func sendCoinsFromModuleToAccount(
        request: Request,
        senderModule: String,
        recipientAddress: AccountAddress,
        amount: Coins
    ) throws
    
	func sendCoinsFromAccountToModule(
        request: Request,
        senderAddress: AccountAddress,
        recipientModule: String,
        amount: Coins
    ) throws
}

//// ChannelKeeper defines the expected IBC channel keeper
//type ChannelKeeper interface {
//	GetChannel(ctx sdk.Context, srcPort, srcChan string) (channel channeltypes.Channel, found bool)
//	GetNextSequenceSend(ctx sdk.Context, portID, channelID string) (uint64, bool)
//	SendPacket(ctx sdk.Context, channelCap *capabilitytypes.Capability, packet ibcexported.PacketI) error
//	ChanCloseInit(ctx sdk.Context, portID, channelID string, chanCap *capabilitytypes.Capability) error
//}
//
//// ClientKeeper defines the expected IBC client keeper
//type ClientKeeper interface {
//	GetClientConsensusState(ctx sdk.Context, clientID string) (connection ibcexported.ConsensusState, found bool)
//}
//
//// ConnectionKeeper defines the expected IBC connection keeper
//type ConnectionKeeper interface {
//	GetConnection(ctx sdk.Context, connectionID string) (connection connectiontypes.ConnectionEnd, found bool)
//}

// PortKeeper defines the expected IBC port keeper
protocol PortKeeper {
    func bindPort(withId id: String, request: Request) -> Capability
}
