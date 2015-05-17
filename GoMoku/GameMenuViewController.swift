//
//  GameMenuViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 28/04/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit

class GameMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue == "NewGameSegue" {
            var VC = segue.destinationViewController as! NewGameViewController
            VC.buildMatrixDisplay()
        }
        
    }

}
