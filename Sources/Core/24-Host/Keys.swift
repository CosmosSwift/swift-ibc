import Foundation

func key(from path: String) -> Data {
    Data(Array(path.utf8))
}

public enum PortKeys {
    // ModuleName defines the IBC port name
    public static let moduleName = "ibc"

    // StoreKey is the store key string for IBC ports
    public static let storeKey = moduleName

    // RouterKey is the message route for IBC ports
    public static let routerKey = moduleName

    // QuerierRoute is the querier route for IBC ports
    public static let querierRoute = moduleName

    // KVStore key prefixes for IBC
    public static let keyClientStorePrefix       = Data(Array("clients".utf8))
    
    // KVStore path prefixes for IBC
    static let keyClientState             = "clientState"
    static let keyConsensusStatePrefix    = "consensusStates"
    static let keyConnectionPrefix        = "connections"
    static let keyChannelEndPrefix        = "channelEnds"
    static let keyChannelPrefix           = "channels"
    static let keyPortPrefix              = "ports"
    static let keySequencePrefix          = "sequences"
    static let keyChannelCapabilityPrefix = "capabilities"
    static let keyNextSeqSendPrefix       = "nextSequenceSend"
    static let keyNextSeqRecvPrefix       = "nextSequenceRecv"
    static let keyNextSeqAckPrefix        = "nextSequenceAck"
    static let keyPacketCommitmentPrefix  = "commitments"
    static let keyPacketAckPrefix         = "acks"
    static let keyPacketReceiptPrefix     = "receipts"
}


// FullClientPath returns the full path of a specific client path in the format:
// "clients/{clientID}/{path}" as a string.
func fullClientPath(_ clientID: String, _ path: String) -> String {
    "\(PortKeys.keyClientStorePrefix)/\(clientID)/\(path)"
}

// FullClientKey returns the full path of specific client path in the format:
// "clients/{clientID}/{path}" as a byte array.
func fullClientKey(_ clientID: String, _ path: String) -> Data {
    key(from: fullClientPath(clientID, path))
}

// ICS02
// The following paths are the keys to the store as defined in https://github.com/cosmos/ics/tree/master/spec/ics-002-client-semantics#path-space

// FullClientStatePath takes a client identifier and returns a Path under which to store a
// particular client state
func fullClientStatePath(_ clientID: String) -> String {
    fullClientPath(clientID, PortKeys.keyClientState)
}

// FullClientStateKey takes a client identifier and returns a Key under which to store a
// particular client state.
func fullClientStateKey(_ clientID: String) -> Data {
    key(from: fullClientStatePath(clientID))
}

// ClientStateKey returns a store key under which a particular client state is stored
// in a client prefixed store
func clientStateKey() -> Data {
    key(from: PortKeys.keyClientState)
}

// FullConsensusStatePath takes a client identifier and returns a Path under which to
// store the consensus state of a client.
func fullConsensusStatePath(_ clientID: String, _ height: UInt64) -> String {
    return fullClientPath(clientID, consensusStatePath(height))
}

// FullConsensusStateKey returns the store key for the consensus state of a particular
// client.
func fullConsensusStateKey(_ clientID: String, _ height: UInt64) -> Data {
    key(from: fullConsensusStatePath(clientID, height))
}

// ConsensusStatePath returns the suffix store key for the consensus state at a
// particular height stored in a client prefixed store.
func consensusStatePath(_ height: UInt64) -> String {
    "\(PortKeys.keyConsensusStatePrefix)/\(height)"
}

// ConsensusStateKey returns the store key for a the consensus state of a particular
// client stored in a client prefixed store.
func consensusStateKey(_ height: UInt64) -> Data {
    key(from: consensusStatePath(height))
}

// ICS03
// The following paths are the keys to the store as defined in https://github.com/cosmos/ics/tree/master/spec/ics-003-connection-semantics#store-paths

