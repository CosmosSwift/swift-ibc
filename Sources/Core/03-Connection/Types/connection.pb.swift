/*

TODO: substitute with the relevant proto generated file

*/

import CosmosProto
import Commitment

// IdentifiedConnection defines a connection with additional connection
// identifier field.
public struct IdentifiedConnection: Codable {
    // connection identifier.
    let id: String
    // client associated with this connection.
    let clientId: String
    // IBC version which can be utilised to determine encodings or protocols for
    // channels or packets utilising this connection
    let versions: [Version]
    // current state of the connection end.
    let state: ConnectionState
    // counterparty chain associated with this connection.
    let counterparty: ConnectionCounterparty
    // delay period associated with this connection.
    let delayPeriod: UInt64
    
    private enum CodingKeys: String, CodingKey {
        case id
        case clientId = "client_id"
        case versions
        case state
        case counterparty
        case delayPeriod = "delay_period"
    }
}

extension IdentifiedConnection {
    public init(_ connection: Ibc_Core_Connection_V1_IdentifiedConnection) {
        self.id = connection.id
        self.clientId = connection.clientID
        self.versions = connection.versions.map(Version.init)
        self.state = ConnectionState(connection.state)
        self.counterparty = ConnectionCounterparty(connection.counterparty)
        self.delayPeriod = connection.delayPeriod
    }
}

// Version defines the versioning scheme used to negotiate the IBC verison in
// the connection handshake.
struct Version: Codable {
    // unique version identifier
    let identifier: String
    // list of features compatible with the specified identifier
    let features: [String]
}

extension Version {
    init(_ version: Ibc_Core_Connection_V1_Version) {
        self.identifier = version.identifier
        self.features = version.features
    }
}

// State defines if a connection is in one of the following states:
// INIT, TRYOPEN, OPEN or UNINITIALIZED.
enum ConnectionState: Int, Codable {
    // Default State
    case unitialized = 0
    // A connection end has just started the opening handshake.
    case initialized = 1
    // A connection end has acknowledged the handshake step on the counterparty
    // chain.
    case tryOpen = 2
    // A connection end has completed the handshake.
    case open = 3
}

extension ConnectionState {
    init(_ state: Ibc_Core_Connection_V1_State) {
        self.init(rawValue: state.rawValue)!
    }
}

// Counterparty defines the counterparty chain associated with a connection end.
struct ConnectionCounterparty: Codable {
    // identifies the client on the counterparty chain associated with a given
    // connection.
    let clientId: String
    // identifies the connection end on the counterparty chain associated with a
    // given connection.
    let connectionId: String
    // commitment merkle prefix of the counterparty chain.
    let prefix: MerklePrefix
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case connectionId = "connection_id"
        case prefix
    }
}

extension ConnectionCounterparty {
    init(_ counterparty: Ibc_Core_Connection_V1_Counterparty) {
        self.clientId = counterparty.clientID
        self.connectionId = counterparty.connectionID
        self.prefix = MerklePrefix(counterparty.prefix)
    }
}

// ConnectionPaths define all the connection paths for a given client state.
public struct ConnectionPaths: Codable {
    // client state unique identifier
    let clientId: String
    // list of connection paths
    let paths: [String]
    
    private enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case paths
    }
}

extension ConnectionPaths {
    init(_ paths: Ibc_Core_Connection_V1_ConnectionPaths) {
        self.clientId = paths.clientID
        self.paths = paths.paths
    }
}
