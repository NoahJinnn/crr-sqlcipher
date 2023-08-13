//
//  Database.swift
//  testsqlcipher
//
//  Created by Tran Nguyen on 13/08/2023.
//

import Foundation

class Database {
    var rc: Int32
    var db: OpaquePointer? = nil
    var stmt: OpaquePointer? = nil
    let password: String = "correct horse battery staple"
    init() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0]
        let databaseURL = documentDirectory.appendingPathComponent("other.db")
        NSLog("database URI: \(databaseURL.absoluteString)")
        rc = sqlite3_open(databaseURL.absoluteString, &db)
            if (rc != SQLITE_OK) {
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog("Error opening database: \(errmsg)")
                return
            }
           rc = sqlite3_key(db, password, Int32(password.utf8CString.count))
           if (rc != SQLITE_OK) {
               let errmsg = String(cString: sqlite3_errmsg(db))
               NSLog("Error setting key: \(errmsg)")
           }
            rc = sqlite3_prepare(db, "PRAGMA cipher_version;", -1, &stmt, nil)
            if (rc != SQLITE_OK) {
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog("Error preparing SQL: \(errmsg)")
            }
            rc = sqlite3_step(stmt)
            if (rc == SQLITE_ROW) {
                NSLog("cipher_version: %s", sqlite3_column_text(stmt, 0))
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog("Error retrieiving cipher_version: \(errmsg)")
            }
            sqlite3_finalize(stmt)
            // Load dynamic extension
            rc = sqlite3_key(db, password, Int32(password.utf8CString.count))
            if (rc != SQLITE_OK) {
                let errmsg = String(cString: sqlite3_errmsg(db))
                NSLog("Error setting key: \(errmsg)")
            }
            rc = sqlite3_load_extension(db, "/Users/trannguyen/Workspaces/ref/testsqlcipher/crsqlite.framework/crsqlite", "sqlite3_crsqlite_init", nil)
            NSLog(rc.description)
            if rc != SQLITE_OK {
                 let errmsg = String(cString: sqlite3_errmsg(db))
                    NSLog("Error loading extension: \(errmsg)")
            }
        
            // Create first table if it doesn't exist
             rc = sqlite3_prepare(db, "CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, name TEXT);", -1, &stmt, nil)
             if (rc != SQLITE_OK) {
                 let errmsg = String(cString: sqlite3_errmsg(db))
                 NSLog("Error preparing SQL: \(errmsg)")
             }
             rc = sqlite3_step(stmt)
             if (rc != SQLITE_DONE) {
                 let errmsg = String(cString: sqlite3_errmsg(db))
                 NSLog("Error creating table: \(errmsg)")
             }

            // // Insert a row
            // rc = sqlite3_prepare(db, "INSERT INTO test (name) VALUES (?);", -1, &stmt, nil)
            // if (rc != SQLITE_OK) {
            //     let errmsg = String(cString: sqlite3_errmsg(db))
            //     NSLog("Error preparing SQL: \(errmsg)")
            // }
            // rc = sqlite3_bind_text(stmt, 1, "Hello, World!", -1, nil)
            // if (rc != SQLITE_OK) {
            //     let errmsg = String(cString: sqlite3_errmsg(db))
            //     NSLog("Error binding SQL: \(errmsg)")
            // }
            // rc = sqlite3_step(stmt)
            // if (rc != SQLITE_DONE) {
            //     let errmsg = String(cString: sqlite3_errmsg(db))
            //     NSLog("Error inserting row: \(errmsg)")
            // }

            // // Query the table
            // rc = sqlite3_prepare(db, "SELECT * FROM test;", -1, &stmt, nil)
            // if (rc != SQLITE_OK) {
            //     let errmsg = String(cString: sqlite3_errmsg(db))
            //     NSLog("Error preparing SQL: \(errmsg)")
            // }

            // while (sqlite3_step(stmt) == SQLITE_ROW) {
            //     let id = sqlite3_column_int(stmt, 0)
            //     let name = String(cString: sqlite3_column_text(stmt, 1))
            //     NSLog("id: \(id), name: \(name)")
            // }

            sqlite3_finalize(stmt)

            sqlite3_close(db)
    }

    
    
}
