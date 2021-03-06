//package keeper
//
//import (
//	"fmt"
//	"strings"
//
//	"github.com/armon/go-metrics"
//
//	"github.com/cosmos/cosmos-sdk/telemetry"
//	sdk "github.com/cosmos/cosmos-sdk/types"
//	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
//	"github.com/cosmos/ibc-go/modules/apps/transfer/types"
//	clienttypes "github.com/cosmos/ibc-go/modules/core/02-client/types"
//	channeltypes "github.com/cosmos/ibc-go/modules/core/04-channel/types"
//	host "github.com/cosmos/ibc-go/modules/core/24-host"
//)
import Cosmos
import Channel

extension TransferKeeper {
// SendTransfer handles transfer sending logic. There are 2 possible cases:
//
// 1. Sender chain is acting as the source zone. The coins are transferred
// to an escrow address (i.e locked) on the sender chain and then transferred
// to the receiving chain through IBC TAO logic. It is expected that the
// receiving chain will mint vouchers to the receiving address.
//
// 2. Sender chain is acting as the sink zone. The coins (vouchers) are burned
// on the sender chain and then transferred to the receiving chain though IBC
// TAO logic. It is expected that the receiving chain, which had previously
// sent the original denomination, will unescrow the fungible token and send
// it to the receiving address.
//
// Another way of thinking of source and sink zones is through the token's
// timeline. Each send to any chain other than the one it was previously
// received from is a movement forwards in the token's timeline. This causes
// trace to be added to the token's history and the destination port and
// destination channel to be prefixed to the denomination. In these instances
// the sender chain is acting as the source zone. When the token is sent back
// to the chain it previously received from, the prefix is removed. This is
// a backwards movement in the token's timeline and the sender chain
// is acting as the sink zone.
//
// Example:
// These steps of transfer occur: A -> B -> C -> A -> C -> B -> A
//
// 1. A -> B : sender chain is source zone. Denom upon receiving: 'B/denom'
// 2. B -> C : sender chain is source zone. Denom upon receiving: 'C/B/denom'
// 3. C -> A : sender chain is source zone. Denom upon receiving: 'A/C/B/denom'
// 4. A -> C : sender chain is sink zone. Denom upon receiving: 'C/B/denom'
// 5. C -> B : sender chain is sink zone. Denom upon receiving: 'B/denom'
// 6. B -> A : sender chain is sink zone. Denom upon receiving: 'denom'
//func (k Keeper) SendTransfer(
//	ctx sdk.Context,
//	sourcePort,
//	sourceChannel string,
//	token sdk.Coin,
//	sender sdk.AccAddress,
//	receiver string,
//	timeoutHeight clienttypes.Height,
//	timeoutTimestamp uint64,
//) error {
//
//	if !k.GetSendEnabled(ctx) {
//		return types.ErrSendDisabled
//	}
//
//	sourceChannelEnd, found := k.channelKeeper.GetChannel(ctx, sourcePort, sourceChannel)
//	if !found {
//		return sdkerrors.Wrapf(channeltypes.ErrChannelNotFound, "port ID (%s) channel ID (%s)", sourcePort, sourceChannel)
//	}
//
//	destinationPort := sourceChannelEnd.GetCounterparty().GetPortID()
//	destinationChannel := sourceChannelEnd.GetCounterparty().GetChannelID()
//
//	// get the next sequence
//	sequence, found := k.channelKeeper.GetNextSequenceSend(ctx, sourcePort, sourceChannel)
//	if !found {
//		return sdkerrors.Wrapf(
//			channeltypes.ErrSequenceSendNotFound,
//			"source port: %s, source channel: %s", sourcePort, sourceChannel,
//		)
//	}
//
//	// begin createOutgoingPacket logic
//	// See spec for this logic: https://github.com/cosmos/ics/tree/master/spec/ics-020-fungible-token-transfer#packet-relay
//	channelCap, ok := k.scopedKeeper.GetCapability(ctx, host.ChannelCapabilityPath(sourcePort, sourceChannel))
//	if !ok {
//		return sdkerrors.Wrap(channeltypes.ErrChannelCapabilityNotFound, "module does not own channel capability")
//	}
//
//	// NOTE: denomination and hex hash correctness checked during msg.ValidateBasic
//	fullDenomPath := token.Denom
//
//	var err error
//
//	// deconstruct the token denomination into the denomination trace info
//	// to determine if the sender is the source chain
//	if strings.HasPrefix(token.Denom, "ibc/") {
//		fullDenomPath, err = k.DenomPathFromHash(ctx, token.Denom)
//		if err != nil {
//			return err
//		}
//	}
//
//	labels := []metrics.Label{
//		telemetry.NewLabel("destination-port", destinationPort),
//		telemetry.NewLabel("destination-channel", destinationChannel),
//	}
//
//	// NOTE: SendTransfer simply sends the denomination as it exists on its own
//	// chain inside the packet data. The receiving chain will perform denom
//	// prefixing as necessary.
//
//	if types.SenderChainIsSource(sourcePort, sourceChannel, fullDenomPath) {
//		labels = append(labels, telemetry.NewLabel("source", "true"))
//
//		// create the escrow address for the tokens
//		escrowAddress := types.GetEscrowAddress(sourcePort, sourceChannel)
//
//		// escrow source tokens. It fails if balance insufficient.
//		if err := k.bankKeeper.SendCoins(
//			ctx, sender, escrowAddress, sdk.NewCoins(token),
//		); err != nil {
//			return err
//		}
//
//	} else {
//		labels = append(labels, telemetry.NewLabel("source", "false"))
//
//		// transfer the coins to the module account and burn them
//		if err := k.bankKeeper.SendCoinsFromAccountToModule(
//			ctx, sender, types.ModuleName, sdk.NewCoins(token),
//		); err != nil {
//			return err
//		}
//
//		if err := k.bankKeeper.BurnCoins(
//			ctx, types.ModuleName, sdk.NewCoins(token),
//		); err != nil {
//			// NOTE: should not happen as the module account was
//			// retrieved on the step above and it has enough balace
//			// to burn.
//			panic(fmt.Sprintf("cannot burn coins after a successful send to a module account: %v", err))
//		}
//	}
//
//	packetData := types.NewFungibleTokenPacketData(
//		fullDenomPath, token.Amount.Uint64(), sender.String(), receiver,
//	)
//
//	packet := channeltypes.NewPacket(
//		packetData.GetBytes(),
//		sequence,
//		sourcePort,
//		sourceChannel,
//		destinationPort,
//		destinationChannel,
//		timeoutHeight,
//		timeoutTimestamp,
//	)
//
//	if err := k.channelKeeper.SendPacket(ctx, channelCap, packet); err != nil {
//		return err
//	}
//
//	defer func() {
//		telemetry.SetGaugeWithLabels(
//			[]string{"tx", "msg", "ibc", "transfer"},
//			float32(token.Amount.Int64()),
//			[]metrics.Label{telemetry.NewLabel("denom", fullDenomPath)},
//		)
//
//		telemetry.IncrCounterWithLabels(
//			[]string{"ibc", types.ModuleName, "send"},
//			1,
//			labels,
//		)
//	}()
//
//	return nil
//}

