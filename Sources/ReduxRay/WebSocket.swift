//
//  WebSocket.swift
//  
//
//  Created by Aleksey Yakimenko on 15/8/22.
//

import Foundation

var webSocket: URLSessionWebSocketTask!

func connectIfNeeded() {
    if webSocket == nil {
        connect()
    }
}

func connect() {
    let urlSession = URLSession(configuration: .default)
    webSocket = urlSession.webSocketTask(with: URL(string: "ws://127.0.0.1:3002/taga")!)
    webSocket.resume()
}

func send(_ string: String) {
    webSocket.send(.string(string)) { error in
        print("Error: \(String(describing: error)) occurred while connecting via websocket!")
    }
}