// ClientConnectionsPath defines a reverse mapping from clients to a set of connections
func clientConnectionsPath(_ clientID: String) -> String {
    return fullClientPath(clientID, PortKeys.keyConnectionPrefix)
}

// ClientConnectionsKey returns the store key for the connections of a given client
func clientConnectionsKey(_ clientID: String) -> Data {
    key(from: clientConnectionsPath(clientID))
}

// ConnectionPath defines the path under which connection paths are stored
func connectionPath(_ connectionID: String) -> String {
    "\(PortKeys.keyConnectionPrefix)/\(connectionID)"
}

// ConnectionKey returns the store key for a particular connection
func connectionKey(_ connectionID: String) -> Data {
    key(from: connectionPath(connectionID))
}

// ICS04
// The following paths are the keys to the store as defined in https://github.com/cosmos/ics/tree/master/spec/ics-004-channel-and-packet-semantics#store-paths

// ChannelPath defines the path under which channels are stored
func channelPath(_ portID: String, channelID: String) -> String {
    "\(PortKeys.keyChannelEndPrefix)/\(channelPath(portID, channelID))"
}

// ChannelKey returns the store key for a particular channel
func channelKey(_ portID: String, _ channelID: String) -> Data {
    key(from: channelPath(portID, channelID))
}

// ChannelCapabilityPath defines the path under which capability keys associated
// with a channel are stored
func channelCapabilityPath(_ portID: String, _ channelID: String) -> String {
    "\(PortKeys.keyChannelCapabilityPrefix)/\(channelPath(portID, channelID))"
}

// NextSequenceSendPath defines the next send sequence counter store path
func nextSequenceSendPath(_ portID: String, _ channelID: String) -> String {
    "\(PortKeys.keyNextSeqSendPrefix)/\(channelPath(portID, channelID))"
}

// NextSequenceSendKey returns the store key for the send sequence of a particular
// channel binded to a specific port.
func nextSequenceSendKey(_ portID: String, _ channelID: String) -> Data {
    key(from: nextSequenceSendPath(portID, channelID))
}

// NextSequenceRecvPath defines the next receive sequence counter store path.
func nextSequenceRecvPath(_ portID: String, _ channelID: String) -> String {
    "\(PortKeys.keyNextSeqRecvPrefix)/\(channelPath(portID, channelID))"
}

// NextSequenceRecvKey returns the store key for the receive sequence of a particular
// channel binded to a specific port
func nextSequenceRecvKey(_ portID: String, _ channelID: String) -> Data {
    key(from: nextSequenceRecvPath(portID, channelID))
}

// NextSequenceAckPath defines the next acknowledgement sequence counter store path
func nextSequenceAckPath(_ portID: String, _ channelID: String) -> String {
    "\(PortKeys.keyNextSeqAckPrefix)/\(channelPath(portID, channelID))"
}

// NextSequenceAckKey returns the store key for the acknowledgement sequence of
// a particular channel binded to a specific port.
func nextSequenceAckKey(_ portID: String, _ channelID: String) -> Data {
    key(from: nextSequenceAckPath(portID, channelID))
}

// PacketCommitmentPath defines the commitments to packet data fields store path
func packetCommitmentPath(_ portID: String, _ channelID: String, _ sequence: UInt64) -> String {
    "\(packetCommitmentPrefixPath(portID, channelID))/\(sequence)"
}

// PacketCommitmentKey returns the store key of under which a packet commitment
// is stored
func packetCommitmentKey(_ portID: String, _ channelID: String, _ sequence: UInt64) -> Data {
    key(from: packetCommitmentPath(portID, channelID, sequence))
}

// PacketCommitmentPrefixPath defines the prefix for commitments to packet data fields store path.
func packetCommitmentPrefixPath(_ portID: String, _ channelID: String) -> String {
    "\(PortKeys.keyPacketCommitmentPrefix)/\(channelPath(portID, channelID))/\(PortKeys.keySequencePrefix)"
}

