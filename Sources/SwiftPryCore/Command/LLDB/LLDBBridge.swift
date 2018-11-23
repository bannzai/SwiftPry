import Foundation
import SwiftShell


public struct LLDBBridge {
    let binaryPath: String
    public init(binaryPath: String) {
        self.binaryPath = binaryPath
    }
    
    public func launch() {
        let command = main.runAsync(bash: "lldb")
        command.stdout.onStringOutput { (text) in
            print(text)
        }
        command.stderror.onStringOutput { (text) in
            print(text)
        }
        do {
            try command.finish()
        }  catch {
            print(error.localizedDescription)
        }
    }
}
