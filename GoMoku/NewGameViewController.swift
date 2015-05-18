
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
    var rectSize: CGFloat = 0
    var winner: String!
    
    var player1isComing = true
    
    @IBOutlet weak var goMokuScene: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel
        goMokuMatrix = AppDelegate.sharedAppDelegate().myGoMoKuModel!.matrix
        goMokuModel!.resetMatrixValuesToNull()
        goMokuViews = Array(count: goMokuMatrix.count, repeatedValue: Array(count: goMokuMatrix[0].count, repeatedValue: GoMokuView()))
        
        rectSize = (UIScreen.mainScreen().bounds.width / CGFloat(goMokuModel!.Size)) - 1
        buildUpView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func buildUpView() {
        for var i = 0; i < goMokuMatrix.count; i++ {
            for var j = 0; j < goMokuMatrix[i].count; j++ {
                var CGi = CGFloat(i)
                var CGj = CGFloat(j)
        
                goMokuViews[i][j] = GoMokuView(frame: CGRect(x:  CGj + CGj * rectSize, y: CGi + CGi * rectSize, width: rectSize, height: rectSize))
                
                var view = goMokuViews[i][j]
                view.idx = i
                view.idy = j
                view.backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 0.8)

                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cellTapped:"))
                goMokuScene.addSubview(view)
                
            }
        }
    }
    
    func cellTapped(sender: UITapGestureRecognizer) {
        
        let tappedView = sender.view as! GoMokuView
        
        if player1isComing &&  goMokuModel?.getMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy) == 0{
            goMokuModel?.setMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy, Value: 1)
            tappedView.backgroundColor = UIColor.redColor()
            player1isComing = false
            if goMokuModel?.checkMatrixForWin() == 1 {
                println("Player 1 won the game.")
                winner = "Player 1"
                performSegueWithIdentifier("endGameSegue", sender: self)
            }
            goMokuModel?.printMatrix()
            println()
        } else
        if (goMokuModel?.getMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy) == 0){
            goMokuModel?.setMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy, Value: 2)
            tappedView.backgroundColor = UIColor.grayColor()
            player1isComing = true
            if goMokuModel?.checkMatrixForWin() == 2 {
                println("Player 2 won the game.")
//                presentModalVCwithText("Player 2 won the game.")
                winner = "Player 2"
                performSegueWithIdentifier("endGameSegue", sender: self)
            }
            goMokuModel?.printMatrix()
            println()
        }
        
        
    }
    
    func resetGameSpace() {
        goMokuModel!.resetMatrixValuesToNull()
        resetMatrixDisplay()
    }
    
    func resetMatrixDisplay() {
        for var i = 0; i < goMokuMatrix.count; i++ {
            for var j = 0; j < goMokuMatrix[i].count; j++ {
                goMokuViews[i][j].backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 0.8)
            }
        }
    }
    
    func buildMatrixDisplay() {
        for view in self.view.subviews {
            view.removeFromParentViewController()
        }
        
        goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel
        goMokuMatrix = AppDelegate.sharedAppDelegate().myGoMoKuModel!.matrix
        
        buildUpView()
    }
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        resetGameSpace()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "endGameSegue" {
            let endGameVC = segue.destinationViewController as! endGameViewController
            endGameVC.outcomeLabelText = winner
        }
        
    }
    
    
    

}
