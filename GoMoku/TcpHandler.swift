//
//  TcpHandler.swift
//  SwiftNetworking
//
//  Created by Herold Kristóf on 16/05/15.
//  Copyright (c) 2015 Herold Kristóf. All rights reserved.
//

import Foundation

class TcpHandler : NSObject, GCDAsyncSocketDelegate {
    
    var socketQueue : dispatch_queue_t
    var listenSocket : GCDAsyncSocket!
    var connectedSocket : GCDAsyncSocket!
    let portNumber : UInt16 = 9999
    var delegate : NetworkDelegate
    
    
    init(delegate : NetworkDelegate) {
        socketQueue = dispatch_queue_create("socketQueue", DISPATCH_QUEUE_SERIAL)
        self.delegate = delegate
    }
    
    func startListening() {
        listenSocket = GCDAsyncSocket(delegate: self, delegateQueue: socketQueue)
        
        var error : NSError?

        let result = listenSocket.acceptOnPort(portNumber, error: &error)
        
        if(!result){
            
            NSLog("Can't start listening. Error: %@",error!.localizedDescription)
        }
        else {
            NSLog("Started listening on port %d",portNumber)
        }
    }
    
    // Stop listening on port
    func stopListening() {
        listenSocket.disconnect()
    }
    
    // Connect to device(IP address)
    func connectToDevice(ip : String) {
        
        connectedSocket = GCDAsyncSocket(delegate: self, delegateQueue: socketQueue)
        
        var error : NSError?
        
        let result = connectedSocket.connectToHost(ip, onPort: portNumber, error: &error)
        
        if(!result){
            NSLog("Can't connect to host: %@ Error: %@",ip,error!.localizedDescription)
        }
    }
    
    func disconnect() {
        connectedSocket.disconnect();
    }
    
    // Called when someone connected to us
    func socket(sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        connectedSocket = newSocket
        
        let host = connectedSocket.connectedHost()
        let port = connectedSocket.connectedPort()
        
        NSLog("Another device connected: %@:%d", host, port)
        

        // Run it on the UI thread, because we operate with the UI
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate.connected(host)
        })
        
        // We wait two integers
        let intSize : UInt = UInt(sizeof(Int)) * 2
        
        // Prepare immediately, if the other sends
        connectedSocket.readDataToLength(intSize, withTimeout: -1, tag: 0)
    }
    
    // Called when we connected to someone
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        let host = connectedSocket.connectedHost()
        let port = connectedSocket.connectedPort()
        
        NSLog("Connected to device: %@:%d", host, port)
        
        // Run it on the UI thread, because we operate with the UI
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate.connected(host)
        })
        
        // We wait two integers
        let intSize : UInt = UInt(sizeof(Int)) * 2
        
        // Prepare immediately, if the other sends
        connectedSocket.readDataToLength(intSize, withTimeout: -1, tag: 0)
    }
    
    // Called when we read data
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        // NSData stores bytes, so it is a bit complicated to cast it to integer
        // So we take out two integer sized byteset from the byte array
        // and we copy it to integers
        
        let intLength = sizeof(Int)
        
        var num1 : Int = 0
        data.subdataWithRange(NSMakeRange(0, intLength)).getBytes(&num1, length: intLength)
        
        var num2 : Int = 0
        data.subdataWithRange(NSMakeRange(intLength, intLength)).getBytes(&num2, length: intLength)
        
        NSLog("Got two numbers: Number1: %d Number2: %d", num1, num2)
        
        // Run it on the UI thread, because we operate with the UI
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate.receivedNumbers(num1, number2: num2)
        })
        
        // We wait for the next numbers...
        let intSize : UInt = UInt(sizeof(Int)) * 2
        connectedSocket.readDataToLength(intSize, withTimeout: -1, tag: 0)
    }
    
    // Called, when disconnected
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        if  listenSocket != nil && sock == listenSocket{
            NSLog("Stopped listening")
        }
        else {
            if(err == nil){
                NSLog("Disconnected.")
            }
            else {
                NSLog("Disconnected. %@", err.localizedDescription)
            }
            // Run it on the UI thread, because we operate with the UI
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate.disconnected()
            })
        }
    }
    
    // We call this, if we want to send numbers
    func sendNumbers(number1 : Int, number2 : Int) {
        var num1 = number1
        var num2 = number2
        
        var data = NSMutableData()
        data.appendBytes(&num1, length: sizeof(Int))
        data.appendBytes(&num2, length: sizeof(Int))
        
        connectedSocket.writeData(data, withTimeout: -1, tag: 0)
    }
}