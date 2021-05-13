//package exported
//
//import (
//	ics23 "github.com/confio/ics23/go"
//	proto "github.com/gogo/protobuf/proto"
//
//	"github.com/cosmos/cosmos-sdk/codec"
//	sdk "github.com/cosmos/cosmos-sdk/types"
//)
import Cosmos
import SwiftProtobuf

public enum ExportedClientKeys {
	// TypeClientMisbehaviour is the shared evidence misbehaviour type
    public static let typeClientMisbehaviour = "client_misbehaviour"

	// Solomachine is used to indicate that the light client is a solo machine.
	public static let solomachine = "06-solomachine"

	// Tendermint is used to indicate that the client uses the Tendermint Consensus Algorithm.
	public static let tendermint = "07-tendermint"

	// Localhost is the client type for a localhost client. It is also used as the clientID
	// for the localhost client.
	public static let localhost = "09-localhost"
}

// ClientState defines the required common functions for light clients.
public class ClientState: SwiftProtobuf.Message {
    public static var protoMessageName: String = ""
    public var unknownFields: UnknownStorage = .init()
    
    public func decodeMessage<D>(decoder: inout D) throws where D : Decoder {
        
    }
    
    public func traverse<V>(visitor: inout V) throws where V : Visitor {
        
    }
    
    public func isEqualTo(message: SwiftProtobuf.Message) -> Bool {
        false
    }
    
    public required init() {}
    public var clientType: String = ""
//    var latestHeight: Height { get }
//    var isFrozen: Bool { get }
//    var frozenHeight: Height { get }
    public func validate() throws {}
//    #warning("TODO: Implement")
//    var proofSpecs: [ICS23ProofSpec]

//	// Initialization function
//	// Clients must validate the initial consensus state, and may store any client-specific metadata
//	// necessary for correct light client operation
//	func initialize(
//        request: Request,
//        codec: Codec, // TODO: Use codec.BinaryMarshaler?
//        store: KeyValueStore,
//        consensusState: ConsensusState
//    ) throws
//
//	// Genesis function
//    func exportMetadata(store: KeyValueStore) -> [GenesisMetadata]

//	// Update and Misbehaviour functions
//	func checkHeaderAndUpdateState(sdk.Context, codec.BinaryMarshaler, sdk.KVStore, Header) (ClientState, ConsensusState, error)
//	func checkMisbehaviourAndUpdateState(sdk.Context, codec.BinaryMarshaler, sdk.KVStore, Misbehaviour) (ClientState, error)
//	func checkSubstituteAndUpdateState(ctx sdk.Context, cdc codec.BinaryMarshaler, subjectClientStore, substituteClientStore sdk.KVStore, substituteClient ClientState, height Height) (ClientState, error)
//
//	// Upgrade functions
//	// NOTE: proof heights are not included as upgrade to a new revision is expected to pass only on the last
//	// height committed by the current revision. Clients are responsible for ensuring that the planned last
//	// height of the current revision is somehow encoded in the proof verification process.
//	// This is to ensure that no premature upgrades occur, since upgrade plans committed to by the counterparty
//	// may be cancelled or modified before the last planned height.
//	VerifyUpgradeAndUpdateState(
//		ctx sdk.Context,
//		cdc codec.BinaryMarshaler,
//		store sdk.KVStore,
//		newClient ClientState,
//		newConsState ConsensusState,
//		proofUpgradeClient,
//		proofUpgradeConsState []byte,
//	) (ClientState, ConsensusState, error)
//	// Utility function that zeroes out any client customizable fields in client state
//	// Ledger enforced fields are maintained while all custom fields are zero values
//	// Used to verify upgrades
//	ZeroCustomFields() ClientState
//
//	// State verification functions
//
//	VerifyClientState(
//		store sdk.KVStore,
//		cdc codec.BinaryMarshaler,
//		height Height,
//		prefix Prefix,
//		counterpartyClientIdentifier string,
//		proof []byte,
//		clientState ClientState,
//	) error
//	VerifyClientConsensusState(
//		store sdk.KVStore,
//		cdc codec.BinaryMarshaler,
//		height Height,
//		counterpartyClientIdentifier string,
//		consensusHeight Height,
//		prefix Prefix,
//		proof []byte,
//		consensusState ConsensusState,
//	) error
//	VerifyConnectionState(
//		store sdk.KVStore,
//		cdc codec.BinaryMarshaler,
//		height Height,
//		prefix Prefix,
//		proof []byte,
//		connectionID string,
//		connectionEnd ConnectionI,
//	) error
//	VerifyChannelState(
//		store sdk.KVStore,
//		cdc codec.BinaryMarshaler,
//		height Height,
//		prefix Prefix,
//		proof []byte,
//		portID,
//		channelID string,
//		channel ChannelI,
//	) error
//	VerifyPacketCommitment(
//		store sdk.KVStore,
//		cdc codec.BinaryMarshaler,
//		height Height,
//		currentTimestamp uint64,
//		delayPeriod uint64,
//		prefix Prefix,
//		proof []byte,
//		portID,
//		channelID string,
//		sequence uint64,
//		commitmentBytes []byte,
//	) error
//	VerifyPacketAcknowledgement(
//		store sdk.KVStore,
//		cdc codec.BinaryMarshaler,
//		height Height,
//		currentTimestamp uint64,
//		delayPeriod uint64,
//		prefix Prefix,
//		proof []byte,
//		portID,
//		channelID string,
//		sequence uint64,
//		acknowledgement []byte,
//	) error
//	VerifyPacketReceiptAbsence(
//		store sdk.KVStore,
//		cdc codec.BinaryMarshaler,
//		height Height,
//		currentTimestamp uint64,
//		delayPeriod uint64,
//		prefix Prefix,
//		proof []byte,
//		portID,
//		channelID string,
//		sequence uint64,
//	) error
//	VerifyNextSequenceRecv(
//		store sdk.KVStore,
//		cdc codec.BinaryMarshaler,
//		height Height,
//		currentTimestamp uint64,
//		delayPeriod uint64,
//		prefix Prefix,
//		proof []byte,
//		portID,
//		channelID string,
//		nextSequenceRecv uint64,
//	) error
}

