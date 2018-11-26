import Foundation
import SwiftShell

public class WriterContainer { }

extension WriterContainer: WritableStream {
    public var encoding: String.Encoding {
        get { return .utf8 }
        set { print(newValue) }
    }
    
    public var filehandle: FileHandle {
        return FileHandleStream(.standardOutput, encoding: .utf8).filehandle
    }
    
    public func write(_ x: String) {
        Swift.print("line: \(#line), file: \(#file), content: " + x)
    }
    
    public func write(data: Data) {
        Swift.print("line: \(#line), file: \(#file), content: " + String(data: data, encoding: .utf8)!)
    }
}

public class ReaderContainer {
    let reader: ReadableStream
    
    init(reader: ReadableStream) {
        self.reader = reader
    }
}

extension ReaderContainer: ReadableStream {
    public var encoding: String.Encoding {
        get { return reader.encoding }
        set { reader.encoding = newValue }
    }
    
    public var filehandle: FileHandle {
        return reader.filehandle
    }
    
    public func read() -> String {
        let readContent = reader.read()
        Swift.print("line: \(#line), file: \(#file), content: " + readContent)
        return readContent
    }
}


public struct LLDBBridge {
    let binaryPath: String
    var context: Context & CommandRunning
    var writer: WriterContainer
    
    public init(binaryPath: String) {
        self.binaryPath = binaryPath
        
        self.writer = WriterContainer()
        self.context = CustomContext(main)
    }
    
    public mutating func launch() {
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
            self.context.stdin.write(to: &self.writer)
            self.context.stdin.onStringOutput { (string) in
                print(string)
            }
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
//        self.writer.write(string)
    }
}
