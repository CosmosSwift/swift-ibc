/*

TODO: substitute with the relevant proto generated file

*/

import Foundation
import Tendermint
import CosmosProto
import SwiftProtobuf

// IdentifiedClientState defines a client state with an additional client
// identifier field.
public struct IdentifiedClientState: Codable {
    // client identifier
    let clientId: String
    // client state
    let clientState: Data
   
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientState = "client_state"
    }
}

extension IdentifiedClientState {
    init(_ state: Ibc_Core_Client_V1_IdentifiedClientState) {
        self.clientId = state.clientID
        #warning("Check if this is the best approach")
        self.clientState = try! state.clientState.serializedData()
    }
}

// ConsensusStateWithHeight defines a consensus state with an additional height
// field.
public struct ConsensusStateWithHeight: Codable {
    // consensus state height
    let height: Height
    // consensus state
    let consensusState: Data
    
    private enum CodingKeys: String, CodingKey {
        case height
        case consensusState = "consensus_state"
    }
}

extension ConsensusStateWithHeight {
    init(_ state: Ibc_Core_Client_V1_ConsensusStateWithHeight) {
        self.height = Height(state.height)
        self.consensusState = state.consensusState.value
    }
}

// ClientConsensusStates defines all the stored consensus states for a given
// client.
public struct ClientConsensusStates: Codable {
    // client identifier
    let clientId: String
    // consensus states and their heights associated with the client
    let consensusStates: [ConsensusStateWithHeight]
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case consensusStates = "consensus_states"
    }
}

extension ClientConsensusStates {
    init(_ states: Ibc_Core_Client_V1_ClientConsensusStates) {
        self.clientId = states.clientID
        self.consensusStates = states.consensusStates.map(ConsensusStateWithHeight.init)
    }
}

// Params defines the set of IBC light client parameters.
public struct ClientParams: Codable {
    // allowed_clients defines the list of allowed client state types.
    let allowedClients: [String]
    
    private enum CodingKeys: String, CodingKey {
        case allowedClients = "allowed_clients"
    }
}

extension ClientParams {
    init(_ params: Ibc_Core_Client_V1_Params) {
        self.allowedClients = params.allowedClients
    }
}

// Height is a monotonically increasing data type
// that can be compared against another Height for the purposes of updating and
// freezing clients
//
// Normally the RevisionHeight is incremented at each height while keeping
// RevisionNumber the same. However some consensus algorithms may choose to
// reset the height in certain conditions e.g. hard forks, state-machine
// breaking changes In these cases, the RevisionNumber is incremented so that
// height continues to be monitonically increasing even as the RevisionHeight
// gets reset
public struct Height: Codable {
    // the revision that the client is currently on
    let revisionNumber: UInt64
    // the height within the given revision
    let revisionHeight: UInt64
}

public extension Height {
    init(_ height: Ibc_Core_Client_V1_Height) {
        self.revisionNumber = height.revisionNumber
        self.revisionHeight = height.revisionHeight
    }
}

public extension Ibc_Core_Client_V1_Height {
    init(_ height: Height) {
        self.init()
        self.revisionNumber = height.revisionNumber
        self.revisionHeight = height.revisionHeight
    }
}
