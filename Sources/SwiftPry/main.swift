import SwiftPryCore
import Foundation
import SwiftShell

//main.run(bash: "rm -rf /Users/hiroseyuudai/develop/oss/Kuri/.build")

print("start")

main.currentdirectory = SwiftBulidTestValue.swiftCodePath
print(main.run(bash: "tty").stdout)

var hoge: String? = nil
var bridge = LLDBBridge(binaryPath: "/Users/hiroseyuudai/develop/oss/Kuri/.build/x86_64-apple-macosx10.10/debug/Kuri")
//SwiftBulid().exec { (binaryPath) in
//    bridge = LLDBBridge(binaryPath: binaryPath)
//}

//while bridge == nil {
//    // wait for launch lldb
//}

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
