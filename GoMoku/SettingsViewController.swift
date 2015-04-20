//
//  SettingsViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 20/04/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: UIViewController {
    @IBOutlet weak var mapSizeLabel: UILabel!
    @IBOutlet weak var mapSizeSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapSizeLabel.text = "\(Int(mapSizeSlider.value))"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapSizeSliderValueChanged(sender: AnyObject) {
        mapSizeLabel.text = "\(Int(mapSizeSlider.value))"

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
