//
//  Connection.swift
//  Cribbage
//
//  Created by Ajay Yamamoto on 2026-04-12.
//

import MultipeerConnectivity
import Combine
import SwiftUI

class Connection: NSObject, ObservableObject {
    let ID: MCPeerID
    let session: MCSession
    
    override init() {
        self.ID = MCPeerID(displayName: ProcessInfo.processInfo.hostName)
        self.session = MCSession(peer: self.ID, securityIdentity: nil, encryptionPreference: .required)
        
        super.init()
        // telling "it" that this class does stuff
        self.session.delegate = self
    }
}

extension Connection: MCSessionDelegate {
    // 1 - Indicates that an NSData object has been received from a nearby peer
    func session(
        _ session: MCSession,
        didReceive data: Data,
        fromPeer peerID: MCPeerID
    ) {
        <#code#>
    }
    // 2 - Indicates that the local peer began receiving a resource from a nearby peer.
    func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {
        <#code#>
    }
    // 3 - Indicates that the local peer finished receiving a resource from a nearby peer.
    func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: (any Error)?
    ) {
        <#code#>
    }
    // 4 - Called when a nearby peer opens a byte stream connection to the local peer.
    func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {
        <#code#>
    }
    
    // 5 - Called when the state of a nearby peer changes.
    func session(
        _ session: MCSession,
        peer peerID: MCPeerID,
        didChange state: MCSessionState
    ) {
        <#code#>
    }
}
