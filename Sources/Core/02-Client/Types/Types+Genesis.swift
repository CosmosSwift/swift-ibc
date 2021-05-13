//package types
//
//import (
//	"fmt"
//	"sort"
//
//	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
//	host "github.com/cosmos/ibc-go/modules/core/24-host"
//	"github.com/cosmos/ibc-go/modules/core/exported"
//)
//
//var (
//	_ codectypes.UnpackInterfacesMessage = IdentifiedClientState{}
//	_ codectypes.UnpackInterfacesMessage = ClientsConsensusStates{}
//	_ codectypes.UnpackInterfacesMessage = ClientConsensusStates{}
//	_ codectypes.UnpackInterfacesMessage = GenesisState{}
//)
//
//var (
//	_ sort.Interface           = ClientsConsensusStates{}
//	_ exported.GenesisMetadata = GenesisMetadata{}
//)

import SwiftProtobuf
import Cosmos
import IBCCoreExported
import Host

// ClientsConsensusStates defines a slice of ClientConsensusStates that supports the sort interface
public typealias ClientsConsensusStates = [ClientConsensusStates]

//// Len implements sort.Interface
//func (ccs ClientsConsensusStates) Len() int { return len(ccs) }
//
//// Less implements sort.Interface
//func (ccs ClientsConsensusStates) Less(i, j int) bool { return ccs[i].ClientId < ccs[j].ClientId }
//
//// Swap implements sort.Interface
//func (ccs ClientsConsensusStates) Swap(i, j int) { ccs[i], ccs[j] = ccs[j], ccs[i] }
//
//// Sort is a helper function to sort the set of ClientsConsensusStates in place
//func (ccs ClientsConsensusStates) Sort() ClientsConsensusStates {
//	sort.Sort(ccs)
//	return ccs
//}
//
//// UnpackInterfaces implements UnpackInterfacesMessage.UnpackInterfaces
//func (ccs ClientsConsensusStates) UnpackInterfaces(unpacker codectypes.AnyUnpacker) error {
//	for _, clientConsensus := range ccs {
//		if err := clientConsensus.UnpackInterfaces(unpacker); err != nil {
//			return err
//		}
//	}
//	return nil
//}
//
//// NewClientConsensusStates creates a new ClientConsensusStates instance.
//func NewClientConsensusStates(clientID string, consensusStates []ConsensusStateWithHeight) ClientConsensusStates {
//	return ClientConsensusStates{
//		ClientId:        clientID,
//		ConsensusStates: consensusStates,
//	}
//}
//
//// UnpackInterfaces implements UnpackInterfacesMessage.UnpackInterfaces
//func (ccs ClientConsensusStates) UnpackInterfaces(unpacker codectypes.AnyUnpacker) error {
//	for _, consStateWithHeight := range ccs.ConsensusStates {
//		if err := consStateWithHeight.UnpackInterfaces(unpacker); err != nil {
//			return err
//		}
//	}
//	return nil
//}

extension ClientGenesisState {
//// NewGenesisState creates a GenesisState instance.
//func NewGenesisState(
//	clients []IdentifiedClientState, clientsConsensus ClientsConsensusStates, clientsMetadata []IdentifiedGenesisMetadata,
//	params Params, createLocalhost bool, nextClientSequence uint64,
//) GenesisState {
//	return GenesisState{
//		Clients:            clients,
//		ClientsConsensus:   clientsConsensus,
//		ClientsMetadata:    clientsMetadata,
//		Params:             params,
//		CreateLocalhost:    createLocalhost,
//		NextClientSequence: nextClientSequence,
//	}
//}

    // DefaultGenesisState returns the ibc client submodule's default genesis state.
    public static let `default` = ClientGenesisState(
        clients: [],
        clientsConsensus: [],
        clientsMetadata: [],
        params: .default,
        createLocalhost: false,
        nextClientSequence: 0
    )

//// UnpackInterfaces implements UnpackInterfacesMessage.UnpackInterfaces
//func (gs GenesisState) UnpackInterfaces(unpacker codectypes.AnyUnpacker) error {
//	for _, client := range gs.Clients {
//		if err := client.UnpackInterfaces(unpacker); err != nil {
//			return err
//		}
//	}
//
//	return gs.ClientsConsensus.UnpackInterfaces(unpacker)
//}