// ConsensusState is the state of the consensus process
public class ConsensusState: SwiftProtobuf.Message {
    public static var protoMessageName: String = ""
    public var unknownFields: UnknownStorage = .init()
    
    public func decodeMessage<D>(decoder: inout D) throws where D : Decoder {
    
    }
    
    public func traverse<V>(visitor: inout V) throws where V : Visitor {
        
    }
    
    public func isEqualTo(message: SwiftProtobuf.Message) -> Bool {
        false
    }
    
    public required init() {}
    // Consensus kind
    public let clientType: String = ""

//	// GetRoot returns the commitment root of the consensus state,
//	// which is used for key-value pair verification.
//	GetRoot() Root
//
//	// GetTimestamp returns the timestamp (in nanoseconds) of the consensus state
//	GetTimestamp() uint64
//
    public func validateBasic() throws {}
}

//// Misbehaviour defines counterparty misbehaviour for a specific consensus type
//type Misbehaviour interface {
//	proto.Message
//
//	ClientType() string
//	GetClientID() string
//	ValidateBasic() error
//
//	// Height at which the infraction occurred
//	GetHeight() Height
//}
//
//// Header is the consensus state update information
//type Header interface {
//	proto.Message
//
//	ClientType() string
//	GetHeight() Height
//	ValidateBasic() error
//}

// Height is a wrapper interface over clienttypes.Height
// all clients must use the concrete implementation in types
public protocol Height {
//	IsZero() bool
//	LT(Height) bool
//	LTE(Height) bool
//	EQ(Height) bool
//	GT(Height) bool
//	GTE(Height) bool
//	GetRevisionNumber() uint64
//	GetRevisionHeight() uint64
//	Increment() Height
//	Decrement() (Height, bool)
//	String() string
}

//// GenesisMetadata is a wrapper interface over clienttypes.GenesisMetadata
//// all clients must use the concrete implementation in types
//type GenesisMetadata interface {
//	// return store key that contains metadata without clientID-prefix
//	GetKey() []byte
//	// returns metadata value
//	GetValue() []byte
//}
//
