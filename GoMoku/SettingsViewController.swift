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
    @IBOutlet weak var winSequenceSegmentedControl: UISegmentedControl!
    

    //Computer property for the Slider's rounded Int value
    var mapSizeSliderValue: Int{
        get {
            return Int(mapSizeSlider.value)
        }
    }
    
    var goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel

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
    
    override func viewWillDisappear(animated: Bool) {
        AppDelegate.sharedAppDelegate().myGoMoKuModel = GoMokuModel(size: mapSizeSliderValue)
        goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel
    }

    override func viewWillAppear(animated: Bool) {
        println("vWA + \(AppDelegate.sharedAppDelegate().myGoMoKuModel.Size)")
        mapSizeSlider.value = Float(AppDelegate.sharedAppDelegate().myGoMoKuModel.Size)
        mapSizeSlider.value = Float(goMokuModel.Size)
        
        switch goMokuModel.winSequence {
        case 3: winSequenceSegmentedControl.selectedSegmentIndex = 0
        case 4: winSequenceSegmentedControl.selectedSegmentIndex = 1
        case 5: winSequenceSegmentedControl.selectedSegmentIndex = 2
        default: winSequenceSegmentedControl.selectedSegmentIndex = 2
        }

    }
    
    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }



}
