
//
//  NewGameViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 28/04/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {
    var goMokuViews: [[GoMokuView]] = []
    var goMokuMatrix: [[Int]] = []
    var goMokuModel: GoMokuModel?
    var rectSize: Int = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel
        goMokuMatrix = AppDelegate.sharedAppDelegate().myGoMoKuModel.matrix
        
        goMokuViews = Array(count: goMokuMatrix.count, repeatedValue: Array(count: goMokuMatrix[0].count, repeatedValue: GoMokuView()))
        
        buildUpView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buildUpView() {
        for var i = 0; i < goMokuMatrix.count; i++ {
            for var j = 0; j < goMokuMatrix[i].count; j++ {
                goMokuViews[i][j] = GoMokuView(frame: CGRect(x: 100 + i + i * rectSize, y: 100 + j + j * rectSize, width: rectSize, height: rectSize))
                goMokuViews[i][j].idx = i
                goMokuViews[i][j].idy = j
                goMokuViews[i][j].backgroundColor = UIColor.redColor()
                var view = goMokuViews[i][j]
                self.view.addSubview(goMokuViews[i][j])
            }
        }
        

        
    }
    
    func updateView() {

    }
    
    func refreshMatrixDisplay() {
        for view in self.view.subviews {
            view.removeFromParentViewController()
        }
        
        goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel
        goMokuMatrix = AppDelegate.sharedAppDelegate().myGoMoKuModel.matrix
        
        buildUpView()
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
