import Foundation
import SwiftShell

public struct WriterContainer {
    let writer: WritableStream
    
    init(writer: WritableStream) {
        self.writer = writer
    }
}


public struct LLDBBridge {
    let binaryPath: String
    var context: Context & CommandRunning
    let writer: WriterContainer
    
    public init(binaryPath: String) {
        self.binaryPath = binaryPath
        self.context = CustomContext(main)
        let (writer, reader) = streams()
        self.context.stdin = reader
        self.writer = WriterContainer(writer: writer)
    }
    
    public func launch() {
        let command = context.runAsync(bash: "lldb \(binaryPath)")
        command.stdout.onStringOutput { (text) in
            if text.contains("(lldb)") {
                print("(pry)")
                return
            }
            print(text + "line: \(#line), file: \(#file)")
        }
        command.stderror.onStringOutput { (text) in
            print(text + "line: \(#line), file: \(#file)")
        }
        do {
            try command.finish()
        }  catch {
            print(error.localizedDescription)
            exit(2)
        }
    }
    
    func redirect() {
//        var variable = self
//        context.stdin.write(to: &variable)
    }
    
}

extension LLDBBridge {
    public mutating func write(_ string: String) {
        self.writer.writer.write(string)
    }
}
