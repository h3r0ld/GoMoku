//
//  endGameViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 18/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit

// Represent the outcome
class endGameViewController: UIViewController {
    
    @IBOutlet weak var outcomeLabel: UILabel!
    var outcomeLabelText: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        outcomeLabel.text = outcomeLabelText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("Memory warning!")
    }
}