    // Validate performs basic genesis state validation returning an error upon any
    // failure.
    public func validate() throws {
        struct ValidationError: Swift.Error, CustomStringConvertible {
            var description: String
        }
        
        // keep track of the max sequence to ensure it is less than
        // the next sequence used in creating client identifers.
        var maxSequence: UInt64 = 0
        try params.validate()
        var validClients: [String: String] = [:]

        for (i, client) in clients.enumerated() {
            do {
                try Host.clientIdentifierValidator(id: client.clientId)
            } catch {
                throw ValidationError(
                    description: "invalid client consensus state identifier \(client.clientId) index \(i): \(error)"
                )
            }
            
            let clientState: ClientState

            do {
                let any = try Google_Protobuf_Any(serializedData: client.clientState)
                clientState = try ClientState(unpackingAny: any)
            } catch {
                throw ValidationError(
                    description: "invalid client state with id \(client.clientId)"
                )
            }

            guard params.isAllowed(client: clientState.clientType) else {
                throw ValidationError(
                    description: "client type \(clientState.clientType) not allowed by genesis params"
                )
            }
            
            do {
                try clientState.validate()
            } catch {
                throw ValidationError(
                    description: "invalid client \(client) index \(i): \(error)"
                )
            }

            let (clientType, sequence) = try ClientKeys.parse(clientIdentifier: client.clientId)

            if clientType != clientState.clientType {
                throw ValidationError(
                    description: "client state type \(clientState.clientType) does not equal client type in client identifier \(clientType)"
                )
            }

            try Client.validate(clientType: clientType)

            if sequence > maxSequence {
                maxSequence = sequence
            }

            // add client id to validClients map
            validClients[client.clientId] = clientState.clientType
        }

        for clientConsensus in clientsConsensus {
            // check that consensus state is for a client in the genesis clients list
            guard let clientType = validClients[clientConsensus.clientId] else {
                throw ValidationError(
                    description: "consensus state in genesis has a client id \(clientConsensus.clientId) that does not map to a genesis client"
                )
            }

            for (i, consensusStateWithHeight) in clientConsensus.consensusStates.enumerated() {
                guard !consensusStateWithHeight.height.isZero else {
                    throw ValidationError(
                        description: "consensus state height cannot be zero"
                    )
                }
                
                let consensusState: ConsensusState

                do {
                    let any = try Google_Protobuf_Any(serializedData: consensusStateWithHeight.consensusState)
                    consensusState = try ConsensusState(unpackingAny: any)
                } catch {
                    throw ValidationError(
                        description: "invalid consensus state with client Id \(clientConsensus.clientId) at height \(consensusStateWithHeight.height)"
                    )
                }

                do {
                    try consensusState.validateBasic()
                } catch {
                    throw ValidationError(
                        description: "invalid client consensus state \(consensusState) clientID \(clientConsensus.clientId) index \(i): \(error)"
                    )
                }

                // ensure consensus state type matches client state type
                guard clientType == consensusState.clientType else {
                    throw ValidationError(
                        description: "consensus state client type \(consensusState.clientType) does not equal client state client type \(clientType)"
                    )
                }

            }
        }

        for clientMetadata in clientsMetadata {
            // check that metadata is for a client in the genesis clients list
            guard validClients[clientMetadata.clientId] != nil else {
                throw ValidationError(
                    description: "metadata in genesis has a client id \(clientMetadata.clientId) that does not map to a genesis client"
                )
            }

            for (i, genesisMetadata) in clientMetadata.clientMetadata.enumerated() {
                do {
                    try genesisMetadata.validate()
                } catch {
                    throw ValidationError(
                        description: "invalid client metadata \(genesisMetadata) clientId \(clientMetadata.clientId) index \(i): \(error)"
                    )
                }
            }
        }

        guard !createLocalhost || params.isAllowed(client: ExportedClientKeys.localhost) else {
            throw ValidationError(
                description: "localhost client is not registered on the allowlist"
            )
        }

        guard maxSequence == 0 || maxSequence < nextClientSequence else {
            throw ValidationError(
                description: "next client identifier sequence \(nextClientSequence) must be greater than the maximum sequence used in the provided client identifiers \(maxSequence)"
            )
        }
    }
}

extension GenesisMetadata {
//// NewGenesisMetadata is a constructor for GenesisMetadata
//func NewGenesisMetadata(key, val []byte) GenesisMetadata {
//	return GenesisMetadata{
//		Key:   key,
//		Value: val,
//	}
//}
//
//// GetKey returns the key of metadata. Implements exported.GenesisMetadata interface.
//func (gm GenesisMetadata) GetKey() []byte {
//	return gm.Key
//}
//
//// GetValue returns the value of metadata. Implements exported.GenesisMetadata interface.
//func (gm GenesisMetadata) GetValue() []byte {
//	return gm.Value
//}

    // Validate ensures key and value of metadata are not empty
    func validate() throws {
        struct ValidationError: Swift.Error, CustomStringConvertible {
            let description: String
        }
        
        guard !key.isEmpty else {
            throw ValidationError(description: "genesis metadata key cannot be empty")
        }
        
        guard !value.isEmpty else {
            throw ValidationError(description: "genesis metadata value cannot be empty")
        }
    }

//// NewIdentifiedGenesisMetadata takes in a client ID and list of genesis metadata for that client
//// and constructs a new IdentifiedGenesisMetadata.
//func NewIdentifiedGenesisMetadata(clientID string, gms []GenesisMetadata) IdentifiedGenesisMetadata {
//	return IdentifiedGenesisMetadata{
//		ClientId:       clientID,
//		ClientMetadata: gms,
//	}
//}
}
