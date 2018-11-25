import Foundation
import SwiftShell


public struct LLDBBridge {
    let binaryPath: String
    var context: CustomContext
    public init(binaryPath: String) {
        self.binaryPath = binaryPath
        self.context = CustomContext()
        self.context.stdin = main.stdin
        redirect()
    }
    
    public func launch() {
        let command = context.runAsync(bash: "lldb")
        command.stdout.onStringOutput { (text) in
            if text.contains("(lldb)") {
                print("(pry)")
                return
            }
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
    
    func redirect() {
        var variable = self
        context.stdin.write(to: &variable)
    }
}

extension LLDBBridge: TextOutputStream {
    public mutating func write(_ string: String) {
        
    }
}
