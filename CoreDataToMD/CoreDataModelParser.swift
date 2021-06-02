//
//  CoreDataModelParser.swift
//  CoreDataToMD
//
//  Created by Peter Hauke on 02.06.21.
//

import Foundation

//MARK: - Internal Helper Classes and Structs

internal class Entity {
    
    //MARK: Properties
    var name: String
    var representedClassName: String
    var syncable: String
    
    var attributes: [Attribute] = []
    var relationships: [Relationship] = []
    
    
    //MARK: Init
    init(with attributeDict: [String : String]) {
        name = attributeDict["name"] ?? ""
        representedClassName = attributeDict["representedClassName"] ?? ""
        syncable = attributeDict["syncable"]  ?? ""
    }
    
    
    //MARK: Public Methods
    func appendAttribute(with attributeDict: [String : String]) {
        let attribute = Attribute(with: attributeDict)
        attributes.append(attribute)
    }
    
    
    func appendRelationship(with attributeDict: [String : String]) {
        let relationship = Relationship.init(with: attributeDict)
        relationships.append(relationship)
    }
    
}


internal struct Attribute {
    
    var attributeType: String
    var customClassName: String
    var defaultValueString: String
    var name: String
    var optional: String
    
    
    init(with attributeDict: [String : String]) {
        attributeType = attributeDict["attributeType"] ?? ""
        customClassName = attributeDict["customClassName"] ?? ""
        defaultValueString = attributeDict["defaultValueString"] ?? ""
        name = attributeDict["name"] ?? ""
        optional = attributeDict["optional"] ?? ""
        
    }
    
}


internal struct Relationship {
    
    var deletionRule: String = ""
    var destinationEntity: String = ""
    var inverseEntity: String = ""
    var inverseName: String = ""
    var name: String = ""
    var optional: String = ""
    var toMany: String = ""
    
    
    init(with attributeDict: [String : String]) {
        deletionRule = attributeDict["deletionRule"] ?? ""
        destinationEntity = attributeDict["destinationEntity"] ?? ""
        inverseEntity = attributeDict["inverseEntity"] ?? ""
        inverseName = attributeDict["inverseName"] ?? ""
        name = attributeDict["name"] ?? ""
        optional = attributeDict["optional"] ?? ""
        toMany = attributeDict["toMany"] ?? ""
    }
    
}


//MARK: -
//MARK: - CoreDataModelParser
class CoreDataModelParser: XMLParser {
    
    var content: [Entity] = []
    var markDownLines: [String] = []
    
    override init(data: Data) {
        super.init(data: data)
        delegate = self
    }
    
}


//MARK: - Extension - XMLParserDelegate
extension CoreDataModelParser:  XMLParserDelegate {
    
    func parserDidStartDocument(_ parser: XMLParser) {
    }
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        createMD()
    }
    
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        
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


//MARK: - Extension - Create Markdown
extension CoreDataModelParser {
    
    private func createMD() {
        content.forEach { entity in
            
            markDownLines.append("---")
            markDownLines.append("---")
            markDownLines.append("")
            markDownLines.append("")
            markDownLines.append(contentsOf: markDownLines(entity: entity))
            markDownLines.append("")
            markDownLines.append("")
            markDownLines.append("")
            markDownLines.append("### Attributes")
            markDownLines.append("")
            markDownLines.append(contentsOf: markDownLines(attributesOf: entity))
            markDownLines.append("")
            markDownLines.append("")
            markDownLines.append("")
            markDownLines.append("### Relationships")
            markDownLines.append("")
            markDownLines.append(contentsOf: markDownLines(relationshipsOf: entity))
            markDownLines.append("")
            markDownLines.append("")
            markDownLines.append("")
        }
    }
    
    
    private func markDownLines(entity: Entity)
    -> [String] {
        var markDownLines: [String] = []
        
        markDownLines.append("## \(entity.name)")
        if entity.representedClassName != entity.name {
            markDownLines.append("")
            markDownLines.append(" ClassName: \(entity.representedClassName)")
            markDownLines.append("")
        }
        
        markDownLines.append("")
        
        return markDownLines
    }
    
    
    private func markDownLines(attributesOf entity: Entity)
    -> [String] {
        var markDownLines: [String] = []
        
        entity.attributes.forEach { attribute in
            markDownLines.append("#### \(attribute.name)")
            markDownLines.append("")
            markDownLines.append(" * Type: `\(attribute.attributeType)`")
            if !attribute.defaultValueString.isEmpty {
                markDownLines.append(" * Default: `\(attribute.defaultValueString)`")
            }
            
            let optionalString = attribute.optional == "YES" ? "optional" : "required"
            markDownLines.append(" * \(optionalString)")
            
            if !attribute.customClassName.isEmpty {
                markDownLines.append(" * CustomClassName: `\(attribute.customClassName)`")
            }
            
            markDownLines.append("")
        }
        
//        markDownLines.append("")
        
        return markDownLines
    }
    
    
    private func markDownLines(relationshipsOf entity: Entity)
    -> [String] {
        var markDownLines: [String] = []
        
        
        entity.relationships.forEach { relationship in
            markDownLines.append("#### \(relationship.name)")
            markDownLines.append("")
            markDownLines.append(" * Target: `\(relationship.destinationEntity).\(relationship.inverseName)`")
            
            let toManyString = relationship.toMany == "YES" ? "to-many" : "to-one"
            markDownLines.append(" * \(toManyString)")
            
            let optionalString = relationship.optional == "YES" ? "optional" : "required"
            markDownLines.append(" * \(optionalString)")
            
            markDownLines.append(" * deletionRule: `\(relationship.deletionRule)`")
            
            markDownLines.append("")
            markDownLines.append("")
        }
        
//        markDownLines.append("")
        
        return markDownLines
    }
    
}
