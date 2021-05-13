//package types
//
//import (
//	"fmt"
//	"math/big"
//	"regexp"
//	"strconv"
//	"strings"
//
//	sdk "github.com/cosmos/cosmos-sdk/types"
//	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
//	"github.com/cosmos/ibc-go/modules/core/exported"
//)
//
//var _ exported.Height = (*Height)(nil)
extension Height {
//// IsRevisionFormat checks if a chainID is in the format required for parsing revisions
//// The chainID must be in the form: `{chainID}-{revision}
//// 24-host may enforce stricter checks on chainID
//var IsRevisionFormat = regexp.MustCompile(`^.*[^-]-{1}[1-9][0-9]*$`).MatchString
//
//// ZeroHeight is a helper function which returns an uninitialized height.
//func ZeroHeight() Height {
//	return Height{}
//}
//
//// NewHeight is a constructor for the IBC height type
//func NewHeight(revisionNumber, revisionHeight uint64) Height {
//	return Height{
//		RevisionNumber: revisionNumber,
//		RevisionHeight: revisionHeight,
//	}
//}
//
//// GetRevisionNumber returns the revision-number of the height
//func (h Height) GetRevisionNumber() uint64 {
//	return h.RevisionNumber
//}
//
//// GetRevisionHeight returns the revision-height of the height
//func (h Height) GetRevisionHeight() uint64 {
//	return h.RevisionHeight
//}
//
//// Compare implements a method to compare two heights. When comparing two heights a, b
//// we can call a.Compare(b) which will return
//// -1 if a < b
//// 0  if a = b
//// 1  if a > b
////
//// It first compares based on revision numbers, whichever has the higher revision number is the higher height
//// If revision number is the same, then the revision height is compared
//func (h Height) Compare(other exported.Height) int64 {
//	height, ok := other.(Height)
//	if !ok {
//		panic(fmt.Sprintf("cannot compare against invalid height type: %T. expected height type: %T", other, h))
//	}
//	var a, b big.Int
//	if h.RevisionNumber != height.RevisionNumber {
//		a.SetUint64(h.RevisionNumber)
//		b.SetUint64(height.RevisionNumber)
//	} else {
//		a.SetUint64(h.RevisionHeight)
//		b.SetUint64(height.RevisionHeight)
//	}
//	return int64(a.Cmp(&b))
//}
//
//// LT Helper comparison function returns true if h < other
//func (h Height) LT(other exported.Height) bool {
//	return h.Compare(other) == -1
//}
//
//// LTE Helper comparison function returns true if h <= other
//func (h Height) LTE(other exported.Height) bool {
//	cmp := h.Compare(other)
//	return cmp <= 0
//}
//
//// GT Helper comparison function returns true if h > other
//func (h Height) GT(other exported.Height) bool {
//	return h.Compare(other) == 1
//}
//
//// GTE Helper comparison function returns true if h >= other
//func (h Height) GTE(other exported.Height) bool {
//	cmp := h.Compare(other)
//	return cmp >= 0
//}
//
//// EQ Helper comparison function returns true if h == other
//func (h Height) EQ(other exported.Height) bool {
//	return h.Compare(other) == 0
//}
//
//// String returns a string representation of Height
//func (h Height) String() string {
//	return fmt.Sprintf("%d-%d", h.RevisionNumber, h.RevisionHeight)
//}
//
//// Decrement will return a new height with the RevisionHeight decremented
//// If the RevisionHeight is already at lowest value (1), then false success flag is returend
//func (h Height) Decrement() (decremented exported.Height, success bool) {
//	if h.RevisionHeight == 0 {
//		return Height{}, false
//	}
//	return NewHeight(h.RevisionNumber, h.RevisionHeight-1), true
//}
//
//// Increment will return a height with the same revision number but an
//// incremented revision height
//func (h Height) Increment() exported.Height {
//	return NewHeight(h.RevisionNumber, h.RevisionHeight+1)
//}

    // iszero returns true if height revision and revision-height are both 0
    public var isZero: Bool {
        revisionNumber == 0 && revisionHeight == 0
    }
}
//// mustparseheight will attempt to parse a string representation of a height and panic if
//// parsing fails.
//func mustparseheight(heightstr string) height {
//    height, err := parseheight(heightstr)
//    if err != nil {
//        panic(err)
//    }
//
//    return height
//}
//
//// parseheight is a utility function that takes a string representation of the height
//// and returns a height struct
//func parseheight(heightstr string) (height, error) {
//    splitstr := strings.split(heightstr, "-")
//    if len(splitstr) != 2 {
//        return height{}, sdkerrors.wrapf(sdkerrors.errinvalidheight, "expected height string format: {revision}-{height}. got: %s", heightstr)
//    }
//    revisionnumber, err := strconv.parseuint(splitstr[0], 10, 64)
//    if err != nil {
//        return height{}, sdkerrors.wrapf(sdkerrors.errinvalidheight, "invalid revision number. parse err: %s", err)
//    }
//    revisionheight, err := strconv.parseuint(splitstr[1], 10, 64)
//    if err != nil {
//        return height{}, sdkerrors.wrapf(sdkerrors.errinvalidheight, "invalid revision height. parse err: %s", err)
//    }
//    return newheight(revisionnumber, revisionheight), nil
//}
//
//// setrevisionnumber takes a chainid in valid revision format and swaps the revision number
//// in the chainid with the given revision number.
//func setrevisionnumber(chainid string, revision uint64) (string, error) {
//    if !isrevisionformat(chainid) {
//        return "", sdkerrors.wrapf(
//            sdkerrors.errinvalidchainid, "chainid is not in revision format: %s", chainid,
//        )
//    }
//
//    splitstr := strings.split(chainid, "-")
//    // swap out revision number with given revision
//    splitstr[len(splitstr)-1] = strconv.itoa(int(revision))
//    return strings.join(splitstr, "-"), nil
//}
//
//// parsechainid is a utility function that returns an revision number from the given chainid.
//// parsechainid attempts to parse a chain id in the format: `{chainid}-{revision}`
//// and return the revisionnumber as a uint64.
//// if the chainid is not in the expected format, a default revision value of 0 is returned.
//func parsechainid(chainid string) uint64 {
//    if !isrevisionformat(chainid) {
//        // chainid is not in revision format, return 0 as default
//        return 0
//    }
//    splitstr := strings.split(chainid, "-")
//    revision, err := strconv.parseuint(splitstr[len(splitstr)-1], 10, 64)
//    // sanity check: error should always be nil since regex only allows numbers in last element
//    if err != nil {
//        panic(fmt.sprintf("regex allowed non-number value as last split element for chainid: %s", chainid))
//    }
//    return revision
//}
//
//// getselfheight is a utility function that returns self height given context
//// revision number is retrieved from ctx.chainid()
//func getselfheight(ctx sdk.context) height {
//    revision := parsechainid(ctx.chainid())
//    return newheight(revision, uint64(ctx.blockheight()))
//}