    // OnRecvPacket processes a cross chain fungible token transfer. If the
    // sender chain is the source of minted tokens then vouchers will be minted
    // and sent to the receiving address. Otherwise if the sender chain is sending
    // back tokens this chain originally transferred to it, the tokens are
    // unescrowed and sent to the receiving address.
    func onReceive(packet: Packet, data: FungibleTokenPacketData, request: Request) throws {
        // validate packet data upon receiving
        try data.validateBasic()

        guard isReceiveEnabled(request: request) else {
            throw TransferError.receiveDisabled
        }

        // decode the receiver address
        let receiver = try AccountAddress(bech32Encoded: data.receiver)

        // TODO: Implement metrics
//        let labels: [Metrics.Label] = [
//            Telemetry.Label("source-port", packet.sourcePort),
//            Telemetry.Label("source-channel", packet.sourceChannel),
//        ]

        // This is the prefix that would have been prefixed to the denomination
        // on sender chain IF and only if the token originally came from the
        // receiving chain.
        //
        // NOTE: We use SourcePort and SourceChannel here, because the counterparty
        // chain would have prefixed with DestPort and DestChannel when originally
        // receiving this coin as seen in the "sender chain is the source" condition.

        if isReceiverChainSource(sourcePort: packet.sourcePort, sourceChannel: packet.sourceChannel, denomination: data.denomination) {
            // sender chain is not the source, unescrow tokens

            // remove prefix added by sender chain
            let voucherPrefix = denominationPrefix(portId: packet.sourcePort, channelId: packet.sourceChannel)
            let unprefixedDenomination = String(data.denomination.dropFirst(voucherPrefix.count))

            // coin denomination used in sending from the escrow address
            var denomination = unprefixedDenomination

            // The denomination used to send the coins is either the native denom or the hash of the path
            // if the denomination is not native.
            let denominationTrace = DenominationTrace(rawDenomination: unprefixedDenomination)
            
            if denominationTrace.path != "" {
                denomination = denominationTrace.ibcDenomination
            }
            
            let token = Coin(denomination: denomination, amount: UInt(data.amount))

            // unescrow tokens
            let escrowAddress = TransferKeys.escrowAddress(portId: packet.destinationPort, channelId: packet.destinationChannel)
            
            do {
                try bankKeeper.sendCoins(
                    request: request,
                    from: escrowAddress,
                    to: receiver,
                    amount: Coins(token)
                )
            } catch {
                // NOTE: this error is only expected to occur given an unexpected bug or a malicious
                // counterparty module. The bug may occur in bank or any part of the code that allows
                // the escrow address to be drained. A malicious counterparty module could drain the
                // escrow address by allowing more tokens to be sent back then were escrowed.
                throw CosmosError.wrap(
                    error: error,
                    description: "unable to unescrow tokens, this may be caused by a malicious counterparty module or a bug: please open an issue on counterparty module"
                )
            }

            // TODO: Implement metrics
//            defer {
//                telemetry.SetGaugeWithLabels(
//                    []string{"ibc", types.ModuleName, "packet", "receive"},
//                    float32(data.Amount),
//                    []metrics.Label{telemetry.NewLabel("denom", unprefixedDenom)},
//                )
//
//                telemetry.IncrCounterWithLabels(
//                    []string{"ibc", types.ModuleName, "receive"},
//                    1,
//                    append(
//                        labels, telemetry.NewLabel("source", "true"),
//                    ),
//                )
//            }
        }

        // sender chain is the source, mint vouchers

        // since SendPacket did not prefix the denomination, we must prefix denomination here
        let sourcePrefix = denominationPrefix(portId: packet.destinationPort, channelId: packet.destinationChannel)
        // NOTE: sourcePrefix contains the trailing "/"
        let prefixedDenomination = sourcePrefix + data.denomination

        // construct the denomination trace from the full raw denomination
        let denominationTrace = DenominationTrace(rawDenomination: prefixedDenomination)

        let traceHash = denominationTrace.hash
        
        if !has(denominationTrace: traceHash, request: request) {
            set(denominationTrace: denominationTrace, request: request)
        }

        let voucherDenomination = denominationTrace.ibcDenomination
        
        let event = Event(
            type: TransferEventType.denominationTrace,
            attributes: [
                Attribute(key: TransferAttributeKey.traceHash, value: traceHash.description),
                Attribute(key: TransferAttributeKey.denomination, value: voucherDenomination),
            ]
        )
        
        request.eventManager.emit(event: event)

        let voucher = Coin(denomination: voucherDenomination, amount: UInt(data.amount))

        // mint new tokens if the source of the transfer is the same chain
        try bankKeeper.mintCoins(
            request: request,
            moduleName: TransferKeys.moduleName,
            amount: Coins(voucher)
        )

        // send to receiver
        do {
            try bankKeeper.sendCoinsFromModuleToAccount(
                request: request,
                senderModule: TransferKeys.moduleName,
                recipientAddress: receiver,
                amount: Coins(voucher)
            )
        } catch {
            fatalError("unable to send coins from module to account despite previously minting coins to module account: \(error)")
        }

        // TODO: Implement metrics
//        defer {
//            telemetry.SetGaugeWithLabels(
//                []string{"ibc", types.ModuleName, "packet", "receive"},
//                float32(data.Amount),
//                []metrics.Label{telemetry.NewLabel("denom", data.Denom)},
//            )
//
//            telemetry.IncrCounterWithLabels(
//                []string{"ibc", types.ModuleName, "receive"},
//                1,
//                append(
//                    labels, telemetry.NewLabel("source", "false"),
//                ),
//            )
//        }
    }

