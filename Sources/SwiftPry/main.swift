import SwiftPryCore
import Foundation

var hoge: String? = nil
let binaryPath = SwiftBulid().exec()
LLDBBridge(binaryPath: binaryPath).launch()
print("hoge: \(String(describing: hoge))")
print("Hello, world!")
