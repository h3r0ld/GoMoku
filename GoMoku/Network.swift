//
//  Network.swift
//  GoMoku
//
//  Created by Herold Kristóf on 04/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import Foundation
import GameKit

class GKNetworking: GKTurnBasedMatch, GKTurnBasedMatchmakerViewControllerDelegate {
    
    
    func joinMatch(sender: AnyObject) {
        var request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        
        let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
        vc.turnBasedMatchmakerDelegate = self
        
        vc.presentViewController(vc, animated: true, completion: nil)
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFailWithError error: NSError!) {
        
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, didFindMatch match: GKTurnBasedMatch!) {
        
    }
    
    func turnBasedMatchmakerViewController(viewController: GKTurnBasedMatchmakerViewController!, playerQuitForMatch match: GKTurnBasedMatch!) {
        
    }
    
    func turnBasedMatchmakerViewControllerWasCancelled(viewController: GKTurnBasedMatchmakerViewController!) {
        
    }
}