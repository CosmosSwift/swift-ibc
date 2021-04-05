//package keeper
//
//import (
//	tmbytes "github.com/tendermint/tendermint/libs/bytes"
//	"github.com/tendermint/tendermint/libs/log"
//
//	"github.com/cosmos/cosmos-sdk/codec"
//	"github.com/cosmos/cosmos-sdk/store/prefix"
//	sdk "github.com/cosmos/cosmos-sdk/types"
//	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
//	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
//	capabilitykeeper "github.com/cosmos/cosmos-sdk/x/capability/keeper"
//	capabilitytypes "github.com/cosmos/cosmos-sdk/x/capability/types"
//	"github.com/cosmos/ibc-go/modules/apps/transfer/types"
//	channeltypes "github.com/cosmos/ibc-go/modules/core/04-channel/types"
//	host "github.com/cosmos/ibc-go/modules/core/24-host"
//	paramtypes "github.com/cosmos/cosmos-sdk/x/params/types"
//)

import Database
import Tendermint
import Cosmos
import Params
import Auth
import Bank
import Capability
import Host

// Keeper defines the IBC fungible transfer keeper
public struct TransferKeeper {
	let storeKey: StoreKey
    let codec: Codec // TODO: codec.BinaryMarshaler
    let parameterSpace: Subspace
//
//	channelKeeper types.ChannelKeeper
    let portKeeper: PortKeeper
    let authKeeper: AccountKeeper
    let bankKeeper: BankKeeper
    let scopedKeeper: ScopedCapabilityKeeper
}

extension TransferKeeper {
//// NewKeeper creates a new IBC transfer Keeper instance
//func NewKeeper(
//	cdc codec.BinaryMarshaler, key sdk.StoreKey, paramSpace paramtypes.Subspace,
//	channelKeeper types.ChannelKeeper, portKeeper types.PortKeeper,
//	authKeeper types.AccountKeeper, bankKeeper types.BankKeeper, scopedKeeper capabilitykeeper.ScopedKeeper,
//) Keeper {
//
//	// ensure ibc transfer module account is set
//	if addr := authKeeper.GetModuleAddress(types.ModuleName); addr == nil {
//		panic("the IBC transfer module account has not been set")
//	}
//
//	// set KeyTable if it has not already been set
//	if !paramSpace.HasKeyTable() {
//		paramSpace = paramSpace.WithKeyTable(types.ParamKeyTable())
//	}
//
//	return Keeper{
//		cdc:           cdc,
//		storeKey:      key,
//		paramSpace:    paramSpace,
//		channelKeeper: channelKeeper,
//		portKeeper:    portKeeper,
//		authKeeper:    authKeeper,
//		bankKeeper:    bankKeeper,
//		scopedKeeper:  scopedKeeper,
//	}
//}
//
//// Logger returns a module-specific logger.
//func (k Keeper) Logger(ctx sdk.Context) log.Logger {
//	return ctx.Logger().With("module", "x/"+host.ModuleName+"-"+types.ModuleName)
//}

    // GetTransferAccount returns the ICS20 - transfers ModuleAccount
    func transferAccount(request: Request) -> ModuleAccount? {
        authKeeper.moduleAccount(request: request, name: TransferKeys.moduleName)
    }

//// ChanCloseInit defines a wrapper function for the channel Keeper's function
//// in order to expose it to the ICS20 transfer handler.
//func (k Keeper) ChanCloseInit(ctx sdk.Context, portID, channelID string) error {
//	capName := host.ChannelCapabilityPath(portID, channelID)
//	chanCap, ok := k.scopedKeeper.GetCapability(ctx, capName)
//	if !ok {
//		return sdkerrors.Wrapf(channeltypes.ErrChannelCapabilityNotFound, "could not retrieve channel capability at: %s", capName)
//	}
//	return k.channelKeeper.ChanCloseInit(ctx, portID, channelID, chanCap)
//}

    // IsBound checks if the transfer module is already bound to the desired port
    func isPortWithIdBound(id portId: String, request: Request) -> Bool {
        scopedKeeper.capability(name: HostKeys.portPath(portId: portId), request: request) != nil
    }

    // BindPort defines a wrapper function for the ort Keeper's function in
    // order to expose it to module's InitGenesis function
    func bindPort(withId portId: String, request: Request) throws {
        let capability = portKeeper.bindPort(withId: portId, request: request)
        
        try claim(
            capability: capability,
            name: HostKeys.portPath(portId: portId),
            request: request
        )
    }

    // GetPort returns the portID for the transfer module. Used in ExportGenesis
    func port(request: Request) -> String {
        let store = request.keyValueStore(key: storeKey)
        // TODO: I'm not sure about this force unwrap here.
        return store.get(key: TransferKeys.portKey)!.string
    }

    // SetPort sets the portID for the transfer module. Used in InitGenesis
    func setPort(withId portId: String, request: Request) {
        let store = request.keyValueStore(key: storeKey)
        store.set(key: TransferKeys.portKey, value: portId.data)
    }

//// GetDenomTrace retreives the full identifiers trace and base denomination from the store.
//func (k Keeper) GetDenomTrace(ctx sdk.Context, denomTraceHash tmbytes.HexBytes) (types.DenomTrace, bool) {
//	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.DenomTraceKey)
//	bz := store.Get(denomTraceHash)
//	if bz == nil {
//		return types.DenomTrace{}, false
//	}
//
//	denomTrace := k.MustUnmarshalDenomTrace(bz)
//	return denomTrace, true
//}

    // HasDenomTrace checks if a the key with the given denomination trace hash exists on the store.
    func has(denominationTrace hash: HexadecimalData, request: Request) -> Bool {
        let store = PrefixStore(
            parent: request.keyValueStore(key: storeKey),
            prefix: TransferKeys.denominationTraceKey
        )
        
        return store.has(key: hash.rawValue)
    }

    // SetDenomTrace sets a new {trace hash -> denom trace} pair to the store.
    func set(denominationTrace: DenominationTrace, request: Request) {
        let store = PrefixStore(
            parent: request.keyValueStore(key: storeKey),
            prefix: TransferKeys.denominationTraceKey
        )
        
        let data = mustMarshal(denominationTrace: denominationTrace)
        store.set(key: denominationTrace.hash.rawValue, value: data)
    }

    // GetAllDenomTraces returns the trace information for all the denominations.
    func allDenominationTraces(request: Request) -> Traces {
        var traces = Traces()
        
        iterateDenominationTraces(request: request) { denominationTrace in
            traces.append(denominationTrace)
            return false
        }

        return traces.sorted()
    }

    // IterateDenomTraces iterates over the denomination traces in the store
    // and performs a callback function.
    func iterateDenominationTraces(request: Request, body: (DenominationTrace) -> Bool) {
        let store = request.keyValueStore(key: storeKey)
        var iterator = store.prefixIterator(prefix: TransferKeys.denominationTraceKey)

        defer {
            iterator.close()
        }
        
        while iterator.isValid {
            defer {
                iterator.next()
            }

            let denominationTrace = mustUnmarshalDenominationTrace(data: iterator.value)
            
            if body(denominationTrace) {
                break
            }
        }
    }

    // AuthenticateCapability wraps the scopedKeeper's AuthenticateCapability function
    func authenticate(capability: Capability, name: String, request: Request) -> Bool {
        scopedKeeper.authenticate(capability: capability, name: name, request: request)
    }

    // ClaimCapability allows the transfer module that can claim a capability that IBC module
    // passes to it
    func claim(capability: Capability, name: String, request: Request) throws {
        try scopedKeeper.claim(capability: capability, name: name, request: request)
    }
}
