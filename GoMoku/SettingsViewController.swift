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

    //Computer property for the Slider's rounded Int value
    var mapSizeSliderValue: Int{
        get {
            return Int(mapSizeSlider.value)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapSizeLabel.text = "\(mapSizeSliderValue)"
        AppDelegate.sharedAppDelegate().myGoMoKuModel = GoMokuModel(size: mapSizeSliderValue)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func mapSizeSliderValueChanged(sender: AnyObject) {
        mapSizeLabel.text = "\(Int(mapSizeSlider.value))"

    }
    
    @IBAction func winSequenceSegmentedControlValueChanged(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        var winSequence: Int

        switch segmentedControl.selectedSegmentIndex {
        case 0: winSequence = 3
        case 1: winSequence = 4
        case 2: winSequence = 5
        default: winSequence = 5
        }
        AppDelegate.sharedAppDelegate().myGoMoKuModel.setWinSequenceNeeded(winSequence)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        AppDelegate.sharedAppDelegate().myGoMoKuModel = GoMokuModel(size: mapSizeSliderValue)
    }


}
