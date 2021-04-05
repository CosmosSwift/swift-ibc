import Cosmos

// IBC client sentinel errors
public enum HostError {
    // SubModuleName defines the ICS 24 host
    static let hostCodespace = "host"
    
    public static let invalidId = CosmosError.register(codespace: Self.hostCodespace, code: 2, description: "invalid identifier")
    static let invalidPath = CosmosError.register(codespace: Self.hostCodespace, code: 3, description: "invalid path")
    static let invalidPacket = CosmosError.register(codespace: Self.hostCodespace, code: 4, description: "invalid packet")
}