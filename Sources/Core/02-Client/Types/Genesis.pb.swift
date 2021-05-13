/*

TODO: substitute with the relevant proto generated file

*/

import Foundation
import CosmosProto

// GenesisState defines the ibc client submodule's genesis state.
public struct ClientGenesisState: Codable {
    // client states with their corresponding identifiers
    let clients: IdentifiedClientStates
    // consensus states from each client
    let clientsConsensus: ClientsConsensusStates
    // metadata from each client
    let clientsMetadata: [IdentifiedGenesisMetadata]
    let params: ClientParams
    // create localhost on initialization
    let createLocalhost: Bool
    // the sequence for the next generated client identifier
    let nextClientSequence: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case clients
        case clientsConsensus = "client_consensus"
        case clientsMetadata = "clients_metadata"
        case params = "params"
        case createLocalhost = "create_localhost"
        case nextClientSequence = "next_client_sequence"
    }
}

extension ClientGenesisState {
    public init(_ state: Ibc_Core_Client_V1_GenesisState) {
        self.clients = state.clients.map(IdentifiedClientState.init)
        self.clientsConsensus = state.clientsConsensus.map(ClientConsensusStates.init)
        self.clientsMetadata = state.clientsMetadata.map(IdentifiedGenesisMetadata.init)
        self.params = ClientParams(state.params)
        self.createLocalhost = state.createLocalhost
        self.nextClientSequence = state.nextClientSequence
    }
}

// IdentifiedGenesisMetadata has the client metadata with the corresponding
// client id.
public struct IdentifiedGenesisMetadata: Codable {
    let clientId: String
    let clientMetadata: [GenesisMetadata]
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientMetadata = "client_metadata"
    }
}

extension IdentifiedGenesisMetadata {
    init(_ metadata: Ibc_Core_Client_V1_IdentifiedGenesisMetadata) {
        self.clientId = metadata.clientID
        self.clientMetadata = metadata.clientMetadata.map(GenesisMetadata.init)
    }
}

// GenesisMetadata defines the genesis type for metadata that clients may return
// with ExportMetadata
public struct GenesisMetadata: Codable {
    // store key of metadata without clientID-prefix
    let key: Data
    // metadata value
    let value: Data
}

extension GenesisMetadata {
    init(_ metadata: Ibc_Core_Client_V1_GenesisMetadata) {
        self.key = metadata.key
        self.value = metadata.value
    }
}
