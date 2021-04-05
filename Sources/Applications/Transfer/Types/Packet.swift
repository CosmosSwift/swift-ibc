import Cosmos

//var (
//	// DefaultRelativePacketTimeoutHeight is the default packet timeout height (in blocks) relative
//	// to the current block height of the counterparty chain provided by the client state. The
//	// timeout is disabled when set to 0.
//	DefaultRelativePacketTimeoutHeight = "0-1000"
//
//	// DefaultRelativePacketTimeoutTimestamp is the default packet timeout timestamp (in nanoseconds)
//	// relative to the current block timestamp of the counterparty chain provided by the client
//	// state. The timeout is disabled when set to 0. The default is currently set to a 10 minute
//	// timeout.
//	DefaultRelativePacketTimeoutTimestamp = uint64((time.Duration(10) * time.Minute).Nanoseconds())
//)

extension FungibleTokenPacketData {
//    // NewFungibleTokenPacketData contructs a new FungibleTokenPacketData instance
//    func NewFungibleTokenPacketData(
//        denom string, amount uint64,
//        sender, receiver string,
//    ) FungibleTokenPacketData {
//        return FungibleTokenPacketData{
//            Denom:    denom,
//            Amount:   amount,
//            Sender:   sender,
//            Receiver: receiver,
//        }
//    }

    // ValidateBasic is used for validating the token transfer.
    // NOTE: The addresses formats are not validated as the sender and recipient can have different
    // formats defined by their corresponding chains that are not known to IBC.
    func validateBasic() throws {
        guard amount > 0 else {
            throw CosmosError.wrap(
                error: TransferError.invalidAmount,
                description: "amount cannot be 0"
            )
        }
        
        guard !sender.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw CosmosError.wrap(
                error: CosmosError.invalidAddress,
                description: "sender address cannot be blank"
            )
        }
        
        guard !receiver.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw CosmosError.wrap(
                error: CosmosError.invalidAddress,
                description: "receiver address cannot be blank"
            )
        }
        
        return try DenominationTrace.validate(prefixedDenomination: denomination)
    }

//    // GetBytes is a helper for serialising
//    func (ftpd FungibleTokenPacketData) GetBytes() []byte {
//        return sdk.MustSortJSON(ModuleCdc.MustMarshalJSON(&ftpd))
//    }
}
