import Foundation
import Tendermint
import Cosmos
import CosmosProto
import Client
import Host

// msg types
extension TransferMessage {
	static let messageType = "transfer"
}

struct TransferMessage: Message {
    public static let metaType: MetaType = Self.metaType(
        key: "cosmos-sdk/MsgTransfer"
    )

    let sourcePort: String
    let sourceChannel: String
    let token: Coin
    let sender: AccountAddress
    let receiver: String
    let timeoutHeight: Height
    let timeoutTimestamp: UInt64
    
    // NewMsgTransfer creates a new MsgTransfer instance
    init(
        sourcePort: String,
        sourceChannel: String,
        token: Coin,
        sender: AccountAddress,
        receiver: String,
        timeoutHeight: Height,
        timeoutTimestamp: UInt64
    ) {
        self.sourcePort = sourcePort
        self.sourceChannel = sourceChannel
        self.token = token
        self.sender = sender
        self.receiver = receiver
        self.timeoutHeight = timeoutHeight
        self.timeoutTimestamp = timeoutTimestamp
    }
}

extension TransferMessage {
    init(_ transferMessage: Ibc_Applications_Transfer_V1_MsgTransfer) throws {
        self.sourcePort = transferMessage.sourcePort
        self.sourceChannel = transferMessage.sourceChannel
        self.token = Coin(transferMessage.token)
        self.sender = try AccountAddress(bech32Encoded: transferMessage.sender)
        self.receiver = transferMessage.receiver
        self.timeoutHeight = Height(transferMessage.timeoutHeight)
        self.timeoutTimestamp = transferMessage.timeoutTimestamp
    }
}

extension Ibc_Applications_Transfer_V1_MsgTransfer {
    init(_ transferMessage: TransferMessage) {
		self.init()
        self.sourcePort = transferMessage.sourcePort
        self.sourceChannel = transferMessage.sourceChannel
        self.token = Cosmos_Base_V1beta1_Coin(transferMessage.token)
        // TODO: Check if this is the right conversion
        self.sender = transferMessage.sender.description
        self.receiver = transferMessage.receiver
        self.timeoutHeight = Ibc_Core_Client_V1_Height(transferMessage.timeoutHeight)
        self.timeoutTimestamp = transferMessage.timeoutTimestamp
	}
}

extension TransferMessage {
	// Route implements sdk.Msg
	public var route: String {
		TransferKeys.routerKey
	}

	// Type implements sdk.Msg
	public var type: String {
        Self.messageType
	}

	// ValidateBasic performs a basic check of the MsgTransfer fields.
	// NOTE: timeout height or timestamp values can be 0 to disable the timeout.
	// NOTE: The recipient addresses format is not validated as the format defined by
	// the chain is not known to IBC.
	public func validateBasic() throws {
        do {
            try Host.portIdentifierValidator(id: sourcePort)
        } catch {
            throw CosmosError.wrap(
                error: error,
                description: "invalid source port ID"
            )
		}
        
        do {
            try Host.channelIdentifierValidator(id: sourceChannel)
        } catch {
			throw CosmosError.wrap(
                error: error,
                description: "invalid source channel ID"
            )
		}
        
		guard token.isValid else {
			throw CosmosError.wrap(
                error: CosmosError.invalidCoins,
                description: token.description
            )
		}
        
//      Token is always positive since we're using UInt
//		guard token.isPositive else {
//			throw CosmosError.wrap(
//                error: CosmosError.insufficientFunds,
//                description: token.description
//            )
//		}

        guard !receiver.trimmingCharacters(in: .whitespaces).isEmpty else {
			throw CosmosError.wrap(
                error: CosmosError.invalidAddress,
                description: "missing recipient address"
            )
		}
        
        return try DenominationTrace.validate(ibcDenomination: token.denomination)
	}

	// GetSignBytes implements sdk.Msg.
	public var toSign: Data {
        try! JSONEncoder().encode(self)
	}

	// GetSigners implements sdk.Msg
	public var signers: [AccountAddress] {
		return [sender]
	}
}
