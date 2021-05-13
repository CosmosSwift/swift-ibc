/*

TODO: substitute with the relevant proto generated file

*/

import Foundation
import CosmosProto

// MerklePrefix is merkle path prefixed to the key.
// The constructed key from the Path and the key will be append(Path.KeyPath,
// append(Path.KeyPrefix, key...))
public struct MerklePrefix: Codable {
    let keyPrefix: Data
    
    private enum CodingKeys: String, CodingKey {
        case keyPrefix = "key_prefix"
    }
}

extension MerklePrefix {
    public init(_ prefix: Ibc_Core_Commitment_V1_MerklePrefix) {
        self.keyPrefix = prefix.keyPrefix
    }
}
