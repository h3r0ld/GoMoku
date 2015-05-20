
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
    var goMokuModel: GoMokuModel!
    var rectSize: CGFloat = 0
    var winner: String!
    
    var player1isComing = true
    // A container view for the goMokuViews
    @IBOutlet weak var goMokuScene: UIView!
    
    // When the view loads, we need to:
    // - store the model
    // - reset the values to null (after a previous game for example)
    // - initialize the views' matrix
    // - define the views' size
    // - build up the view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel
        goMokuModel.resetMatrixValuesToNull()
        goMokuViews = Array(count: goMokuModel.Size, repeatedValue: Array(count: goMokuModel.Size, repeatedValue: GoMokuView()))
        
        rectSize = (UIScreen.mainScreen().bounds.width / CGFloat(goMokuModel!.Size)) - 1
        buildUpView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Building up the view:
    // - Model's matrix size = Views' matrix size
    // - Set the indices
    // - Add tap gesture recognizer
    // - Add it to the container view
    func buildUpView() {
        for var i = 0; i < goMokuModel.Size; i++ {
            for var j = 0; j < goMokuModel.Size; j++ {
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
    
    // Action method, called, when a goMokuView is tapped
    func cellTapped(sender: UITapGestureRecognizer) {
        
        // Get the view, which sent the action
        let tappedView = sender.view as! GoMokuView
        
        // If player 1 is coming, and the tapped view was previously untouched
        if player1isComing &&  goMokuModel?.getMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy) == 0 {
            
            // Set the value in the matrix
            goMokuModel?.setMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy, Value: 1)
            
            // Set the color on the GUI
            tappedView.backgroundColor = UIColor(red: 0.027, green: 0.262, blue: 0.69, alpha: 1) //dark blue
            
            player1isComing = false
            // Check if we won the game with this step
            if goMokuModel?.checkMatrixForWin() == 1 {
                println("Blue won the game.")
                winner = "Blue won the game"
                performSegueWithIdentifier("endGameSegue", sender: self)
            } else {
                // If it is a draw
                if goMokuModel!.isMatrixFullWithValues() {
                    println("It's a draw")
                    winner = "It's a draw!"
                    performSegueWithIdentifier("endGameSegue", sender: self)
                }
            }
            goMokuModel?.printMatrix()
            println()
        } else
        if (goMokuModel?.getMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy) == 0) {
            
            goMokuModel?.setMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy, Value: 2)
            
            tappedView.backgroundColor = UIColor(red: 0.419, green: 0.188, blue: 0.5607, alpha: 1) // darkpurple
            player1isComing = true
            
            if goMokuModel?.checkMatrixForWin() == 2 {
                println("Purple won the game.")
                winner = "Purple won the game!"
                performSegueWithIdentifier("endGameSegue", sender: self)
            } else {
            if goMokuModel!.isMatrixFullWithValues() {
                println("It's a draw")
                winner = "It's a draw!"
                performSegueWithIdentifier("endGameSegue", sender: self)
                }
            }
            goMokuModel?.printMatrix()
            println()
        }
        
        
    }
    
    // Resets the game:
    // - matrix values to 0
    // - reset colors
    func resetGameSpace() {
        goMokuModel!.resetMatrixValuesToNull()
        resetMatrixDisplay()
    }
    
    // Reset the colors in the game scene
    func resetMatrixDisplay() {
        for var i = 0; i < goMokuModel?.Size; i++ {
            for var j = 0; j < goMokuModel?.Size; j++ {
                goMokuViews[i][j].backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 0.8)
            }
        }
    }
    
    // Remove the goMokuviews, and build it up again
    func buildMatrixDisplay() {
        for view in self.view.subviews {
            view.removeFromParentViewController()
        }
        goMokuModel = AppDelegate.sharedAppDelegate().myGoMoKuModel
        buildUpView()
    }
    
    // Unwind segue - back from the outcome presenter view controller
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
        resetGameSpace()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If the game ended, set the text to present
        if segue.identifier == "endGameSegue" {
            let endGameVC = segue.destinationViewController as! endGameViewController
            endGameVC.outcomeLabelText = winner
        }
        
    }
    
    
    

}
