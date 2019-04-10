//
//  FileParser.swift
//  FreqList
//
//  Created by ricsi on 2019. 03. 04..
//  Copyright © 2019. rh12dev. All rights reserved.
//

import Foundation

// --------------------------------------------------------------------------------------------
// MARK:-    PROTOCOL
// --------------------------------------------------------------------------------------------

protocol FileParsing {
    static func parseFile(_ url: URL, forProject project: Project) throws
}


// --------------------------------------------------------------------------------------------
// MARK:-    LIST of PARSERS
// --------------------------------------------------------------------------------------------

enum FileTypes {
    private static let extDict: [String:FileParsing.Type] = [
        "flp" : FLPParser.self,
        "csv" : WWBReportParser.self,
        "shw" : WWBShowParser.self,
        "inv" : WWBShowParser.self,
    ]
    
    static var extensions: [String] {
        return Array(extDict.keys)
    }
    
    static func parserForExtension(_ ext: String) -> FileParsing.Type? {
        return extDict[ext]
    }
    static func parserForURL(_ url: URL) -> FileParsing.Type? {
        return extDict[url.pathExtension]
    }
}


// --------------------------------------------------------------------------------------------
// MARK:-    ERROR
// --------------------------------------------------------------------------------------------

enum FileParserError: Error {
    case fileOpenError
    case processError(String)
    case customError(String)
    
    var message: String {
        switch self {
        case .fileOpenError: return "Could not open file."
        case .processError(let type): return "Could not process \(type) file."
        case .customError(let m): return m
        }
    }
}
