import Cosmos

extension TransferKeeper {
    // InitGenesis initializes the ibc-transfer state and binds to PortID.
    func initGenesis(request: Request, genesisState state: TransferGenesisState) {
        setPort(withId: state.portId, request: request)

        for trace in state.denominationTraces {
            set(denominationTrace: trace, request: request)
        }

        // Only try to bind to port if it is not already bound, since we may already own
        // port capability from capability InitGenesis
        if !isPortWithIdBound(id: state.portId, request: request) {
            // transfer module binds to the transfer port on InitChain
            // and claims the returned capability
            do {
                try bindPort(withId: state.portId, request: request)
            } catch {
                fatalError("could not claim port capability: \(error)")
            }
        }

        set(parameters: state.parameters, request: request)

        // check if the module account exists
        guard transferAccount(request: request) != nil else {
            fatalError("\(TransferKeys.moduleName) module account has not been set")
        }
    }

    // ExportGenesis exports ibc-transfer module's portID and denom trace info into its genesis state.
    func exportGenesis(request: Request) -> TransferGenesisState {
        TransferGenesisState(
            portId: port(request: request),
            denominationTraces: allDenominationTraces(request: request),
            parameters: parameters(request: request)
        )
    }
}
