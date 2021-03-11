import Cosmos

public enum PortKeys {
    // SubModuleName defines the IBC port name
    public static let subModuleName = "port"

    // StoreKey is the store key string for IBC ports
    public static let storeKey = subModuleName

    // RouterKey is the message route for IBC ports
    public static let routerKey = subModuleName

    // QuerierRoute is the querier route for IBC ports
    public static let querierRoute = storeKey
}


/*
package types

const (
	// SubModuleName defines the IBC port name
	SubModuleName = "port"

	// StoreKey is the store key string for IBC ports
	StoreKey = SubModuleName

	// RouterKey is the message route for IBC ports
	RouterKey = SubModuleName

	// QuerierRoute is the querier route for IBC ports
	QuerierRoute = SubModuleName
)
*/
