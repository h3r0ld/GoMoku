//
//  SettingsViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 16/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var winSeqSegCtrl: UISegmentedControl!
    @IBOutlet weak var mapSizeLabel: UILabel!
    @IBOutlet weak var mapSizeSlider: UISlider!
    
    var goMokuModel = GoMokuModel(size: 3, winSequence: 3)
    var winSequence = 0
    
    var mapSizeSliderValue: Int {
        get {
            return Int(mapSizeSlider.value)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func mapSizeSliderValueChanged(sender: AnyObject) {
        mapSizeLabel.text = "\(Int(mapSizeSlider.value))"
    }
    
    @IBAction func winSeqSegCtrlValueChanged(sender: AnyObject) {
        
        let segmentedControl = sender as! UISegmentedControl
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: winSequence = 3
        case 1: winSequence = 4
        case 2: winSequence = 5
        default: winSequence = 5
        }
        AppDelegate.sharedAppDelegate().myGoMoKuModel!.setWinSequenceNeeded(winSequence)
    }
    
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
    
    override func viewWillDisappear(animated: Bool) {
        AppDelegate.sharedAppDelegate().myGoMoKuModel = GoMokuModel(size: mapSizeSliderValue, winSequence: winSequence)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
