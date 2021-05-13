//package types
//
//import (
//	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
//	clienttypes "github.com/cosmos/ibc-go/modules/core/02-client/types"
//	connectiontypes "github.com/cosmos/ibc-go/modules/core/03-connection/types"
//	channeltypes "github.com/cosmos/ibc-go/modules/core/04-channel/types"
//)
//
//var _ codectypes.UnpackInterfacesMessage = GenesisState{}

extension IBCGenesisState {
    // DefaultGenesisState returns the ibc module's default genesis state.
    static let `default` = IBCGenesisState(
        clientGenesis: .default,
        connectionGenesis: .default,
        channelGenesis: .default
    )

//// UnpackInterfaces implements UnpackInterfacesMessage.UnpackInterfaces
//func (gs GenesisState) UnpackInterfaces(unpacker codectypes.AnyUnpacker) error {
//	return gs.ClientGenesis.UnpackInterfaces(unpacker)
//}

    // Validate performs basic genesis state validation returning an error upon any
    // failure.
    public func validate() throws {
        try clientGenesis.validate()
        #warning("TODO: Implement")
        fatalError()
//        try connectionGenesis.validate()
//        try channelGenesis.validate()
    }
}
