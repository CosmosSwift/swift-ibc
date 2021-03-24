import Cosmos

// IBC client sentinel errors
extension CosmosError {
    // SubModuleName defines the ICS 24 host
    static let hostCodespace = "host"
    
    static let invalidId = Self.register(codespace: Self.hostCodespace, code: 2, description: "invalid identifier")
    static let invalidPath = Self.register(codespace: Self.hostCodespace, code: 3, description: "invalid path")
    static let invalidPacket = Self.register(codespace: Self.hostCodespace, code: 4, description: "invalid packet")
}
