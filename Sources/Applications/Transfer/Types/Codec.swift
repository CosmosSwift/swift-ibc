//package types
//
//import (
//	"github.com/cosmos/cosmos-sdk/codec"
//	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
//	sdk "github.com/cosmos/cosmos-sdk/types"
//	"github.com/cosmos/cosmos-sdk/types/msgservice"
//)

import Cosmos

extension Codec {
    // ModuleCdc defines the module codec
    public static let transferCodec = Codec()
}

// RegisterLegacyAminoCodec registers the necessary x/ibc transfer interfaces and concrete types
// on the provided LegacyAmino codec. These types are used for Amino JSON serialization.
func registerLegacyAminoCodec(codec: Codec) {
	TransferMessage.registerMetaType()
}

// RegisterInterfaces register the ibc transfer module interfaces to protobuf
// Any.
//func registerInterfaces(registry: InterfaceRegistry) {
//	TransferMessage.registerMetatype("cosmos-sdk/MsgTransfer")
//	registry.RegisterImplementations((*sdk.Msg)(nil), &MsgTransfer{})
//	msgservice.RegisterMsgServiceDesc(registry, &_Msg_serviceDesc)
//}

//var (
//	amino = codec.NewLegacyAmino()
//
//	// ModuleCdc references the global x/ibc-transfer module codec. Note, the codec
//	// should ONLY be used in certain instances of tests and for JSON encoding.
//	//
//	// The actual codec used for serialization should be provided to x/ibc transfer and
//	// defined at the application level.
//	ModuleCdc = codec.NewProtoCodec(codectypes.NewInterfaceRegistry())
//
//	// AminoCdc is a amino codec created to support amino json compatible msgs.
//	AminoCdc = codec.NewAminoCodec(amino)
//)

//func init() {
//	RegisterLegacyAminoCodec(amino)
//	amino.Seal()
//}
