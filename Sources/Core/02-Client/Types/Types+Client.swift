//package types
//
//import (
//	"fmt"
//	"math"
//	"sort"
//	"strings"
//
//	proto "github.com/gogo/protobuf/proto"
//
//	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
//	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
//	host "github.com/cosmos/ibc-go/modules/core/24-host"
//	"github.com/cosmos/ibc-go/modules/core/exported"
//)
import Cosmos
import Host

//var (
//	_ codectypes.UnpackInterfacesMessage = IdentifiedClientState{}
//	_ codectypes.UnpackInterfacesMessage = ConsensusStateWithHeight{}
//)
//
//// NewIdentifiedClientState creates a new IdentifiedClientState instance
//func NewIdentifiedClientState(clientID string, clientState exported.ClientState) IdentifiedClientState {
//	msg, ok := clientState.(proto.Message)
//	if !ok {
//		panic(fmt.Errorf("cannot proto marshal %T", clientState))
//	}
//
//	anyClientState, err := codectypes.NewAnyWithValue(msg)
//	if err != nil {
//		panic(err)
//	}
//
//	return IdentifiedClientState{
//		ClientId:    clientID,
//		ClientState: anyClientState,
//	}
//}
//
//// UnpackInterfaces implements UnpackInterfacesMesssage.UnpackInterfaces
//func (ics IdentifiedClientState) UnpackInterfaces(unpacker codectypes.AnyUnpacker) error {
//	return unpacker.UnpackAny(ics.ClientState, new(exported.ClientState))
//}
//
//var _ sort.Interface = IdentifiedClientStates{}

// IdentifiedClientStates defines a slice of ClientConsensusStates that supports the sort interface
public typealias IdentifiedClientStates = [IdentifiedClientState]

//// Len implements sort.Interface
//func (ics IdentifiedClientStates) Len() int { return len(ics) }
//
//// Less implements sort.Interface
//func (ics IdentifiedClientStates) Less(i, j int) bool { return ics[i].ClientId < ics[j].ClientId }
//
//// Swap implements sort.Interface
//func (ics IdentifiedClientStates) Swap(i, j int) { ics[i], ics[j] = ics[j], ics[i] }
//
//// Sort is a helper function to sort the set of IdentifiedClientStates in place
//func (ics IdentifiedClientStates) Sort() IdentifiedClientStates {
//	sort.Sort(ics)
//	return ics
//}
//
//// NewConsensusStateWithHeight creates a new ConsensusStateWithHeight instance
//func NewConsensusStateWithHeight(height Height, consensusState exported.ConsensusState) ConsensusStateWithHeight {
//	msg, ok := consensusState.(proto.Message)
//	if !ok {
//		panic(fmt.Errorf("cannot proto marshal %T", consensusState))
//	}
//
//	anyConsensusState, err := codectypes.NewAnyWithValue(msg)
//	if err != nil {
//		panic(err)
//	}
//
//	return ConsensusStateWithHeight{
//		Height:         height,
//		ConsensusState: anyConsensusState,
//	}
//}
//
//// UnpackInterfaces implements UnpackInterfacesMesssage.UnpackInterfaces
//func (cswh ConsensusStateWithHeight) UnpackInterfaces(unpacker codectypes.AnyUnpacker) error {
//	return unpacker.UnpackAny(cswh.ConsensusState, new(exported.ConsensusState))
//}

// ValidateClientType validates the client type. It cannot be blank or empty. It must be a valid
// client identifier when used with '0' or the maximum uint64 as the sequence.
public func validate(clientType: String) throws {
    guard !clientType.trimmingCharacters(in: .whitespaces).isEmpty else {
        throw CosmosError.wrap(
            error: ClientError.invalidClientType,
            description: "client type cannot be blank"
        )
	}

    let smallestPossibleClientId = ClientKeys.formatClientIdentifier(
        clientType: clientType,
        sequence: 0
    )

    let largestPossibleClientId = ClientKeys.formatClientIdentifier(
        clientType: clientType,
        sequence: .max
    )

	// IsValidClientID will check client type format and if the sequence is a uint64
    guard ClientKeys.isValid(clientId: smallestPossibleClientId) else {
        throw CosmosError.wrap(
            error: ClientError.invalidClientType,
            description: ""
        )
	}

    do {
        try Host.clientIdentifierValidator(id: smallestPossibleClientId)
    } catch {
        throw CosmosError.wrap(
            error: error,
            description: "client type results in smallest client identifier being invalid"
        )
	}
    
    do {
        try Host.clientIdentifierValidator(id: largestPossibleClientId)
    } catch {
        throw CosmosError.wrap(
            error: error,
            description: "client type results in largest client identifier being invalid"
        )
    }
}
