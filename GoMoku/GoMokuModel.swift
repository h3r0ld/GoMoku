//
//  GoMokuModel.swift
//  GoMoku
//
//  Created by Herold Kristóf on 20/04/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import Foundation

class GoMokuModel {
    
    var matrix: [[Int]]
    var winSequence = 3
    
    var Size: Int{
        get {
                return matrix.count
        }
    }
    
    init (size: Int, winSequence: Int) {
        matrix = Array(count: size, repeatedValue: Array(count: size, repeatedValue: 0))
        self.winSequence = winSequence
    }
    
    func getMatrixAtIdx(XCoord x: Int,YCoord y:Int) -> Int {
        return matrix[x][y]
    }
    
    func setWinSequenceNeeded(sequenceLength: Int) {
        self.winSequence = sequenceLength
    }
    
    subscript(row: Int, column: Int) -> Int {
        get {
            return matrix[row][column]
        }
        set {
            matrix[row][column] = newValue
        }
    }
    
    func setMatrixAtIdx(XCoord x: Int,YCoord y:Int, Value value: Int) {
        matrix[x][y] = value
    }
    
    // Checking the matrix if it has a "specified ammount" of
    // numbers in a row or in a column
    // @param: sequenceSize - the "specified ammount"
    // @return: Returns the number, which can be found sequenceSize times in a row or column (sequently)
    func checkForWinHorizontalVertical(sequenceSize: Int) -> Int {
        var sequenceCountHor: Int
        var sequenceCountVer: Int
        
        for i in 0..<matrix.count {
            
            sequenceCountHor = 0
            sequenceCountVer = 0
            
            for j in 0..<matrix[i].count-1 {
                
                //if the "right" neighbour is the same - so it's a sequence horizontally
                if matrix[i][j] != 0 && matrix[i][j] == matrix [i][j+1] {
                    sequenceCountHor++;
                    //sequenceSize -1 comparison needed to specify the sequenceSize long sequence
                    if sequenceCountHor == sequenceSize - 1{
                        return matrix[i][j]
                    }
                } else {
                    sequenceCountHor = 0;
                }
                //if the "under" neighbour is the same - so it's a sequence vertically
                if matrix[j][i] != 0 && matrix[j][i] == matrix [j+1][i] {
                    sequenceCountVer++;
                    
                    //sequenceSize -1 comparison needed to specify the sequenceSize long sequence
                    if sequenceCountVer == sequenceSize - 1 {
                        return matrix[j][i]
                    }
                } else {
                    sequenceCountVer = 0;
                }
                
            }
        }
        return -1
    }
    
    // Checking the matrix if it has a "specified ammount" of
    // numbers in a right->left directioned diagonal.
    // @param: sequenceSize - the "specified ammount"
    // @return: Returns the number, which can be found sequenceSize times in a diagonal with right->left direction (sequently)
    func checkForWinDiagonalWithDirRL(sequenceSize: Int) -> Int {
        var sequenceCount = 0
        
        // Iteration through the left and upper bordered cells (first row and first column)
        for var i = 0; i < matrix.count - 1; i++ {
            
            if (i == 0) {
                // Iterating through first row
                for var j = 0; j < matrix.count - 1; j++ {
                    var y = j;
                    
                    // At each cell, we check the diagonal if it has a sequence, which starts with the cell
                    for var x = i; x < matrix[i].count - j; x++ {

                        if (x < matrix.count-1 && y < matrix.count-1) {
                        if matrix[x][y] != 0 && matrix[x][y] == matrix[x+1][y+1] {
                            sequenceCount++
                            if sequenceCount == sequenceSize - 1 {
                                return matrix[x][y]
                            }
                        } else {
                            sequenceCount = 0
                        }
                        }
                        y++
                    }
                }
            } else {
                // Iterating the first column
                var y = 0
                
                // At each cell, we check the diagonal if it has a sequence, which starts with the cell
                for var x = i; x < matrix.count-1; x++ {

                    if matrix[x][y] != 0 && matrix[x][y] == matrix[x+1][y+1] {
                        sequenceCount++
                        if sequenceCount == sequenceSize - 1 {
                            return matrix[x][y]
                        }
                        println("\(sequenceCount)")
                    } else {
                        sequenceCount = 0
                    }
                    
                    y++
                }
            }
            
        }
        
        
        return -1
    }

    // Checking the matrix if it has a "specified ammount" of
    // numbers in a right->left directioned diagonal.
    // @param: sequenceSize - the "specified ammount"
    // @return: Returns the number, which can be found sequenceSize times in a diagonal with left->right direction (sequently)
    func checkForWinDiagonalWithDirLR(sequenceSize: Int) -> Int {
        var sequenceCount = 0
        
        // Iteration through the left and lower border cells (last row and first column)
        for var i = 0; i < matrix.count; i++ {
            
            // If in the last row
            if i == matrix.count - 1 {
                
                //Iterating through the last row
                for var j = 0; j < matrix[i].count; j++ {
                    
                    var y = j
                    // At each cell, we check the diagonal if it has a sequence, which starts with the cell
                    for var x = i; x > j; x-- {
                        if (matrix[x][y] != 0 && matrix[x][y] == matrix[x-1][y+1]) {
                            sequenceCount++
                            
                            if sequenceCount == sequenceSize - 1 {
                                return matrix[x][y]
                            }
                        } else {
                            sequenceCount = 0
                        }
                        y++
                    }
                }
            } else {
                //Iterating the first column
                var y = 0
                // At each cell, we check the diagonal if it has a sequence, which starts with the cell
                for var x = i; x > 0; x-- {
                    if (matrix[x][y] != 0 && matrix[x][y] == matrix[x-1][y+1]) {
                        sequenceCount++
                        if sequenceCount == sequenceSize - 1 {
                            return matrix[x][y]
                        }
                    } else {
                        sequenceCount = 0
                    }
                    y++
                }
            }
        }
        return -1
    }
    
    func checkMatrixForWin(sequenceSize: Int) -> Int {
        let horizontalAndVerticalResult = checkForWinHorizontalVertical(sequenceSize)
        let diagonalResultWithRL = checkForWinDiagonalWithDirRL(sequenceSize)
        let diagonalResultWithLR = checkForWinDiagonalWithDirLR(sequenceSize)
        
        if horizontalAndVerticalResult != -1 {
            return horizontalAndVerticalResult
        }
        if diagonalResultWithLR != -1 {
            return diagonalResultWithLR
        }
        if diagonalResultWithRL != -1 {
            return diagonalResultWithRL
        }
        
        return -1
    }

    
    func resetMatrixValuesToNull() {
        for i in 0..<matrix.count {
            for j in 0..<matrix[i].count {
                matrix[i][j] = 0
            }
        }
    }
    
    
    //For Logging
    func printMatrix() {
        for i in 0..<matrix.count {
            for j in 0...matrix[i].count-1 {
                print("\(matrix[i][j]) ")
            }
            println()
        }
    }
}