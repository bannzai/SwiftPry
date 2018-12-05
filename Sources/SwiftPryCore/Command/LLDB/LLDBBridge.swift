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
        let outPipe = main.stdout.filehandle
        let errorPipe = main.stderror.filehandle

        let process = Process()

        process.launchPath = "/usr/bin/lldb"
        process.arguments = [binaryPath]
        process.standardInput = inputPipe
        process.standardOutput = outPipe
        process.standardError = main.stderror.filehandle
        process.launch()
        
        input.waitForDataInBackgroundAndNotify()
        outPipe.waitForDataInBackgroundAndNotify()
        errorPipe.waitForDataInBackgroundAndNotify()
        
        NotificationCenter
            .default
            .addObserver(
                forName: NSNotification.Name.NSFileHandleDataAvailable,
                object: input,
                queue: .main
            ) { (notification) in
                    let data = input.availableData
                    print("Observed input stream data: \(data)")
                    switch String(data: data, encoding: .utf8) {
                    case .none:
                        inputPipe.fileHandleForWriting.closeFile()
                    case .some(let value):
                        inputPipe.fileHandleForWriting.write(value)
                        input.waitForDataInBackgroundAndNotify()
                        
                        switch value {
                        case "\n":
                            print("It is line break")
                        default:
                            print("value of \(value)")
                        }
                }
        }
        
        NotificationCenter
            .default
            .addObserver(
                forName: NSNotification.Name.NSFileHandleDataAvailable,
                object: outPipe,
                queue: .main
            ) { (notification) in
                let data = outPipe.availableData
                switch String(data: data, encoding: .utf8) {
                case .none:
                    break
                case .some(let value):
                    print(value)
                    print("\n")
                    fflush(__stdoutp)
                    outPipe.waitForDataInBackgroundAndNotify()
                }
        }
        
        NotificationCenter
            .default
            .addObserver(
                forName: NSNotification.Name.NSFileHandleDataAvailable,
                object: errorPipe,
                queue: .main
            ) { (notification) in
                let data = errorPipe.availableData
                print("Error!!!!!!!!!!")
                switch String(data: data, encoding: .utf8) {
                case .none:
                    break
                case .some(let value):
                    print(value)
                    print("\n")
                    fflush(__stderrp)
                    errorPipe.waitForDataInBackgroundAndNotify()
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
