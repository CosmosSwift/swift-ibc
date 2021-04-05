import Foundation
import Cosmos
import Host

public enum ChannelKeys {
	// SubModuleName defines the IBC channels name
    static let subModuleName = "channel"

	// StoreKey is the store key string for IBC channels
	static let storeKey = subModuleName

	// RouterKey is the message route for IBC channels
	static let routerKey = subModuleName

	// QuerierRoute is the querier route for IBC channels
	static let querierRoute = subModuleName

	// KeyNextChannelSequence is the key used to store the next channel sequence in
	// the keeper.
	static let keyNextChannelSequence = "nextChannelSequence"

	// ChannelPrefix is the prefix used when creating a channel identifier
	static let channelPrefix = "channel-"
}

extension ChannelKeys {
    // FormatChannelIdentifier returns the channel identifier with the sequence appended.
    // This is a SDK specific format not enforced by IBC protocol.
    static func formatChannelIdentifier(sequence: UInt64) -> String {
        "\(channelPrefix)\(sequence)"
    }

    // IsChannelIDFormat checks if a channelID is in the format required on the SDK for
    // parsing channel identifiers. The channel identifier must be in the form: `channel-{N}
    static func isFormatted(channelId: String) -> Bool {
        channelId.range(of: #"^channel-[0-9]{1,20}$"#, options: .regularExpression) != nil
    }

    // IsValidChannelID checks if a channelID is valid and can be parsed to the channel
    // identifier format.
    static func isValidChannelId(channelId: String) -> Bool {
        (try? parseChannelSequence(channelId: channelId)) == nil
    }

    // ParseChannelSequence parses the channel sequence from the channel identifier.
    public static func parseChannelSequence(channelId: String) throws -> UInt64 {
        guard isFormatted(channelId: channelId) else {
            throw CosmosError.wrap(
                error: HostError.invalidId,
                description: "channel identifier is not in the format: `channel-{N}`"
            )
        }

        do {
            return try HostKeys.parse(identifier: channelId, prefix: channelPrefix)
        } catch {
            throw CosmosError.wrap(
                error: error,
                description: "invalid channel identifier"
            )
        }
    }
}