// PacketAcknowledgementPath defines the packet acknowledgement store path
func packetAcknowledgementPath(_ portID: String, _ channelID: String, _ sequence: UInt64) -> String {
    "\(packetAcknowledgementPrefixPath(portID, channelID))/\(sequence)"
}

// PacketAcknowledgementKey returns the store key of under which a packet
// acknowledgement is stored
func packetAcknowledgementKey(_ portID: String, _ channelID: String, _ sequence: UInt64) -> Data {
    key(from: packetAcknowledgementPath(portID, channelID, sequence))
}

// PacketAcknowledgementPrefixPath defines the prefix for commitments to packet data fields store path.
func packetAcknowledgementPrefixPath(_ portID: String, _ channelID: String) -> String {
    "\(PortKeys.keyPacketAckPrefix)/\(channelPath(portID, channelID))/\(PortKeys.keySequencePrefix)"
}

// PacketReceiptPath defines the packet receipt store path
func packetReceiptPath(_ portID: String, _ channelID: String, _ sequence: UInt64) -> String {
    "\(PortKeys.keyPacketReceiptPrefix)/\(channelPath(portID, channelID))/\(sequencePath(sequence))"
}

// PacketReceiptKey returns the store key of under which a packet
// receipt is stored
func packetReceiptKey(_ portID: String, _ channelID: String, _ sequence: UInt64) -> Data {
    key(from: packetReceiptPath(portID, channelID, sequence))
}

func channelPath(_ portID: String, _ channelID: String) -> String {
    "\(PortKeys.keyPortPrefix)/\(portID)/\(PortKeys.keyChannelPrefix)/\(channelID)"
}

func sequencePath(_ sequence: UInt64) -> String {
    "\(PortKeys.keySequencePrefix)/\(sequence)"
}

// ICS05
// The following paths are the keys to the store as defined in https://github.com/cosmos/ics/tree/master/spec/ics-005-port-allocation#store-paths

// PortPath defines the path under which ports paths are stored on the capability module
func portPath(_ portID: String) -> String {
    "\(PortKeys.keyPortPrefix)/\(portID)"
}