    // OnAcknowledgementPacket responds to the the success or failure of a packet
    // acknowledgement written on the receiving chain. If the acknowledgement
    // was a success then nothing occurs. If the acknowledgement failed, then
    // the sender is refunded their tokens using the refundPacketToken function.
    func onAcknowledgementPacket(
        request: Request,
        packet: Packet,
        data: FungibleTokenPacketData,
        acknowledgement: Acknowledgement
    ) throws {
        switch acknowledgement.response {
        case .error(let error):
            try refundPacketToken(request: request, packet: packet, data: data)
        default:
            // the acknowledgement succeeded on the receiving chain so nothing
            // needs to be executed and no error needs to be returned
            return
        }
    }

    // OnTimeoutPacket refunds the sender since the original packet sent was
    // never received and has been timed out.
    func onTimeoutPacket(
        request: Request,
        packet: Packet,
        data: FungibleTokenPacketData
    ) throws {
        try refundPacketToken(
            request: request,
            packet: packet,
            data: data
        )
    }

    // refundPacketToken will unescrow and send back the tokens back to sender
    // if the sending chain was the source chain. Otherwise, the sent tokens
    // were burnt in the original send so new tokens are minted and sent to
    // the sending address.
    private func refundPacketToken(
        request: Request,
        packet: Packet,
        data: FungibleTokenPacketData
    ) throws {
        // NOTE: packet data type already checked in handler.go

        // parse the denomination from the full denom path
        let trace = DenominationTrace(rawDenomination: data.denomination)
        let token = Coin(denomination: trace.ibcDenomination, amount: UInt(data.amount))

        // decode the sender address
        let sender = try AccountAddress(bech32Encoded: data.sender)

        if isSenderChainSource(
            sourcePort: packet.sourcePort,
            sourceChannel: packet.sourceChannel,
            denomination: data.denomination
        ) {
            // unescrow tokens back to sender
            let escrowAddress = TransferKeys.escrowAddress(
                portId: packet.sourcePort,
                channelId: packet.sourceChannel
            )
            
            do {
                try bankKeeper.sendCoins(
                    request: request,
                    from: escrowAddress,
                    to: sender,
                    amount: Coins(token)
                )
            } catch {
                // NOTE: this error is only expected to occur given an unexpected bug or a malicious
                // counterparty module. The bug may occur in bank or any part of the code that allows
                // the escrow address to be drained. A malicious counterparty module could drain the
                // escrow address by allowing more tokens to be sent back then were escrowed.
                throw CosmosError.wrap(
                    error: error,
                    description: "unable to unescrow tokens, this may be caused by a malicious counterparty module or a bug: please open an issue on counterparty module"
                )
            }
        }

        // mint vouchers back to sender
        try bankKeeper.mintCoins(
            request: request,
            moduleName: TransferKeys.moduleName,
            amount: Coins(token)
        )

        do {
            try bankKeeper.sendCoinsFromModuleToAccount(
                request: request,
                senderModule: TransferKeys.moduleName,
                recipientAddress: sender,
                amount: Coins(token)
            )
        } catch {
            fatalError("unable to send coins from module to account despite previously minting coins to module account: \(error)")
        }
    }

//// DenomPathFromHash returns the full denomination path prefix from an ibc denom with a hash
//// component.
//func (k Keeper) DenomPathFromHash(ctx sdk.Context, denom string) (string, error) {
//	// trim the denomination prefix, by default "ibc/"
//	hexHash := denom[len(types.DenomPrefix+"/"):]
//
//	hash, err := types.ParseHexHash(hexHash)
//	if err != nil {
//		return "", sdkerrors.Wrap(types.ErrInvalidDenomForTransfer, err.Error())
//	}
//
//	denomTrace, found := k.GetDenomTrace(ctx, hash)
//	if !found {
//		return "", sdkerrors.Wrap(types.ErrTraceNotFound, hexHash)
//	}
//
//	fullDenomPath := denomTrace.GetFullDenomPath()
//	return fullDenomPath, nil
//}
}
