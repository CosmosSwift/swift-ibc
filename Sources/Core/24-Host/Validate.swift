import Foundation
import Cosmos

// DefaultMaxCharacterLength defines the default maximum character length used
// in validation of identifiers including the client, connection, port and
// channel identifiers.
//
// NOTE: this restriction is specific to this golang implementation of IBC. If
// your use case demands a higher limit, please open an issue and we will consider
// adjusting this restriction.
let defaultMaxCharacterLength = 64

// IsValidID defines regular expression to check if the string consist of
// characters in one of the following categories only:
// - Alphanumeric
// - `.`, `_`, `+`, `-`, `#`
// - `[`, `]`, `<`, `>`
func isValid(id: String) -> Bool {
    id.range(of: #"^[a-zA-Z0-9\.\_\+\-\#\[\]\<\>]+$"#, options: .regularExpression) != nil
}

// ICS 024 Identifier and Path Validation Implementation
//
// This file defines ValidateFn to validate identifier and path strings
// The spec for ICS 024 can be located here:
// https://github.com/cosmos/ics/tree/master/spec/ics-024-host-requirements

// ValidateFn function type to validate path and identifier bytestrings
typealias ValidateFunction = (String) throws -> Void

extension Host {
    private static func defaultIdentifierValidator(id: String, min: Int, max: Int) throws {
        guard !id.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "identifier cannot be blank"
            )
        }
        
        // valid id MUST NOT contain "/" separator
        guard !id.contains("/") else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "identifier \(id) cannot contain separator '/'"
            )
        }
        
        // valid id must fit the length requirements
        guard id.count > min && id.count < max else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "identifier \(id) has invalid length: \(id.count), must be between \(min)-\(max) characters"
            )
        }
        
        // valid id must contain only lower alphabetic characters
        guard isValid(id: id) else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "identifier \(id) must contain only alphanumeric or the following characters: '.', '_', '+', '-', '#', '[', ']', '<', '>'"
            )
        }
    }

    //// ClientIdentifierValidator is the default validator function for Client identifiers.
    //// A valid Identifier must be between 9-64 characters and only contain alphanumeric and some allowed
    //// special characters (see IsValidID).
    //func ClientIdentifierValidator(id string) error {
    //	return defaultIdentifierValidator(id, 9, DefaultMaxCharacterLength)
    //}
    //
    //// ConnectionIdentifierValidator is the default validator function for Connection identifiers.
    //// A valid Identifier must be between 10-64 characters and only contain alphanumeric and some allowed
    //// special characters (see IsValidID).
    //func ConnectionIdentifierValidator(id string) error {
    //	return defaultIdentifierValidator(id, 10, DefaultMaxCharacterLength)
    //}

    // ChannelIdentifierValidator is the default validator function for Channel identifiers.
    // A valid Identifier must be between 8-64 characters and only contain alphanumeric and some allowed
    // special characters (see IsValidID).
    public static func channelIdentifierValidator(id: String) throws {
        try defaultIdentifierValidator(
            id: id,
            min: 8,
            max: defaultMaxCharacterLength
        )
    }

    // PortIdentifierValidator is the default validator function for Port identifiers.
    // A valid Identifier must be between 2-64 characters and only contain alphanumeric and some allowed
    // special characters (see IsValidID).
public static func portIdentifierValidator(id: String) throws {
        try defaultIdentifierValidator(
            id: id,
            min: 2,
            max: defaultMaxCharacterLength
        )
    }

    //// NewPathValidator takes in a Identifier Validator function and returns
    //// a Path Validator function which requires path to consist of `/`-separated valid identifiers,
    //// where a valid identifier is between 1-64 characters, contains only alphanumeric and some allowed
    //// special characters (see IsValidID), and satisfies the custom `idValidator` function.
    //func NewPathValidator(idValidator ValidateFn) ValidateFn {
    //	return func(path string) error {
    //		pathArr := strings.Split(path, "/")
    //		if len(pathArr) > 0 && pathArr[0] == path {
    //			return sdkerrors.Wrapf(ErrInvalidPath, "path %s doesn't contain any separator '/'", path)
    //		}
    //
    //		for _, p := range pathArr {
    //			// a path beginning or ending in a separator returns empty string elements.
    //			if p == "" {
    //				return sdkerrors.Wrapf(ErrInvalidPath, "path %s cannot begin or end with '/'", path)
    //			}
    //
    //			if err := idValidator(p); err != nil {
    //				return err
    //			}
    //			// Each path element must either be a valid identifier or constant number
    //			if err := defaultIdentifierValidator(p, 1, DefaultMaxCharacterLength); err != nil {
    //				return sdkerrors.Wrapf(err, "path %s contains an invalid identifier: '%s'", path, p)
    //			}
    //		}
    //
    //		return nil
    //	}
    //}
}
