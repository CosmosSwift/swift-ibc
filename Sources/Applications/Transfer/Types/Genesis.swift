import Host

extension TransferGenesisState {
//    // NewGenesisState creates a new ibc-transfer GenesisState instance.
//    init(
//        portId: String,
//        denominationTraces: Traces,
//        parameters: Parameters
//    ) {
//        self.portId = portId
//        self.denominationTraces = denominationTraces
//        self.parameters = parameters
//    }

    // DefaultGenesisState returns a GenesisState with "transfer" as the default PortID.
    static let `default` = TransferGenesisState(
        portId: TransferKeys.portId,
		denominationTraces: Traces(),
        parameters: .default
	)
}

// Validate performs basic genesis state validation returning an error upon any
// failure.
extension TransferGenesisState {
    func validate() throws {
        try Host.portIdentifierValidator(id: portId)
        try denominationTraces.validate()
        try parameters.validate()
    }
}
