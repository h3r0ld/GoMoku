//
//  SettingsViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 16/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit
// View controller for settings
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var winSeqSegCtrl: UISegmentedControl!
    @IBOutlet weak var mapSizeLabel: UILabel!
    @IBOutlet weak var mapSizeSlider: UISlider!
    
    var goMokuModel = GoMokuModel(size: 3, winSequence: 3)
    
    // Computed property for winSequence, it depends on the segmented control
    var winSequence: Int {
        get {
            switch winSeqSegCtrl.selectedSegmentIndex {
            case 0: return 3
            case 1: return 4
            case 2: return 5
            default: return 5
            }
        }
    }
    
    // Rounded integer value of the slider
    var mapSizeSliderValue: Int {
        get {
            return Int(mapSizeSlider.value)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // If the slider changes, we change the label
    @IBAction func mapSizeSliderValueChanged(sender: AnyObject) {
        mapSizeLabel.text = "\(Int(mapSizeSlider.value))"
    }
    
    // The model's winsequence is setted by the segmented control
    @IBAction func winSeqSegCtrlValueChanged(sender: AnyObject) {
        AppDelegate.sharedAppDelegate().myGoMoKuModel!.setWinSequenceNeeded(winSequence)
    }
    
    // If the view appears, we need to set the GUI, so it truly represents the model
    override func viewWillAppear(animated: Bool) {
        goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel!
        mapSizeSlider.value = Float(AppDelegate.sharedAppDelegate().myGoMoKuModel!.Size)
        mapSizeSlider.value = Float(goMokuModel.Size)
        mapSizeLabel.text = "\(mapSizeSliderValue)"
        
        switch goMokuModel.winSequence {
        case 3: winSeqSegCtrl.selectedSegmentIndex = 0
        case 4: winSeqSegCtrl.selectedSegmentIndex = 1
        case 5: winSeqSegCtrl.selectedSegmentIndex = 2
        default: winSeqSegCtrl.selectedSegmentIndex = 2
        }
    }
    
    // Save the changes
    override func viewWillDisappear(animated: Bool) {
        AppDelegate.sharedAppDelegate().myGoMoKuModel = GoMokuModel(size: mapSizeSliderValue, winSequence: winSequence)
    }

}
