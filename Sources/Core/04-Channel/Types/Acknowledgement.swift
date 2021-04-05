import Foundation
import Cosmos

public extension Acknowledgement {
    // NewResultAcknowledgement returns a new instance of Acknowledgement using an Acknowledgement_Result
    // type in the Response field.
    init(result data: Data) {
        self.init(response: .result(data))
    }

    // NewErrorAcknowledgement returns a new instance of Acknowledgement using an Acknowledgement_Error
    // type in the Response field.
    init(error: String) {
        self.init(response: .error(error))
    }

    // GetBytes is a helper for serialising acknowledgements
    public var data: Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return try! encoder.encode(self)
        // TODO: Check if using codec is required
//        sdk.MustSortJSON(SubModuleCdc.MustMarshalJSON(&ack))
    }

    // ValidateBasic performs a basic validation of the acknowledgement
    func validateBasic() throws {
        switch self.response {
        case .result(let data):
            guard !data.isEmpty else {
                throw CosmosError.wrap(
                    error: ChannelError.invalidAcknowledgement,
                    description: "acknowledgement result cannot be empty"
                )
            }
        case .error(let error):
            guard !error.trimmingCharacters(in: .whitespaces).isEmpty else {
                throw CosmosError.wrap(
                    error: ChannelError.invalidAcknowledgement,
                    description: "acknowledgement error cannot be empty"
                )
            }
        }
    }
}
