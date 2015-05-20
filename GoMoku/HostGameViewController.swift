//
//  HostGameViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 18/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//


import UIKit
// View controller for hosting..
class HostGameViewController: UIViewController, NetworkDelegate {

    @IBOutlet weak var myIPaddr: UILabel!
    var tcpHandler: TcpHandler!

    // Set the delegate
    // Present our IP address
    override func viewDidLoad() {
        super.viewDidLoad()
        tcpHandler = TcpHandler(delegate: self)
        myIPaddr.text = "Your IP address: " + "\n" + "\(getIFAddress())"
        println(myIPaddr.text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // Delegate method, called when the other player connected to the host
    func connected(host: String) {
        
        let goMoku = AppDelegate.sharedAppDelegate().myGoMoKuModel
        println("Peer connected: \(host)")
        // Send the model attributes to the peer
        tcpHandler.sendNumbers(goMoku!.Size, number2: goMoku!.getWinSequenceNeeded())
        performSegueWithIdentifier("gameSceneSegue", sender: self)
        tcpHandler.stopListening()
    }
    
    func disconnected() {
        // We not yet connected, so we dont need to disconnect
    }
    
    func receivedNumbers(number1: Int, number2: Int) {
        // We dont receive numbers from the other player, if we host
    }
    
    // Ref: http://stackoverflow.com/questions/25626117/how-to-get-ip-address-in-swift
    // Gets the host's ip address
    func getIFAddress() -> String {
        var address = String()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4 interface. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let IFaddress = String.fromCString(hostname) {
                                    address = IFaddress
                                }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address
    }
    
    // If the view appears, start listening for incoming connections
    override func viewWillAppear(animated: Bool) {
        tcpHandler.startListening()
        tcpHandler.delegate = self
    }
    
    // If the view disappears, stop listening for incoming connections
    override func viewWillDisappear(animated: Bool) {
        tcpHandler.stopListening()
    }

    // We need to pass the undermentioned attributes:
    // - tcpHandler
    // - model
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let multiplayerViewController = segue.destinationViewController as! MultiplayerViewController
        
        multiplayerViewController.tcpHandler = self.tcpHandler
        multiplayerViewController.goMoku = AppDelegate.sharedAppDelegate().myGoMoKuModel
        multiplayerViewController.myTurn = true
    }

}
