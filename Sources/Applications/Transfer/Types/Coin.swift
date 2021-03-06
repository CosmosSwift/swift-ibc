import Cosmos

extension TransferKeeper {
    // SenderChainIsSource returns false if the denomination originally came
    // from the receiving chain and true otherwise.
    func isSenderChainSource(
        sourcePort: String,
        sourceChannel: String,
        denomination: String
    ) -> Bool {
        // This is the prefix that would have been prefixed to the denomination
        // on sender chain IF and only if the token originally came from the
        // receiving chain.
        return !isReceiverChainSource(
            sourcePort: sourcePort,
            sourceChannel: sourceChannel,
            denomination: denomination
        )
    }

    // ReceiverChainIsSource returns true if the denomination originally came
    // from the receiving chain and false otherwise.
    func isReceiverChainSource(
        sourcePort: String,
        sourceChannel: String,
        denomination: String
    ) -> Bool {
        // The prefix passed in should contain the SourcePort and SourceChannel.
        // If  the receiver chain originally sent the token to the sender chain
        // the denom will have the sender's SourcePort and SourceChannel as the
        // prefix.
        let voucherPrefix = denominationPrefix(portId: sourcePort, channelId: sourceChannel)
        return denomination.hasPrefix(voucherPrefix)
    }

    // GetDenomPrefix returns the receiving denomination prefix
    func denominationPrefix(portId: String, channelId: String) -> String {
        "\(portId)/\(channelId)/"
    }

//// GetPrefixedDenom returns the denomination with the portID and channelID prefixed
//func GetPrefixedDenom(portID, channelID, baseDenom string) string {
//	return fmt.Sprintf("%s/%s/%s", portID, channelID, baseDenom)
//}
//
//// GetTransferCoin creates a transfer coin with the port ID and channel ID
//// prefixed to the base denom.
//func GetTransferCoin(portID, channelID, baseDenom string, amount int64) sdk.Coin {
//	denomTrace := ParseDenomTrace(GetPrefixedDenom(portID, channelID, baseDenom))
//	return sdk.NewInt64Coin(denomTrace.IBCDenom(), amount)
//}
}
