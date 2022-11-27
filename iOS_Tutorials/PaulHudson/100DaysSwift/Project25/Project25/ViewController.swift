//
//  ViewController.swift
//  Project25
//
//  Created by Michael Brockman on 11/27/22.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController {
  
  //MARK: - Properties
  var images = [UIImage]()
  var peerID = MCPeerID(displayName: UIDevice.current.name)
  var mcSession: MCSession!
  var mcAdvertiserAssistant: MCAdvertiserAssistant!
  var advertiser: MCNearbyServiceAdvertiser!
  
  //MARK: - IBActions
  @IBAction func showConnectedDevicesButtonTapped(_ sender: UIButton) {
    var peers: [MCPeerID] = []
    guard let mcSession else { return }
    for peer in mcSession.connectedPeers {
      peers.append(peer)
    }
    let message = peers.isEmpty ? "No users currently connected" : "\(peers) currently connected"
    let ac = UIAlertController(title: "Connections", message: message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }
    //MARK: - View Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    setupMCSession()
  }

  //MARK: - Configure UI
  func configureUI() {
    title = "Selfie Share"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
  }
  
  //MARK: - MCSession Methods
  func setupMCSession() {
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession?.delegate = self
  }

  //MARK: - @OBJC Import Picture
  @objc func importPicture() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }
  
  @objc func showConnectionPrompt() {
    let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
    ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
    ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(ac, animated: true)
  }
  
  func startHosting(action: UIAlertAction) {
//    mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
//    mcAdvertiserAssistant.start()
    
    advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
    advertiser.delegate = self
    advertiser.startAdvertisingPeer()
  }
  
  func joinSession(action: UIAlertAction) {
    let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
    mcBrowser.delegate = self
    present(mcBrowser, animated: true)
  }

  //MARK: - Collection View Methods
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
    
    if let imageView = cell.viewWithTag(1000) as? UIImageView {
      imageView.image = images[indexPath.item]
    }
    
    return cell
  }
  
}

//MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
  
}

//MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    
    dismiss(animated: true)
    
    images.insert(image, at: 0)
    collectionView.reloadData()
    
    guard let mcSession else { return }
    
    if mcSession.connectedPeers.count > 0 {
      if let imageData = image.pngData() {
        do {
          try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
        } catch {
          let ac = UIAlertController(title: "Send Error", message: error.localizedDescription, preferredStyle: .alert)
          ac.addAction(UIAlertAction(title: "OK", style: .default))
          present(ac, animated: true)
        }
      }
    }
  }
}

//MARK: - MCSessionDelegate
extension ViewController: MCSessionDelegate {
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
    switch state {
    case .notConnected:
      let ac = UIAlertController(title: "User Disconnected", message: "\(peerID.displayName) Disconnected", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default))
      present(ac, animated: true)
      print("Not Connected: \(peerID.displayName)")
    case .connecting:
      print("Connecting: \(peerID.displayName)")
    case .connected:
      print("Connected: \(peerID.displayName)")
    @unknown default:
      print("Unknown state received: \(peerID.displayName)")
    }
  }
  
  func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    DispatchQueue.main.async { [weak self] in
      if let image = UIImage(data: data) {
        self?.images.insert(image, at: 0)
        self?.collectionView.reloadData()
      }
    }
  }
  
  func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { }
  
  func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) { }
}

//MARK: - MCBrowserViewControllerDelegate
extension ViewController: MCBrowserViewControllerDelegate {
  func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
  
  func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
    dismiss(animated: true)
  }
}

extension ViewController: MCNearbyServiceAdvertiserDelegate {
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    let ac = UIAlertController(title: "Project25", message: "'\(peerID.displayName)' wants to connect", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Accept", style: .default, handler: { [weak self] _ in
      invitationHandler(true, self?.mcSession)
    }))
    ac.addAction(UIAlertAction(title: "Decline", style: .cancel, handler: { _ in
      invitationHandler(false, nil)
    }))
    present(ac, animated: true)
  }
}
