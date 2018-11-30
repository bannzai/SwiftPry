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


func output(_ string: String) {
    let standardOutput = FileHandle.standardOutput
    standardOutput.write(string)

}

public class LLDBBridge {
    let binaryPath: String
    var context: Context & CommandRunning

    public init(binaryPath: String) {
        self.binaryPath = binaryPath
        self.context = CustomContext(main)
    }
    
    public func launch() {
        let command = context.run(bash: "echo hoge")
        print("stdout: " + command.stdout)
//        command.stdout.onStringOutput { (text) in
//            if text.contains("(lldb)") {
//                output("(pry)")
//                return
//            }
//            output(text + "line: \(#line), file: \(#file)")
//        }
//        command.stderror.onStringOutput { (text) in
//            output(text + "line: \(#line), file: \(#file)")
//        }
//        do {
//            try command.finish()
//        }  catch {
//            output(error.localizedDescription)
//            exit(2)
//        }
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