/*
package host

import (
	"fmt"

	"github.com/cosmos/ibc-go/modules/core/exported"
)

const (
	// ModuleName is the name of the IBC module
	ModuleName = "ibc"

	// StoreKey is the string store representation
	StoreKey string = ModuleName

	// QuerierRoute is the querier route for the IBC module
	QuerierRoute string = ModuleName

	// RouterKey is the msg router key for the IBC module
	RouterKey string = ModuleName
)

// KVStore key prefixes for IBC
var (
	KeyClientStorePrefix = Data("clients")
)

// KVStore key prefixes for IBC
const (
	KeyClientState             = "clientState"
	KeyConsensusStatePrefix    = "consensusStates"
	KeyConnectionPrefix        = "connections"
	KeyChannelEndPrefix        = "channelEnds"
	KeyChannelPrefix           = "channels"
	KeyPortPrefix              = "ports"
	KeySequencePrefix          = "sequences"
	KeyChannelCapabilityPrefix = "capabilities"
	KeyNextSeqSendPrefix       = "nextSequenceSend"
	KeyNextSeqRecvPrefix       = "nextSequenceRecv"
	KeyNextSeqAckPrefix        = "nextSequenceAck"
	KeyPacketCommitmentPrefix  = "commitments"
	KeyPacketAckPrefix         = "acks"
	KeyPacketReceiptPrefix     = "receipts"
)

// FullClientPath returns the full path of a specific client path in the format:
// "clients/{clientID}/{path}" as a string.
func FullClientPath(clientID string, path string) string {
	return fmt.Sprintf("%s/%s/%s", KeyClientStorePrefix, clientID, path)
}

// FullClientKey returns the full path of specific client path in the format:
// "clients/{clientID}/{path}" as a byte array.
func FullClientKey(clientID string, path Data) Data {
	return Data(FullClientPath(clientID, string(path)))
}

// ICS02
// The following paths are the keys to the store as defined in https://github.com/cosmos/ics/tree/master/spec/ics-002-client-semantics#path-space

// FullClientStatePath takes a client identifier and returns a Path under which to store a
// particular client state
func FullClientStatePath(clientID string) string {
	return FullClientPath(clientID, KeyClientState)
}

// FullClientStateKey takes a client identifier and returns a Key under which to store a
// particular client state.
func FullClientStateKey(clientID string) Data {
	return FullClientKey(clientID, Data(KeyClientState))
}

// ClientStateKey returns a store key under which a particular client state is stored
// in a client prefixed store
func ClientStateKey() Data {
	return Data(KeyClientState)
}

// FullConsensusStatePath takes a client identifier and returns a Path under which to
// store the consensus state of a client.
func FullConsensusStatePath(clientID string, height exported.Height) string {
	return FullClientPath(clientID, ConsensusStatePath(height))
}

// FullConsensusStateKey returns the store key for the consensus state of a particular
// client.
func FullConsensusStateKey(clientID string, height exported.Height) Data {
	return Data(FullConsensusStatePath(clientID, height))
}

// ConsensusStatePath returns the suffix store key for the consensus state at a
// particular height stored in a client prefixed store.
func ConsensusStatePath(height exported.Height) string {
	return fmt.Sprintf("%s/%s", KeyConsensusStatePrefix, height)
}

// ConsensusStateKey returns the store key for a the consensus state of a particular
// client stored in a client prefixed store.
func ConsensusStateKey(height exported.Height) Data {
	return Data(ConsensusStatePath(height))
}

// ICS03
// The following paths are the keys to the store as defined in https://github.com/cosmos/ics/tree/master/spec/ics-003-connection-semantics#store-paths

// ClientConnectionsPath defines a reverse mapping from clients to a set of connections
func ClientConnectionsPath(clientID string) string {
	return FullClientPath(clientID, KeyConnectionPrefix)
}

// ClientConnectionsKey returns the store key for the connections of a given client
func ClientConnectionsKey(clientID string) Data {
	return Data(ClientConnectionsPath(clientID))
}

// ConnectionPath defines the path under which connection paths are stored
func ConnectionPath(connectionID string) string {
	return fmt.Sprintf("%s/%s", KeyConnectionPrefix, connectionID)
}

// ConnectionKey returns the store key for a particular connection
func ConnectionKey(connectionID string) Data {
	return Data(ConnectionPath(connectionID))
}

// ICS04
// The following paths are the keys to the store as defined in https://github.com/cosmos/ics/tree/master/spec/ics-004-channel-and-packet-semantics#store-paths

// ChannelPath defines the path under which channels are stored
func ChannelPath(portID, channelID string) string {
	return fmt.Sprintf("%s/%s", KeyChannelEndPrefix, channelPath(portID, channelID))
}

// ChannelKey returns the store key for a particular channel
func ChannelKey(portID, channelID string) Data {
	return Data(ChannelPath(portID, channelID))
}

// ChannelCapabilityPath defines the path under which capability keys associated
// with a channel are stored
func ChannelCapabilityPath(portID, channelID string) string {
	return fmt.Sprintf("%s/%s", KeyChannelCapabilityPrefix, channelPath(portID, channelID))
}

// NextSequenceSendPath defines the next send sequence counter store path
func NextSequenceSendPath(portID, channelID string) string {
	return fmt.Sprintf("%s/%s", KeyNextSeqSendPrefix, channelPath(portID, channelID))
}

// NextSequenceSendKey returns the store key for the send sequence of a particular
// channel binded to a specific port.
func NextSequenceSendKey(portID, channelID string) Data {
	return Data(NextSequenceSendPath(portID, channelID))
}

// NextSequenceRecvPath defines the next receive sequence counter store path.
func NextSequenceRecvPath(portID, channelID string) string {
	return fmt.Sprintf("%s/%s", KeyNextSeqRecvPrefix, channelPath(portID, channelID))
}

// NextSequenceRecvKey returns the store key for the receive sequence of a particular
// channel binded to a specific port
func NextSequenceRecvKey(portID, channelID string) Data {
	return Data(NextSequenceRecvPath(portID, channelID))
}

// NextSequenceAckPath defines the next acknowledgement sequence counter store path
func NextSequenceAckPath(portID, channelID string) string {
	return fmt.Sprintf("%s/%s", KeyNextSeqAckPrefix, channelPath(portID, channelID))
}

// NextSequenceAckKey returns the store key for the acknowledgement sequence of
// a particular channel binded to a specific port.
func NextSequenceAckKey(portID, channelID string) Data {
	return Data(NextSequenceAckPath(portID, channelID))
}

// PacketCommitmentPath defines the commitments to packet data fields store path
func PacketCommitmentPath(portID, channelID string, _ sequence: UInt64) string {
	return fmt.Sprintf("%s/%d", PacketCommitmentPrefixPath(portID, channelID), sequence)
}

// PacketCommitmentKey returns the store key of under which a packet commitment
// is stored
func PacketCommitmentKey(portID, channelID string, _ sequence: UInt64) Data {
	return Data(PacketCommitmentPath(portID, channelID, sequence))
}

// PacketCommitmentPrefixPath defines the prefix for commitments to packet data fields store path.
func PacketCommitmentPrefixPath(portID, channelID string) string {
	return fmt.Sprintf("%s/%s/%s", KeyPacketCommitmentPrefix, channelPath(portID, channelID), KeySequencePrefix)
}

// PacketAcknowledgementPath defines the packet acknowledgement store path
func PacketAcknowledgementPath(portID, channelID string, _ sequence: UInt64) string {
	return fmt.Sprintf("%s/%d", PacketAcknowledgementPrefixPath(portID, channelID), sequence)
}

// PacketAcknowledgementKey returns the store key of under which a packet
// acknowledgement is stored
func PacketAcknowledgementKey(portID, channelID string, _ sequence: UInt64) Data {
	return Data(PacketAcknowledgementPath(portID, channelID, sequence))
}

// PacketAcknowledgementPrefixPath defines the prefix for commitments to packet data fields store path.
func PacketAcknowledgementPrefixPath(portID, channelID string) string {
	return fmt.Sprintf("%s/%s/%s", KeyPacketAckPrefix, channelPath(portID, channelID), KeySequencePrefix)
}

// PacketReceiptPath defines the packet receipt store path
func PacketReceiptPath(portID, channelID string, _ sequence: UInt64) string {
	return fmt.Sprintf("%s/%s/%s", KeyPacketReceiptPrefix, channelPath(portID, channelID), sequencePath(sequence))
}

// PacketReceiptKey returns the store key of under which a packet
// receipt is stored
func PacketReceiptKey(portID, channelID string, _ sequence: UInt64) Data {
	return Data(PacketReceiptPath(portID, channelID, sequence))
}

func channelPath(portID, channelID string) string {
	return fmt.Sprintf("%s/%s/%s/%s", KeyPortPrefix, portID, KeyChannelPrefix, channelID)
}

func sequencePath(_ sequence: UInt64) string {
	return fmt.Sprintf("%s/%d", KeySequencePrefix, sequence)
}

// ICS05
// The following paths are the keys to the store as defined in https://github.com/cosmos/ics/tree/master/spec/ics-005-port-allocation#store-paths

// PortPath defines the path under which ports paths are stored on the capability module
func PortPath(portID string) string {
	return fmt.Sprintf("%s/%s", KeyPortPrefix, portID)
}

*/
