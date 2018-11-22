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
    
    public func exec() {
        main.currentdirectory = SwiftBulidTestValue.swiftCodePath
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
