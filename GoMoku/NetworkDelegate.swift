//
//  NetworkDelegate.swift
//  GoMoku
//
//  Created by Herold Kristóf on 18/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import Foundation

protocol NetworkDelegate {
    func connected(host: String)
    func disconnected()
    func receivedNumbers(number1: Int, number2: Int)
}