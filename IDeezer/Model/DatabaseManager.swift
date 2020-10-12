//
//  DatabaseManager.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//
import Foundation
import UIKit
import SQLite3

class DatabaseManager: NSObject {
    var db: OpaquePointer?
    
    func initDB(){
        let fileURL = try! FileManager.default.url(for: .documentDirectory , in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("database.sqlite")
        
        //Open Database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK{
            print("ERROR - Error while open Database")
        } else {
            print("SUCCESS - Open Database done")
        }
        
    }
    
    func createTableUser(){
        //Create Table
        let  createTableQuery = "CREATE TABLE IF NOT EXISTS User (id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while create Table - \(errMsg)")
        } else {
            print("SUCCESS - Create Table done")
        }
    }
    
    func createTableTrack(){
        let  createTableQuery = "CREATE TABLE IF NOT EXISTS Track (id INTEGER PRIMARY KEY AUTOINCREMENT, imageName VARCHAR, trackTitle TEXT, artistName TEXT, albumCover TEXT, isFavorite TEXT, urlMusic VARCHAR)"
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while create Table - \(errMsg)")
        } else {
            print("SUCCESS - Create Table done")
        }
    }
    
    func saveDBValueTrack(inputData: Track) {
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        var statement: OpaquePointer?
        let imageName = inputData.imageName
        let trackTitle = inputData.trackTitle
        let artistName = inputData.artistName
        let albumCover = inputData.albumCover
        let isFavorite = inputData.isFavorite
        let urlMusic = inputData.urlMusic
        
        let insertQuery = "INSERT INTO Track (imageName, trackTitle, artistName, albumCover, isFavorite, urlMusic) VALUES (?, ?, ?, ?, ?, ?)"
        
        if sqlite3_prepare(db, insertQuery, -1, &statement, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while Prepare Insert - \(errMsg)")
            return
        } else {
            print("SUCCESS - Prepare Insert done")
        }
        
        if sqlite3_bind_text(statement, 1, imageName, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Binding Statement 1 - \(errMsg)")
            return
        } else {
            print("SUCCESS - Binding Statement 1 done")
        }
        
        if sqlite3_bind_text(statement, 2, trackTitle, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Binding Statement 2 - \(errMsg)")
            return
        } else {
            print("SUCCESS - Binding Statement 2 done")
        }
        
        if sqlite3_bind_text(statement, 3, artistName, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Binding Statement 3 - \(errMsg)")
            return
        } else {
            print("SUCCESS - Binding Statement 3 done")
        }
        
        if sqlite3_bind_text(statement, 4, albumCover, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Binding Statement 4 - \(errMsg)")
            return
        } else {
            print("SUCCESS - Binding Statement 4 done")
        }
        
        if sqlite3_bind_text(statement, 5, isFavorite, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Binding Statement 5 - \(errMsg)")
            return
        } else {
            print("SUCCESS - Binding Statement 5 done")
        }
        
        if sqlite3_bind_text(statement, 6, urlMusic, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Binding Statement 6 - \(errMsg)")
            return
        } else {
            print("SUCCESS - Binding Statement 6 done")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Insert Statement - \(errMsg)")
            return
        } else {
            print("SUCCESS - Insert Statement done")
        }
        
    }
    
    func deleteSavedDataTrack(inputData: Track){
        let deleteQuery = "DELETE FROM Track Where trackTitle = \'\(inputData.trackTitle)\' "
        if sqlite3_exec(db, deleteQuery, nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while delete data - \(errMsg)")
        } else {
            print("SUCCESS - Delete Table done")
        }
    }
    
    func readDBValueTrack() -> [Track] {
        var trackList = [Track]()
        let selectQuery = "SELECT * FROM Track"
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, selectQuery, -1, &statement, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while Prepare Select - \(errMsg)")
        } else {
            print("SUCCESS - Prepare Select done")
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
//            let id = Int(sqlite3_column_int(statement, 0))
            let imageName = String(cString: sqlite3_column_text(statement, 1))
            let trackTitle = String(cString: sqlite3_column_text(statement, 2))
            let artistName = String(cString: sqlite3_column_text(statement, 3))
            let albumCover = String(cString: sqlite3_column_text(statement, 4))
            let isFavorite = String(cString: sqlite3_column_text(statement, 5))
            let urlMusic = String(cString: sqlite3_column_text(statement, 6))
            trackList.append(Track(imageName: imageName, trackTitle: trackTitle, artistName: artistName, albumCover: albumCover, isFavorite: isFavorite, urlMusic: urlMusic))
        }
        
        return trackList
    }
    
    func deleteSavedDataUser(){
        let deleteQuery = "DROP TABLE User"
        if sqlite3_exec(db, deleteQuery, nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while delete Table - \(errMsg)")
        } else {
            print("SUCCESS - Delete Table done")
        }
    }
    
    func deleteSavedData(){
        let deleteQuery = "DROP TABLE Track"
        if sqlite3_exec(db, deleteQuery, nil, nil, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while delete Table - \(errMsg)")
        } else {
            print("SUCCESS - Delete Table done")
        }
    }
    
    func saveDBValueUser(inputData: User) -> Bool {
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        var statement: OpaquePointer?
        let email = inputData.email
        let password = inputData.password
        
        let insertQuery = "INSERT INTO User (email, password) VALUES (?, ?)"
        
        if sqlite3_prepare(db, insertQuery, -1, &statement, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while Prepare Insert - \(errMsg)")
            return false
        } else {
            print("SUCCESS - Prepare Insert done")
        }
        
        if sqlite3_bind_text(statement, 1, email, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Binding Statement 1 - \(errMsg)")
            return false
        } else {
            print("SUCCESS - Binding Statement 1 done")
        }
        
        if sqlite3_bind_text(statement, 2, password, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Binding Statement 2 - \(errMsg)")
            return false
        } else {
            print("SUCCESS - Binding Statement 2 done")
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error Insert Statement - \(errMsg)")
            return false
        } else {
            print("SUCCESS - Insert Statement done")
        }
        
        return true
    }
    
    func readDBValueRegister(inputData: User) -> [User] {
        var userList = [User]()
        let selectQuery = "SELECT * FROM User Where email = \'\(inputData.email)\' "
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, selectQuery, -1, &statement, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while Prepare Select - \(errMsg)")
        } else {
            print("SUCCESS - Prepare Select done")
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(statement, 0))
            let email = String(cString: sqlite3_column_text(statement, 1))
            let password = String(cString: sqlite3_column_text(statement, 2))
            
            userList.append(User(id: id, email: email, password: password))
        }
        
        return userList
    }
    
    func readDBValueLogin(inputData: User) -> [User] {
        var userList = [User]()
        let selectQuery = "SELECT * FROM User Where email = \'\(inputData.email)\' and password = \'\(inputData.password)\'"
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, selectQuery, -1, &statement, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while Prepare Select - \(errMsg)")
        } else {
            print("SUCCESS - Prepare Select done")
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(statement, 0))
            let email = String(cString: sqlite3_column_text(statement, 1))
            let password = String(cString: sqlite3_column_text(statement, 2))
            
            userList.append(User(id: id, email: email, password: password))
        }
        
        return userList
    }
    
    func readDBValueUser() -> [User] {
        var userList = [User]()
        let selectQuery = "SELECT * FROM User"
        var statement: OpaquePointer?
        
        if sqlite3_prepare(db, selectQuery, -1, &statement, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("ERROR - Error while Prepare Select - \(errMsg)")
        } else {
            print("SUCCESS - Prepare Select done")
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            let id = Int(sqlite3_column_int(statement, 0))
            let email = String(cString: sqlite3_column_text(statement, 1))
            let password = String(cString: sqlite3_column_text(statement, 2))
            userList.append(User(id: id, email: email, password: password))
        }
        
        return userList
    }
}
