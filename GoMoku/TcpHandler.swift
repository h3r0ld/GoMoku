//
//  TcpHandler.swift
//  SwiftNetworking
//
//  Created by Ben Herold on 16/05/15.
//  Copyright (c) 2015 Ben Herold. All rights reserved.
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
    
    func stopListening() {
        listenSocket.disconnect()
    }
    
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
    
    // ez hívódik meg, ha hozzánk csatlakozik valaki
    func socket(sock: GCDAsyncSocket!, didAcceptNewSocket newSocket: GCDAsyncSocket!) {
        connectedSocket = newSocket
        
        let host = connectedSocket.connectedHost()
        let port = connectedSocket.connectedPort()
        
        NSLog("Another device connected: %@:%d", host, port)
        
        // a UI szálon kell ezt futtatni, mert a UI-t fogjuk macerálni
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate.connected(host)
        })
        
        // két egész számot fogunk várni
        let intSize : UInt = UInt(sizeof(Int)) * 2
        
        // rögtön felkészülünk, hátha a másik küldeni fogja
        connectedSocket.readDataToLength(intSize, withTimeout: -1, tag: 0)
    }
    
    // ez hívódik meg, ha mi csatlakoztunk valakihez
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        let host = connectedSocket.connectedHost()
        let port = connectedSocket.connectedPort()
        
        NSLog("Connected to device: %@:%d", host, port)
        
        // a UI szálon kell ezt futtatni, mert a UI-t fogjuk macerálni
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate.connected(host)
        })
        
        // két egész számot fogunk várni
        let intSize : UInt = UInt(sizeof(Int)) * 2
        
        // rögtön felkészülünk, hátha a másik küldeni fogja
        connectedSocket.readDataToLength(intSize, withTimeout: -1, tag: 0)
    }
    
    // ez hívódik meg, ha adatot olvastunk be
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        // az NSData-ban byte-ok vannak, ezért kicsit macerás integerré konvertálni
        // lényegében annyit csinálunk, hogy a byte tömbből kiveszünk két integer méretű bytehalmazt
        // és azokat az integerekbe másoljuk
        
        let intLength = sizeof(Int)
        
        var num1 : Int = 0
        data.subdataWithRange(NSMakeRange(0, intLength)).getBytes(&num1, length: intLength)
        
        var num2 : Int = 0
        data.subdataWithRange(NSMakeRange(intLength, intLength)).getBytes(&num2, length: intLength)
        
        NSLog("Got two numbers: Number1: %d Number2: %d", num1, num2)
        
        // a UI szálon kell ezt futtatni, mert a UI-t fogjuk macerálni
        dispatch_async(dispatch_get_main_queue(), {
            self.delegate.receivedNumbers(num1, number2: num2)
        })
        
        // várjuk a következő adag számot
        let intSize : UInt = UInt(sizeof(Int)) * 2
        connectedSocket.readDataToLength(intSize, withTimeout: -1, tag: 0)
    }
    
    // ez hívódik meg, ha megszakadt a kapcsolat
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
            // a UI szálon kell ezt futtatni, mert a UI-t fogjuk macerálni
            dispatch_async(dispatch_get_main_queue(), {
                self.delegate.disconnected()
            })
        }
    }
    
    // ezt mi hívjuk, ha küldeni akarunk
    func sendNumbers(number1 : Int, number2 : Int) {
        var num1 = number1
        var num2 = number2
        
        var data = NSMutableData()
        data.appendBytes(&num1, length: sizeof(Int))
        data.appendBytes(&num2, length: sizeof(Int))
        
        connectedSocket.writeData(data, withTimeout: -1, tag: 0)
    }
}