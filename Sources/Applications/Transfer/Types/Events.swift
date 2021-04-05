// IBC transfer events
enum TransferEventType {
    static let timeout      = "timeout"
	static let packet       = "fungible_token_packet"
	static let transfer     = "ibc_transfer"
	static let channelClose = "channel_closed"
	static let denominationTrace   = "denomination_trace"
}

enum TransferAttributeKey {
	static let receiver           = "receiver"
	static let denomination       = "denom"
	static let amount             = "amount"
	static let refundReceiver     = "refund_receiver"
	static let refundDenomination = "refund_denom"
	static let refundAmount       = "refund_amount"
    static let acknowledgementSuccess = "success"
	static let acknowledgement    = "acknowledgement"
	static let acknowledgementError   = "error"
	static let traceHash          = "trace_hash"
}
