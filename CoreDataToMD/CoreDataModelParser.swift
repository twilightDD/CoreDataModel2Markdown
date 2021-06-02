//
//  CoreDataModelParser.swift
//  CoreDataToMD
//
//  Created by Peter Hauke on 02.06.21.
//

import Foundation

class Entity {
    var name: String
    var representedClassName: String
    var syncable: String
    
    var attributes: [Attribute] = []
    var relationships: [Relationship] = []
    
    init(with attributeDict: [String : String]) {
        name = attributeDict["name"] ?? ""
        representedClassName = attributeDict["representedClassName"] ?? ""
        syncable = attributeDict["syncable"]  ?? ""
    }
    
    func appendAttribute(with attributeDict: [String : String]) {
        let attribute = Attribute(with: attributeDict)
        attributes.append(attribute)
    }
    
    func appendRelationship(with attributeDict: [String : String]) {
        let relationship = Relationship.init(with: attributeDict)
        relationships.append(relationship)
    }
    
}

struct Attribute {
    var name: String
    var attributeType: String
    var defaultValueString: String
    var customClassName: String
    var optional: String
    
    init(with attributeDict: [String : String]) {
        name = attributeDict["name"] ?? ""
        attributeType = attributeDict["attributeType"] ?? ""
        defaultValueString = attributeDict["defaultValueString"] ?? ""
        customClassName = attributeDict["customClassName"] ?? ""
        optional = attributeDict["optional"] ?? ""
    }
    
}

struct Relationship {
    var name: String = ""

    var destinationEntity: String = ""
    var inverseEntity: String = ""
    var inverseName: String = ""
    var deletionRule: String = ""
    var optional: String = ""
    var toMany: String = ""
    
    init(with attributeDict: [String : String]) {
        name = attributeDict["name"] ?? ""
        destinationEntity = attributeDict["destinationEntity"] ?? ""
        inverseEntity = attributeDict["inverseEntity"] ?? ""
        inverseName = attributeDict["inverseName"] ?? ""
        deletionRule = attributeDict["deletionRule"] ?? ""
        optional = attributeDict["optional"] ?? ""
        toMany = attributeDict["toMany"] ?? ""
    }
    
}


class CoreDataModelParser: XMLParser {
    
    var content: [Entity] = []
    
    override init(data: Data) {
        super.init(data: data)
        delegate = self
    
    }
        
    
    
    
    
}



extension CoreDataModelParser:  XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
        Swift.print("\(#function)")
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        Swift.print("\(#function)")
        
        content.forEach { entity in
            Swift.print("entity.name: \(entity.name)")
            Swift.print("entity.attributes.count: \(entity.attributes.count)")
            Swift.print("entity.relationships.count: \(entity.relationships.count)")
            
            
            
        }
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
//        Swift.print("\(#function)")
//        Swift.print("elementName: \(elementName)\n\(attributeDict)")
//        Swift.print("------")
        
        if elementName == "entity" {
            let entity = Entity(with: attributeDict)
            content.append(entity)
        }
        
        else if elementName == "attribute" {
            content.last?.appendAttribute(with: attributeDict)
        }
        else if elementName == "relationship" {
            content.last?.appendRelationship(with: attributeDict)
        }
        
    }
    
}
