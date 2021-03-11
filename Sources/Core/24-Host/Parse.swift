import Cosmos

// ParseIdentifier parses the sequence from the identifier using the provided prefix. This function
// does not need to be used by counterparty chains. SDK generated connection and channel identifiers
// are required to use this format.
func parseIdentifier(_ identifier: String, _ prefix: String) throws -> UInt64 {
    
    if !identifier.hasPrefix(prefix) {
        throw CosmosError.wrap(error: CosmosError.invalidID, description: "identifier must have prefix `\(prefix)`")
    }

    let uint64Str = identifier.suffix(from: String.Index(utf16Offset: prefix.count, in: identifier))
    guard let sequence = UInt64(uint64Str) else {
        throw CosmosError.wrap(error: CosmosError.invalidID, description: "identifier should be in format `\(prefix)${UInt64}`")
    }
    return sequence
}

// ParseConnectionPath returns the connection ID from a full path. It returns
// an error if the provided path is invalid.
func parseConnectionPath(_ path: String) throws -> String {
    #warning("The original go code splits by /, and takes the 2nd instance. so it will be the first item after the first / ")
    guard let result = path.split(separator: "/").first else {
        throw CosmosError.wrap(error: CosmosError.invalidPath, description: "cannot parse connection path \(path)")
    }
    return String(result)
            
    /*
        split := strings.Split(path, "/")
        if len(split) != 2 {
            return "", sdkerrors.Wrapf(ErrInvalidPath, "cannot parse connection path %s", path)
        }

        return split[1], nil
   */
}

// ParseChannelPath returns the port and channel ID from a full path. It returns
// an error if the provided path is invalid.
func parseChannelPath(_ path: String) throws -> (String, String) {
    let split = path.split(separator: "/", omittingEmptySubsequences: false)
    
    if split.count < 5 || split[1] != PortKeys.keyPortPrefix || split[3] != PortKeys.keyChannelPrefix {
        throw CosmosError.wrap(error: CosmosError.invalidPath, description: "cannot parse channel path \(path)")
    }
    return (String(split[2]), String(split[4]))
}

// MustParseConnectionPath returns the connection ID from a full path. Panics
// if the provided path is invalid.
func mustParseConnectionPath(_ path: String) -> String {
    do {
        return try parseConnectionPath(path)
    } catch {
        fatalError(error.localizedDescription)
    }
}

// MustParseChannelPath returns the port and channel ID from a full path. Panics
// if the provided path is invalid.
func mustParseChannelPath(_ path: String) -> (String, String) {
    do {
        return try parseChannelPath(path)
    } catch {
        fatalError(error.localizedDescription)
    }
}

/*
package host

import (
	"strconv"
	"strings"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// ParseIdentifier parses the sequence from the identifier using the provided prefix. This function
// does not need to be used by counterparty chains. SDK generated connection and channel identifiers
// are required to use this format.
func ParseIdentifier(identifier, prefix string) (uint64, error) {
	if !strings.HasPrefix(identifier, prefix) {
		return 0, sdkerrors.Wrapf(ErrInvalidID, "identifier doesn't contain prefix `%s`", prefix)
	}

	splitStr := strings.Split(identifier, prefix)
	if len(splitStr) != 2 {
		return 0, sdkerrors.Wrapf(ErrInvalidID, "identifier must be in format: `%s{N}`", prefix)
	}

	// sanity check
	if splitStr[0] != "" {
		return 0, sdkerrors.Wrapf(ErrInvalidID, "identifier must begin with prefix %s", prefix)
	}

	sequence, err := strconv.ParseUint(splitStr[1], 10, 64)
	if err != nil {
		return 0, sdkerrors.Wrap(err, "failed to parse identifier sequence")
	}
	return sequence, nil
}

// ParseConnectionPath returns the connection ID from a full path. It returns
// an error if the provided path is invalid.
func ParseConnectionPath(path string) (string, error) {
	split := strings.Split(path, "/")
	if len(split) != 2 {
		return "", sdkerrors.Wrapf(ErrInvalidPath, "cannot parse connection path %s", path)
	}

	return split[1], nil
}

// ParseChannelPath returns the port and channel ID from a full path. It returns
// an error if the provided path is invalid.
func ParseChannelPath(path string) (string, string, error) {
	split := strings.Split(path, "/")
	if len(split) < 5 {
		return "", "", sdkerrors.Wrapf(ErrInvalidPath, "cannot parse channel path %s", path)
	}

	if split[1] != KeyPortPrefix || split[3] != KeyChannelPrefix {
		return "", "", sdkerrors.Wrapf(ErrInvalidPath, "cannot parse channel path %s", path)
	}

	return split[2], split[4], nil
}

// MustParseConnectionPath returns the connection ID from a full path. Panics
// if the provided path is invalid.
func MustParseConnectionPath(path string) string {
	connectionID, err := ParseConnectionPath(path)
	if err != nil {
		panic(err)
	}
	return connectionID
}

// MustParseChannelPath returns the port and channel ID from a full path. Panics
// if the provided path is invalid.
func MustParseChannelPath(path string) (string, string) {
	portID, channelID, err := ParseChannelPath(path)
	if err != nil {
		panic(err)
	}
	return portID, channelID
}

*/
