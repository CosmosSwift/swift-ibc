import Foundation

extension TransferKeeper {
//    // UnmarshalDenomTrace attempts to decode and return an DenomTrace object from
//    // raw encoded bytes.
//    func unmarshalDenomTrace(bz []byte) (types.DenomTrace, error) {
//        var denomTrace types.DenomTrace
//        if err := k.cdc.UnmarshalBinaryBare(bz, &denomTrace); err != nil {
//            return types.DenomTrace{}, err
//        }
//        return denomTrace, nil
//    }

    // MustUnmarshalDenomTrace attempts to decode and return an DenomTrace object from
    // raw encoded bytes. It panics on error.
    func mustUnmarshalDenominationTrace(data: Data) -> DenominationTrace {
        codec.mustUnmarshalBinaryBare(data: data)
    }

//    // MarshalDenomTrace attempts to encode an DenomTrace object and returns the
//    // raw encoded bytes.
//    func marshalDenomTrace(denomTrace types.DenomTrace) ([]byte, error) {
//        return k.cdc.MarshalBinaryBare(&denomTrace)
//    }

    // MustMarshalDenomTrace attempts to encode an DenomTrace object and returns the
    // raw encoded bytes. It panics on error.
    func mustMarshal(denominationTrace: DenominationTrace) -> Data {
        codec.mustMarshalBinaryBare(value: denominationTrace)
    }
}
