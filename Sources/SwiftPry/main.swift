import SwiftPryCore
import Foundation
import SwiftShell

var hoge: String? = nil
var bridge: LLDBBridge!
SwiftBulid().exec { (binaryPath) in
    bridge = LLDBBridge(binaryPath: binaryPath)
    bridge.launch()
}
while true {
    hoge = readLine()
    if hoge != nil && bridge != nil {
        bridge.write(hoge!)
    } else if hoge == "exit" {
        exit(1)
    }
}
//bridge = LLDBBridge(binaryPath: binaryPath)
//bridge.launch()

//while true {
//    hoge = readLine()
//    if hoge != nil && bridge != nil {
//        bridge.write(hoge!)
//    } else if hoge == "exit" {
//        exit(1)
//    }
//}
print("Hello, world!")
