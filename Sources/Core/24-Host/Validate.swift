import Foundation
import Cosmos


// DefaultMaxCharacterLength defines the default maximum character length used
// in validation of identifiers including the client, connection, port and
// channel identifiers.
//
// NOTE: this restriction is specific to this golang implementation of IBC. If
// your use case demands a higher limit, please open an issue and we will consider
// adjusting this restriction.
fileprivate let defaultMaxCharacterLength = 64

// IsValidID defines regular expression to check if the string consist of
// characters in one of the following categories only:
// - Alphanumeric
// - `.`, `_`, `+`, `-`, `#`
// - `[`, `]`, `<`, `>`

extension String {
    var IsValidID: Bool {
        let charSet = CharacterSet(charactersIn:
                                    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._+-#[]<>"
        )
        if self.rangeOfCharacter(from: charSet.inverted) == nil {
            return true
        } else {
            return false
        }
    }
}


// ICS 024 Identifier and Path Validation Implementation
//
// This file defines ValidateFn to validate identifier and path strings
// The spec for ICS 024 can be located here:
// https://github.com/cosmos/ics/tree/master/spec/ics-024-host-requirements

func defaultIdentifierValidator(_ id: String, _ min: Int, _ max: Int) throws -> Bool {
    if id.isEmpty {
        throw CosmosError.wrap(error: CosmosError.invalidID, description: "identifier cannot be blank")
    }
    // valid id must fit the length requirements
    if id.count < min || id.count > max {
        throw CosmosError.wrap(error: CosmosError.invalidID, description: "identifier \(id) has invalid length: \(id.count), must be between \(min)-\(max) characters")
    }
    // valid id must contain only lower alphabetic characters
    if !id.IsValidID {
        throw CosmosError.wrap(error: CosmosError.invalidID, description: "identifier \(id) must contain only alphanumeric or the following characters: '.', '_', '+', '-', '#', '[', ']', '<', '>'")
    }
    return true
}

// ClientIdentifierValidator is the default validator function for Client identifiers.
// A valid Identifier must be between 9-64 characters and only contain alphanumeric and some allowed
// special characters (see IsValidID).
func clientIdentifierValidator(_ id: String)  throws -> Bool {
    try defaultIdentifierValidator(id, 9, defaultMaxCharacterLength)
}

// ConnectionIdentifierValidator is the default validator function for Connection identifiers.
// A valid Identifier must be between 10-64 characters and only contain alphanumeric and some allowed
// special characters (see IsValidID).
func connectionIdentifierValidator(_ id: String)  throws -> Bool {
    try defaultIdentifierValidator(id, 10, defaultMaxCharacterLength)
}

// ChannelIdentifierValidator is the default validator function for Channel identifiers.
// A valid Identifier must be between 8-64 characters and only contain alphanumeric and some allowed
// special characters (see IsValidID).
func channelIdentifierValidator(_ id: String)  throws -> Bool {
    try defaultIdentifierValidator(id, 8, defaultMaxCharacterLength)
}

// PortIdentifierValidator is the default validator function for Port identifiers.
// A valid Identifier must be between 2-64 characters and only contain alphanumeric and some allowed
// special characters (see IsValidID).
func portIdentifierValidator(_ id: String)  throws -> Bool {
    try defaultIdentifierValidator(id, 2, defaultMaxCharacterLength)
}

// NewPathValidator takes in a Identifier Validator function and returns
// a Path Validator function which requires path to consist of `/`-separated valid identifiers,
// where a valid identifier is between 1-64 characters, contains only alphanumeric and some allowed
// special characters (see IsValidID), and satisfies the custom `idValidator` function.
func newPathValidator(idValidator: @escaping (String) throws -> Bool) -> (String) throws -> Bool {
    return { (path: String)  in
        if path.hasPrefix("/") || path.hasSuffix("/") || path.contains("//") {
            throw CosmosError.wrap(error: CosmosError.invalidPath, description: "path \(path) should not start or end with '/' or have empty parts")
        }
        
        let pathParts = path.split(separator: "/")
        
        for part in pathParts.map ({String($0)}) {
            if !(try idValidator(part)) {
                return false
            }
            do {
            if !(try defaultIdentifierValidator(part, 1, defaultMaxCharacterLength)) {
                return false
            }
            } catch {
                throw CosmosError.wrap(error: error, description: "path \(path) contains an invalid identifier: '\(part)'")
            }
        }
        return true
    }
}





