import Foundation
import SwiftShell


public struct LLDBBridge {
    let binaryPath: String
    let context: CustomContext
    public init(binaryPath: String) {
        self.binaryPath = binaryPath
        self.context = CustomContext(main)
    }
    
    public func launch() {
        let command = context.runAsync(bash: "lldb")
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
