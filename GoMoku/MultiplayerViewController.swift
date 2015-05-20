//
//  MultiplayerViewController.swift
//  GoMoku
//
//  Created by Herold Kristóf on 18/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import UIKit

class MultiplayerViewController: UIViewController, NetworkDelegate {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var tcpHandler: TcpHandler!
    var goMoku: GoMokuModel!
    var goMokuViews: [[GoMokuView]] = []
    var rectSize: CGFloat = 0
    var outcome: String!
    var myTurn: Bool = false

    // When the view loads, we need to:
    // - store the model
    // - reset the values to null (after a previous game for example)
    // - initialize the views' matrix
    // - define the views' size
    // - set outselves to the tcpHandler's delegate
    // - build up the view
    // - set the initial message text
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goMoku.resetMatrixValuesToNull()
        goMokuViews = Array(count: goMoku.Size, repeatedValue: Array(count: goMoku.Size, repeatedValue: GoMokuView()))
        
        rectSize = (UIScreen.mainScreen().bounds.width / CGFloat(goMoku!.Size)) - 1
        tcpHandler.delegate = self
        
        if myTurn {
            messageLabel.text = "Yaay, It's my turn."
        } else {
            messageLabel.text = "Waiting for other player."
        }
        
        buildUpView()
    }
    
    // Building up the view:
    // - Model's matrix size = Views' matrix size
    // - Set the indices
    // - Add tap gesture recognizer
    // - Add it to the container view
    func buildUpView() {
        for var i = 0; i < goMoku.Size; i++ {
            for var j = 0; j < goMoku.Size; j++ {
                var CGi = CGFloat(i)
                var CGj = CGFloat(j)
                
                goMokuViews[i][j] = GoMokuView(frame: CGRect(x:  CGj + CGj * rectSize, y: CGi + CGi * rectSize, width: rectSize, height: rectSize))
                
                var view = goMokuViews[i][j]
                view.idx = i
                view.idy = j
                view.backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 0.8)
                
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cellTapped:"))
                container.addSubview(view)
            }
        }
    }
    
    // Action method, called, when a goMokuView is tapped
    func cellTapped(sender: UITapGestureRecognizer) {

        let tappedView = sender.view as! GoMokuView
        
        if myTurn && goMoku.getMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy) == 0 {
            
            goMoku.setMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy, Value: 1)
            tappedView.backgroundColor = UIColor(red: 0.027, green: 0.262, blue: 0.69, alpha: 1) //dark blue
            
            // Send the tapped view's indices to the other player
            tcpHandler.sendNumbers(tappedView.idx, number2: tappedView.idy)
            myTurn = false
            
            //Check for win
            if goMoku.checkMatrixForWin() == 1 {
                println("You won the game!")
                outcome = "You won the game!"
                performSegueWithIdentifier("endGameSegue", sender: self)
            } else {
                // Chekc for draw
                if goMoku!.isMatrixFullWithValues() {
                    println("It's a draw")
                    outcome = "It's a draw!"
                    performSegueWithIdentifier("endGameSegue", sender: self)
                }
            }
            goMoku?.printMatrix()
            println()
            messageLabel.text = "Waiting for other player"
        }
    }
    
    func connected(host: String) {
        //Not using here, we've already established the connection
    }
    
    // If the other player disconnects from the game
    func disconnected() {
        messageLabel.text = "The other player left the game."
        myTurn = false
    }
    
    // The numbers we got from the other player
    func receivedNumbers(number1: Int, number2: Int) {
        // Set the tapped view...
        goMoku.setMatrixAtIdx(XCoord: number1, YCoord: number2, Value: 2)
        goMokuViews[number1][number2].backgroundColor = UIColor(red: 0.419, green: 0.188, blue: 0.5607, alpha: 1) // darkpurple
        // Check if other player has won the game
        if goMoku.checkMatrixForWin() == 2 {
            println("You lost the game.")
            outcome = "You lost the game!"
            performSegueWithIdentifier("endGameSegue", sender: self)
        } else {
        // Check if draw
            if goMoku.isMatrixFullWithValues() {
                println("It's a draw")
                outcome = "It's a draw!"
                performSegueWithIdentifier("endGameSegue", sender: self)
            }
        }
        myTurn = true
        messageLabel.text = "It's my turn!"
    }
    
    // Resets the game:
    // - matrix values to 0
    // - reset colors
    func resetGameSpace() {
        goMoku.resetMatrixValuesToNull()
        resetMatrixDisplay()
    }
    
    // Reset the colors in the game scene
    func resetMatrixDisplay() {
        for var i = 0; i < goMoku.Size; i++ {
            for var j = 0; j < goMoku.Size; j++ {
                goMokuViews[i][j].backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 0.8)
            }
        }
    }
    
    // Unwind segue - reset the game
    @IBAction func unwindToMultiPlayerViewController(segue: UIStoryboardSegue) {
        resetGameSpace()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("Memory warning")
    }
    
    // If the view disappears
    // Checks if the navigationController removes this view from the view controllers
    // (Which it onl does, if we tap the back button)
    override func viewWillDisappear(animated: Bool) {
        var isRemoved = true
        for vc in self.navigationController!.viewControllers {
            if vc as! UIViewController == self {
                isRemoved = false
            }
        }
        // Disconnect if we tapped the back button
        if isRemoved {
            tcpHandler.disconnect()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // If the game ended, set the text to present
        if segue.identifier == "endGameSegue" {
            let MPendGameVC = segue.destinationViewController as! endGameViewController
            MPendGameVC.outcomeLabelText = self.outcome
        }
    }
    
}