/*
package host

import (
	"regexp"
	"strings"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// DefaultMaxCharacterLength defines the default maximum character length used
// in validation of identifiers including the client, connection, port and
// channel identifiers.
//
// NOTE: this restriction is specific to this golang implementation of IBC. If
// your use case demands a higher limit, please open an issue and we will consider
// adjusting this restriction.
const DefaultMaxCharacterLength = 64

// IsValidID defines regular expression to check if the string consist of
// characters in one of the following categories only:
// - Alphanumeric
// - `.`, `_`, `+`, `-`, `#`
// - `[`, `]`, `<`, `>`
var IsValidID = regexp.MustCompile(`^[a-zA-Z0-9\.\_\+\-\#\[\]\<\>]+$`).MatchString

// ICS 024 Identifier and Path Validation Implementation
//
// This file defines ValidateFn to validate identifier and path strings
// The spec for ICS 024 can be located here:
// https://github.com/cosmos/ics/tree/master/spec/ics-024-host-requirements

// ValidateFn function type to validate path and identifier bytestrings
type ValidateFn func(string) error

func defaultIdentifierValidator(id string, min, max int) error { //nolint:unparam
	if strings.TrimSpace(id) == "" {
		return sdkerrors.Wrap(ErrInvalidID, "identifier cannot be blank")
	}
	// valid id MUST NOT contain "/" separator
	if strings.Contains(id, "/") {
		return sdkerrors.Wrapf(ErrInvalidID, "identifier %s cannot contain separator '/'", id)
	}
	// valid id must fit the length requirements
	if len(id) < min || len(id) > max {
		return sdkerrors.Wrapf(ErrInvalidID, "identifier %s has invalid length: %d, must be between %d-%d characters", id, len(id), min, max)
	}
	// valid id must contain only lower alphabetic characters
	if !IsValidID(id) {
		return sdkerrors.Wrapf(
			ErrInvalidID,
			"identifier %s must contain only alphanumeric or the following characters: '.', '_', '+', '-', '#', '[', ']', '<', '>'",
			id,
		)
	}
	return nil
}

// ClientIdentifierValidator is the default validator function for Client identifiers.
// A valid Identifier must be between 9-64 characters and only contain alphanumeric and some allowed
// special characters (see IsValidID).
func ClientIdentifierValidator(id string) error {
	return defaultIdentifierValidator(id, 9, DefaultMaxCharacterLength)
}

// ConnectionIdentifierValidator is the default validator function for Connection identifiers.
// A valid Identifier must be between 10-64 characters and only contain alphanumeric and some allowed
// special characters (see IsValidID).
func ConnectionIdentifierValidator(id string) error {
	return defaultIdentifierValidator(id, 10, DefaultMaxCharacterLength)
}

// ChannelIdentifierValidator is the default validator function for Channel identifiers.
// A valid Identifier must be between 8-64 characters and only contain alphanumeric and some allowed
// special characters (see IsValidID).
func ChannelIdentifierValidator(id string) error {
	return defaultIdentifierValidator(id, 8, DefaultMaxCharacterLength)
}

// PortIdentifierValidator is the default validator function for Port identifiers.
// A valid Identifier must be between 2-64 characters and only contain alphanumeric and some allowed
// special characters (see IsValidID).
func PortIdentifierValidator(id string) error {
	return defaultIdentifierValidator(id, 2, DefaultMaxCharacterLength)
}

// NewPathValidator takes in a Identifier Validator function and returns
// a Path Validator function which requires path to consist of `/`-separated valid identifiers,
// where a valid identifier is between 1-64 characters, contains only alphanumeric and some allowed
// special characters (see IsValidID), and satisfies the custom `idValidator` function.
func NewPathValidator(idValidator ValidateFn) ValidateFn {
	return func(path string) error {
		pathArr := strings.Split(path, "/")
		if len(pathArr) > 0 && pathArr[0] == path {
			return sdkerrors.Wrapf(ErrInvalidPath, "path %s doesn't contain any separator '/'", path)
		}

		for _, p := range pathArr {
			// a path beginning or ending in a separator returns empty string elements.
			if p == "" {
				return sdkerrors.Wrapf(ErrInvalidPath, "path %s cannot begin or end with '/'", path)
			}

			if err := idValidator(p); err != nil {
				return err
			}
			// Each path element must either be a valid identifier or constant number
			if err := defaultIdentifierValidator(p, 1, DefaultMaxCharacterLength); err != nil {
				return sdkerrors.Wrapf(err, "path %s contains an invalid identifier: '%s'", path, p)
			}
		}

		return nil
	}
}

*/
