//
//  JoinGameViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 18/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit

class JoinGameViewController: UIViewController, NetworkDelegate {
    
    @IBOutlet weak var ipAddr: UITextField!
    var tcpHandler: TcpHandler!
    var goMoku: GoMokuModel!
    
    // Create the tcpHandler
    override func viewDidLoad() {
        super.viewDidLoad()
        tcpHandler = TcpHandler(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("Memory warning.")
    }
    
    // Action button, connect to the entered IP address
    @IBAction func connectToIPAddr(sender: AnyObject) {
        tcpHandler.connectToDevice(ipAddr.text)
    }

    // If we connected to the host... log it
    func connected(host: String) {
        println("Connected to host: \(ipAddr.text)")
    }
    
    func disconnected() {
        // We're waiting to connect, so we do nothing at disconnect
    }
    
    // If we received the model's attributes, we can go to the game scene
    func receivedNumbers(number1: Int, number2: Int) {
        goMoku = GoMokuModel(size: number1, winSequence: number2)
        performSegueWithIdentifier("gameSceneSegue", sender: self)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        tcpHandler.delegate = self
    }
    
    // preparing to go to the game scene
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let multiplayerViewController = segue.destinationViewController as! MultiplayerViewController
        multiplayerViewController.tcpHandler = self.tcpHandler
        multiplayerViewController.goMoku = self.goMoku
    }
    
    // Remove keyboard
    @IBAction func joinAGameViewTapped(sender: AnyObject) {
        println("tapped")
        let view = (sender as! UITapGestureRecognizer).view
        for views in view!.subviews {
            views.resignFirstResponder()
        }

    }

}
