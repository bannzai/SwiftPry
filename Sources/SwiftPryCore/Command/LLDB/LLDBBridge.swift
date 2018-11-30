import Foundation
import SwiftShell

public class WriterContainer {
    let writer: WritableStream
    
    init(writer: WritableStream) {
        self.writer = writer
    }
}

extension WriterContainer: WritableStream {
    public var encoding: String.Encoding {
        get { return writer.encoding }
        set { writer.encoding = newValue }
    }
    
    public var filehandle: FileHandle {
        return writer.filehandle
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


public class LLDBBridge {
    let binaryPath: String
    var context: Context & CommandRunning

    public init(binaryPath: String) {
        self.binaryPath = binaryPath
        self.context = CustomContext(main)
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
    public func write(_ string: String) {
//        self.writer.write(string)
    }
}
