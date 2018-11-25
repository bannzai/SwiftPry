//
//  SwiftBuild.swift
//  SwiftPry
//
//  Created by Yudai.Hirose on 2018/11/22.
//

import SwiftShell

public struct SwiftBulidTestValue {
    static let swiftCodePath = "/Users/hiroseyuudai/develop/oss/Kuri"
}

public struct SwiftBulid {
    public init() {
        
    }
    
    public func exec() -> String {
        main.currentdirectory = SwiftBulidTestValue.swiftCodePath
        let output = main.run(bash: "swift build")
        return output
            .stdout
            .components(separatedBy: "\n")
            .filter {
                $0.hasPrefix("Linking ./")
            }
            .map { text in
                let head = text.index(text.startIndex, offsetBy: "Linking ./".count)
                let subString = text[head...]
                return main.currentdirectory + String(subString)
        }
        .last!
    }
    
    public func exec(builtdBinaryPath: @escaping (String) -> Void) {
        main.currentdirectory = SwiftBulidTestValue.swiftCodePath
        let command = main.runAsync(bash: "swift build")
        command.stdout.onStringOutput { (text) in
            print(text)
            if text.hasPrefix("Linking ./") {
                let head = text.index(text.startIndex, offsetBy: "Linking ./".count)
                let subString = text[head...]
                builtdBinaryPath(main.currentdirectory + String(subString))
            }
        }
        command.stderror.onStringOutput { (text) in
            print(text)
        }
        do {
            try command.finish()
            main.run(bash: "rm -rf .build") // TODO: Remove
        } catch {
            print("Can not finish process of `swift build`")
        }
    }
}
