import SwiftPryCore
import Foundation

//SwiftBulid().exec { (binaryPath) in
//    print(binaryPath)
//}
//LLDBBridge(binaryPath: "").launch()
var hoge: String? = readLine()!
while readLine() == nil {
    hoge = readLine()
}
print("hoge: \(String(describing: hoge))")
print("Hello, world!")
