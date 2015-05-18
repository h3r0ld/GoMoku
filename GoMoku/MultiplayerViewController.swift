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
    var goMokuMatrix: [[Int]] = []
    var goMokuViews: [[GoMokuView]] = []
    var rectSize: CGFloat = 0
    var outcome: String!
    var myTurn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        goMokuMatrix = goMoku.matrix
        goMoku.resetMatrixValuesToNull()
        goMokuViews = Array(count: goMokuMatrix.count, repeatedValue: Array(count: goMokuMatrix[0].count, repeatedValue: GoMokuView()))
        
        rectSize = (UIScreen.mainScreen().bounds.width / CGFloat(goMoku!.Size)) - 1
        tcpHandler.delegate = self
        
        if myTurn {
            messageLabel.text = "Yaay, It's my turn."
        } else {
            messageLabel.text = "Waiting for other player."
        }
        
        buildUpView()
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
                container.addSubview(view)
                
            }
        }
    }
    
    func cellTapped(sender: UITapGestureRecognizer) {
        
        let tappedView = sender.view as! GoMokuView
        
        if myTurn && goMoku.getMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy) == 0 {
            goMoku.setMatrixAtIdx(XCoord: tappedView.idx, YCoord: tappedView.idy, Value: 1)
            tappedView.backgroundColor = UIColor.redColor()
            tcpHandler.sendNumbers(tappedView.idx, number2: tappedView.idy)
            myTurn = false
            if goMoku.checkMatrixForWin() == 1 {
                println("You won the game!")
                outcome = "You won the game!"
                performSegueWithIdentifier("endGameSegue", sender: self)
            }
            goMoku?.printMatrix()
            println()
            messageLabel.text = "Waiting for other player"
        }
    }
    
    func connected(host: String) {
        //Not using here, we are already connected
    }
    
    func disconnected() {
        messageLabel.text = "The other player fleed from the battlefield in fear."
        myTurn = false
    }
    
    func receivedNumbers(number1: Int, number2: Int) {
        goMoku.setMatrixAtIdx(XCoord: number1, YCoord: number2, Value: 2)
        goMokuViews[number1][number2].backgroundColor = UIColor.blackColor()
        if goMoku.checkMatrixForWin() == 2 {
            println("You lost the game.")
            outcome = "You won the game!"
            performSegueWithIdentifier("endGameSegue", sender: self)
        }
        myTurn = true
        messageLabel.text = "It's my turn!!! yaaay"
    }
    
    func resetGameSpace() {
        goMoku.resetMatrixValuesToNull()
        resetMatrixDisplay()
    }
    
    func resetMatrixDisplay() {
        for var i = 0; i < goMokuMatrix.count; i++ {
            for var j = 0; j < goMokuMatrix[i].count; j++ {
                goMokuViews[i][j].backgroundColor = UIColor(red: 0.1, green: 0.4, blue: 0.9, alpha: 0.8)
            }
        }
    }
    
    @IBAction func unwindToMultiPlayerViewController(segue: UIStoryboardSegue) {
        resetGameSpace()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        tcpHandler.disconnect()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "endGameSegue" {
            let MPendGameVC = segue.destinationViewController as! MultiplayerEndGameViewController
            MPendGameVC.outcomeLabel = self.outcome
        }
    }
    
}