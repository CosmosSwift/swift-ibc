import Cosmos

// IBC port sentinel errors
public enum PortError {
//	ErrPortExists   = sdkerrors.Register(SubModuleName, 2, "port is already binded")
//	ErrPortNotFound = sdkerrors.Register(SubModuleName, 3, "port not found")
    public static let invalidPort  = CosmosError.register(codespace: PortKeys.subModuleName, code: 4, description: "invalid port")
//	ErrInvalidRoute = sdkerrors.Register(SubModuleName, 5, "route not found")
}
