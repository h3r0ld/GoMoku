//
//  GameMenuViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 28/04/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit
// View controller for game mode selection
class GameMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue == "NewGameSegue" {
            var VC = segue.destinationViewController as! NewGameViewController
            VC.buildMatrixDisplay()
        }
    }
    
}
