//
//  MultiplayerEndGameViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 18/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit

class MultiplayerEndGameViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    var outcomeLabel: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = outcomeLabel
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
