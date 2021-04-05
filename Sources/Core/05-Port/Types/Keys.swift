public enum PortKeys {
	// SubModuleName defines the IBC port name
    static let subModuleName = "port"

	// StoreKey is the store key string for IBC ports
    static let storeKey = subModuleName

	// RouterKey is the message route for IBC ports
	static let routerKey = subModuleName

	// QuerierRoute is the querier route for IBC ports
	static let querierRoute = subModuleName
}