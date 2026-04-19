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
    
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    
    override init() {
        print("init started")
        self.ID = MCPeerID(displayName: ProcessInfo.processInfo.hostName)
        self.session = MCSession(peer: self.ID, securityIdentity: nil, encryptionPreference: .required)
        let serviceName = "crib-game"
        
        super.init()
        // telling "it" that this class does stuff
        self.session.delegate = self
        
#if os(macOS)
        // Create the Advertiser for Mac
        self.advertiser = MCNearbyServiceAdvertiser(peer: self.ID, discoveryInfo: nil, serviceType: serviceName)
        self.advertiser?.delegate = self // Tell it to talk to this class
        self.advertiser?.startAdvertisingPeer()
    #else
        // Create the Browser for iPhone
        self.browser = MCNearbyServiceBrowser(peer: self.ID, serviceType: serviceName)
        self.browser?.delegate = self // Tell it to talk to this class
        self.browser?.startBrowsingForPeers()
    #endif
    }
    
    func sendTestMessage() {
        let message = "Ping!"
        if let data = message.data(using: .utf8) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Send failed: \(error)")
            }
        }
    }
}

extension Connection: MCSessionDelegate {
    // 1 - Indicates that an NSData object has been received from a nearby peer
    func session(
        _ session: MCSession,
        didReceive data: Data,
        fromPeer peerID: MCPeerID
    ) {
        if let decodedCard = try? JSONDecoder().decode(Card.self, from: data) {
            DispatchQueue.main.async {
                print("\(decodedCard.suit)")
            }
        }
        //
        if let message = String(data: data, encoding: .utf8) {
                // This is where the magic happens!
                print("MAC RECEIVED: \(message) from \(peerID.displayName)")
            }
    }
    // 2 - Indicates that the local peer began receiving a resource from a nearby peer.
    func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {
        //
    }
    // 3 - Indicates that the local peer finished receiving a resource from a nearby peer.
    func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: (any Error)?
    ) {
        //
    }
    // 4 - Called when a nearby peer opens a byte stream connection to the local peer.
    func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {
        //
    }
    
    // 5 - Called when the state of a nearby peer changes.
    func session(
        _ session: MCSession,
        peer peerID: MCPeerID,
        didChange state: MCSessionState
    ) {
        if state == .connected {
            print("yay, \(ID.displayName)")
        } else if state == .connecting {
            print("attempting to connect")
        }
    }
}

//For mac
extension Connection: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, self.session)
    }
}

//For remote
extension Connection: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        //
    }
}
