/*

TODO: substitute with the relevant proto generated file

*/

import CosmosProto

// Height is a monotonically increasing data type
// that can be compared against another Height for the purposes of updating and
// freezing clients
//
// Normally the RevisionHeight is incremented at each height while keeping
// RevisionNumber the same. However some consensus algorithms may choose to
// reset the height in certain conditions e.g. hard forks, state-machine
// breaking changes In these cases, the RevisionNumber is incremented so that
// height continues to be monitonically increasing even as the RevisionHeight
// gets reset
public struct Height: Codable {
    // the revision that the client is currently on
    let revisionNumber: UInt64
    // the height within the given revision
    let revisionHeight: UInt64
}

public extension Height {
    init(_ height: Ibc_Core_Client_V1_Height) {
        self.revisionNumber = height.revisionNumber
        self.revisionHeight = height.revisionHeight
    }
}

public extension Ibc_Core_Client_V1_Height {
    init(_ height: Height) {
        self.init()
        self.revisionNumber = height.revisionNumber
        self.revisionHeight = height.revisionHeight
    }
}
