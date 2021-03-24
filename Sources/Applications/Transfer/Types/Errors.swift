import Cosmos

struct GenericError: Swift.Error, CustomStringConvertible {
    var description: String
}

// IBC channel sentinel errors
extension CosmosError {
    static let invalidPacketTimeout    = CosmosError.register(codespace: TransferKeys.moduleName, code: 2, description: "invalid packet timeout")
    static let invalidDenominationForTransfer = CosmosError.register(codespace: TransferKeys.moduleName, code: 3, description: "invalid denomination for cross-chain transfer")
    static let invalidVersion          = CosmosError.register(codespace: TransferKeys.moduleName, code: 4, description: "invalid ICS20 version")
    static let invalidAmount           = CosmosError.register(codespace: TransferKeys.moduleName, code: 5, description: "invalid token amount")
    static let traceNotFound           = CosmosError.register(codespace: TransferKeys.moduleName, code: 6, description: "denomination trace not found")
    static let sendDisabled            = CosmosError.register(codespace: TransferKeys.moduleName, code: 7, description: "fungible token transfers from this chain are disabled")
    static let receiveDisabled         = CosmosError.register(codespace: TransferKeys.moduleName, code: 8, description: "fungible token transfers to this chain are disabled")
    static let maxTransferChannels     = CosmosError.register(codespace: TransferKeys.moduleName, code: 9, description: "max transfer channels")
}
