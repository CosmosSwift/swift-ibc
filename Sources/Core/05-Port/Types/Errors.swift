import Cosmos

// IBC port sentinel errors
public enum PortError {
    public static let portExists = CosmosError.register(codespace: PortKeys.subModuleName, code: 2, description: "port is already binded")
    public static let portNotFound = CosmosError.register(codespace: PortKeys.subModuleName, code: 3, description: "port not found")
    public static let invalidPort  = CosmosError.register(codespace: PortKeys.subModuleName, code: 4, description: "invalid port")
    public static let invalidRoute = CosmosError.register(codespace: PortKeys.subModuleName, code: 5, description: "route not found")
}