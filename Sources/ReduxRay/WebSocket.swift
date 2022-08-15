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
    webSocket = urlSession.webSocketTask(with: URL(string: "ws://\(getIPAddress()!):3002/redux")!)
    webSocket.resume()
}

func send(_ string: String) {
    webSocket.send(.string(string)) { error in
        print("Error: \(String(describing: error)) occurred while connecting via websocket!")
    }
}

func getIPAddress() -> String? {
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            
            let interface = ptr?.pointee
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name: String = String(cString: (interface?.ifa_name)!)
                if name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
    }
    return address
}
