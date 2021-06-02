//
//  CoreDataModelParser.swift
//  CoreDataToMD
//
//  Created by Peter Hauke on 02.06.21.
//

import Foundation


class CoreDataModelParser {
    
    var contentString = ""
    
    public init(contentString: String) {
        self.contentString = contentString
    }
    
    
}

extension CoreDataModelParser {
    
    func read(from data: Data) {
        contentString = String(bytes: data, encoding: .utf8)!
    }
    
    func data() -> Data? {
        return contentString.data(using: .utf8)
    }
    
}
