//
//  MapSizeViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 16/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit

class MapSizeViewController: UIViewController {
    @IBOutlet weak var mapSizeSlider: UISlider!
    @IBOutlet weak var mapSizeLabel: UILabel!
    
    var mapSizeSliderValue: Int{
        get {
            return Int(mapSizeSlider.value)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mapSizeLabel.text = "\(mapSizeSliderValue)"
        AppDelegate.sharedAppDelegate().myGoMoKuModel = GoMokuModel(size: mapSizeSliderValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func mapSizeSliderValueChanged(sender: AnyObject) {
        mapSizeLabel.text = "\(mapSizeSliderValue)"
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
