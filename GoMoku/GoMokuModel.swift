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
    
    init (size: Int) {
        matrix = Array(count: size, repeatedValue: Array(count: size, repeatedValue: 0))
    }
    
    
    func getMatrixAtIdx(XCoord x: Int,YCoord y:Int) -> Int {
        return matrix[x][y]
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
        
        for i in 0...matrix.count-1 {
            
            sequenceCountHor = 0
            sequenceCountVer = 0
            
            for j in 0...matrix[i].count-2 {
                
                //if the right neighbour is the same - so it's a sequence
                if matrix[i][j] != 0 && matrix[i][j] == matrix [i][j+1] {
                    sequenceCountHor++;
                    
                    //sequenceSize -1 comparison needed to specify the sequenceSize long sequence
                    if sequenceCountHor == sequenceSize - 1{
                        return matrix[i][j]
                    }
                } else {
                    sequenceCountHor = 0;
                }
                //if the "down" neighbour is the same
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
    
    func checkForWinDiagonalWithDirLR(sequenceSize: Int) -> Int {
        return -1
    }
    
    func checkForWinDiagonalWithDirRL(sequenceSize: Int) -> Int {
        return -1
    }
    
    func printMatrix() {
        for i in 0...matrix.count-1 {
            for j in 0...matrix[i].count-1 {
                print("\(matrix[i][j]) ")
            }
            println()
        }
    }
}