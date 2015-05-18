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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tcpHandler = TcpHandler(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectToIPAddr(sender: AnyObject) {
        tcpHandler.connectToDevice(ipAddr.text)
    }

    func connected(host: String) {
        println("Connected to host: \(ipAddr.text)")
    }
    
    func disconnected() {
        
    }
    
    func receivedNumbers(number1: Int, number2: Int) {
        goMoku = GoMokuModel(size: number1, winSequence: number2)
        
        performSegueWithIdentifier("gameSceneSegue", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        tcpHandler.delegate = self
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let multiplayerViewController = segue.destinationViewController as! MultiplayerViewController
        multiplayerViewController.tcpHandler = self.tcpHandler
        multiplayerViewController.goMoku = self.goMoku
        
        
    }
    
    @IBAction func joinAGameViewTapped(sender: AnyObject) {
        println("tapped")
        let view = (sender as! UITapGestureRecognizer).view
        for views in view!.subviews {
            views.resignFirstResponder()
        }

    }

}
