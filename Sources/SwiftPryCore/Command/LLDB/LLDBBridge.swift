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
        self.context = main
    }
    
    public func launch() {
        let input = main.stdin.filehandle
        let inputPipe = Pipe()
        let outPipe = Pipe()

        let process = Process()
        process.launchPath = "/usr/bin/lldb"
        process.arguments = [binaryPath]
        process.standardInput = inputPipe
        process.standardOutput = outPipe
        process.standardError = main.stderror.filehandle
        process.launch()
        
        input.waitForDataInBackgroundAndNotify()
        outPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
        outPipe.fileHandleForReading.readabilityHandler = { fileHandler in
            let data = fileHandler.availableData
            if let output = String(data: data, encoding: .utf8) {
                print("readabilityHandler: \(output)")
            }
        }

        NotificationCenter
            .default
            .addObserver(
                forName: NSNotification.Name.NSFileHandleDataAvailable,
                object: input,
                queue: .main
            ) { (notification) in
                    let data = input.availableData
                    print("Observed input pipe stream data: \(data)")
                    switch data.isEmpty {
                    case true:
                        inputPipe.fileHandleForWriting.closeFile()
                    case false:
                        inputPipe.fileHandleForWriting.write(data)
                        input.waitForDataInBackgroundAndNotify()
                    }
        }
        

        process.waitUntilExit()
        print("process.terminationStatus: \(process.terminationStatus)")
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
