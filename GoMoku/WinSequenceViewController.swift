//
//  WinSequenceViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 16/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit

class WinSequenceViewController: UIViewController {
    @IBOutlet weak var winSequenceSegCtrl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func winSeqSegCtrlValueChanged(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        var winSequence: Int
        
        switch segmentedControl.selectedSegmentIndex {
        case 0: winSequence = 3
        case 1: winSequence = 4
        case 2: winSequence = 5
        default: winSequence = 5
        }
        AppDelegate.sharedAppDelegate().myGoMoKuModel!.setWinSequenceNeeded(winSequence)
    }

    override func viewWillAppear(animated: Bool) {
        let goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel
        switch goMokuModel!.winSequence {
        case 3: winSequenceSegCtrl.selectedSegmentIndex = 0
        case 4: winSequenceSegCtrl.selectedSegmentIndex = 1
        case 5: winSequenceSegCtrl.selectedSegmentIndex = 2
        default: winSequenceSegCtrl.selectedSegmentIndex = 2
        }
    }
    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        AppDelegate.sharedAppDelegate().myGoMoKuModel!.setWinSequenceNeeded(winSequenceSegCtrl.selectedSegmentIndex+3)
    }
    */
}
