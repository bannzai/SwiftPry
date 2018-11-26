import SwiftPryCore
import Foundation
import SwiftShell

main.run(bash: "rm -rf /Users/hiroseyuudai/develop/oss/Kuri/.build")

var hoge: String? = nil
var bridge: LLDBBridge!
SwiftBulid().exec { (binaryPath) in
    bridge = LLDBBridge(binaryPath: binaryPath)
}

while bridge == nil {
    // wait for launch lldb
}

bridge.launch()

//while let input = readLine() {
//    bridge.write(input)
//    print("stdin: " + input)
//}

//let binaryPath = SwiftBulid().exec()
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
