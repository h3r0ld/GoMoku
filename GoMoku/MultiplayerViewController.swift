//
//  MultiplayerViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 04/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit
import GameKit

class MultiplayerViewController: UIViewController, GKTurnBasedMatchmakerViewControllerDelegate {
    
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFailWithError error: NSError!) {
        
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFindMatch match: GKTurnBasedMatch!) {
        
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, playerQuitForMatch match: GKTurnBasedMatch!) {
        
    }
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController!) {
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func joinGameAction(sender: AnyObject) {
        var request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
        vc.turnBasedMatchmakerDelegate = self
        
        presentViewController(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
