import SwiftPryCore
import Foundation

var hoge: String? = nil
SwiftBulid().exec { (binaryPath) in
    LLDBBridge(binaryPath: binaryPath).launch()
}
while readLine() == nil {
    hoge = readLine()
}
print("hoge: \(String(describing: hoge))")
print("Hello, world!")
