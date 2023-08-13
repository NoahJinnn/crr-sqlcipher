//
//  testsqlcipherApp.swift
//  testsqlcipher
//
//  Created by Tran Nguyen on 13/08/2023.
//

import SwiftUI

@main
struct testsqlcipherApp: App {
    var body: some Scene {
        WindowGroup {
            let result =  Database()
            ContentView()
        }
    }
}
