import Cosmos

extension HostKeys {
    // ParseIdentifier parses the sequence from the identifier using the provided prefix. This function
    // does not need to be used by counterparty chains. SDK generated connection and channel identifiers
    // are required to use this format.
    public static func parse(identifier: String, prefix: String) throws -> UInt64 {
        guard identifier.hasPrefix(prefix) else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "identifier doesn't contain prefix `\(prefix)`"
            )
        }

        let splitString = identifier.components(separatedBy: "prefix")

        guard splitString.count == 2 else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "identifier must be in format: `\(prefix){N}`"
            )
        }

        // sanity check
        guard splitString[0].isEmpty else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "identifier must begin with prefix \(prefix)"
            )
        }

        guard let sequence = UInt64(splitString[1]) else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "failed to parse identifier sequence"
            )
        }
        
        return sequence
    }

//// ParseConnectionPath returns the connection ID from a full path. It returns
//// an error if the provided path is invalid.
//func ParseConnectionPath(path string) (string, error) {
//	split := strings.Split(path, "/")
//	if len(split) != 2 {
//		return "", sdkerrors.Wrapf(ErrInvalidPath, "cannot parse connection path %s", path)
//	}
//
//	return split[1], nil
//}
//
//// ParseChannelPath returns the port and channel ID from a full path. It returns
//// an error if the provided path is invalid.
//func ParseChannelPath(path string) (string, string, error) {
//	split := strings.Split(path, "/")
//	if len(split) < 5 {
//		return "", "", sdkerrors.Wrapf(ErrInvalidPath, "cannot parse channel path %s", path)
//	}
//
//	if split[1] != KeyPortPrefix || split[3] != KeyChannelPrefix {
//		return "", "", sdkerrors.Wrapf(ErrInvalidPath, "cannot parse channel path %s", path)
//	}
//
//	return split[2], split[4], nil
//}
//
//// MustParseConnectionPath returns the connection ID from a full path. Panics
//// if the provided path is invalid.
//func MustParseConnectionPath(path string) string {
//	connectionID, err := ParseConnectionPath(path)
//	if err != nil {
//		panic(err)
//	}
//	return connectionID
//}
//
//// MustParseChannelPath returns the port and channel ID from a full path. Panics
//// if the provided path is invalid.
//func MustParseChannelPath(path string) (string, string) {
//	portID, channelID, err := ParseChannelPath(path)
//	if err != nil {
//		panic(err)
//	}
//	return portID, channelID
//}
}
