import SwiftShell

public struct LLDBBridgeTestValue {
    static let swiftCodePath = "/Users/hiroseyuudai/develop/oss/Kuri"
}

public struct LLDBBridge {
    public init() {
        
    }
    
    public func exec() {
        main.currentdirectory = LLDBBridgeTestValue.swiftCodePath
        let command = main.runAsync(bash: "swift build")
        command.stdout.onStringOutput { (text) in
            print(text)
        }
        command.stderror.onStringOutput { (text) in
            print(text)
        }
        do {
            try command.finish()
        } catch {
            print("Can not finish process of `swift build`")
        }
        print(main.run(bash: "rm -rf .build").stdout)
    }
}
