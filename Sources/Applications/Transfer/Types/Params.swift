import Cosmos
import Params

extension TransferParameters {
	// DefaultSendEnabled enabled
    static let defaultIsSendEnabled = true
	// DefaultReceiveEnabled enabled
	static let defaultIsReceiveEnabled = true
}

extension TransferKeys {
	// KeySendEnabled is store's key for SendEnabled Params
    static let isSendEnabledKey = "SendEnabled".data
	// KeyReceiveEnabled is store's key for ReceiveEnabled Params
    static let isReceiveEnabledKey = "ReceiveEnabled".data
}

extension TransferParameters: ParameterSet {
    // ParamKeyTable type declaration for parameters
    var parameterKeyTable: KeyTable {
        KeyTable(parameterSet: TransferParameters.default)
    }
}

extension TransferParameters {
//    // NewParams creates a new parameter configuration for the ibc transfer module
//    init(sendEnabled: Bool, receiveEnabled: Bool) {
//        self.sendEnabled = sendEnabled
//        self.receiveEnabled = receiveEnabled
//    }

    // DefaultParams is the default parameter configuration for the ibc-transfer module
    static let `default` = TransferParameters(
        isSendEnabled: defaultIsSendEnabled,
        isReceiveEnabled: defaultIsReceiveEnabled
    )

    // Validate all ibc-transfer module parameters
    func validate() throws {
        try Self.validateEnabled(value: isSendEnabled)
        try Self.validateEnabled(value: isReceiveEnabled)
    }

    // ParamSetPairs implements params.ParamSet
    var parameterSetPairs: ParameterSetPairs {
        [
            ParameterSetPair(
                key: TransferKeys.isSendEnabledKey,
                value: isSendEnabled,
                validatorFunction: Self.validateEnabled
            ),
            ParameterSetPair(
                key: TransferKeys.isReceiveEnabledKey,
                value: isReceiveEnabled,
                validatorFunction: Self.validateEnabled
            )
        ]
    }
    
    private static func validateEnabled(value: Any) throws {
        guard value is Bool else {
            throw GenericError(description: "invalid parameter type: \(type(of: value))")
        }
    }
}
