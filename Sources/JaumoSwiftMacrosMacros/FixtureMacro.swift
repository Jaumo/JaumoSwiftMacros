//
//  FixtureMacro.swift
//
//
//  Created by Manuel Garcia-Estañ Martinez on 8/7/23.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

private struct Field {
    let name: String
    let type: String
    let defaultValue: String
}

public struct FixtureMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) -> [SwiftSyntax.DeclSyntax] {
                
        let fixtures = [
            "Int": "0",
            "String": #""""#,
            "Bool": "false",
            "Float": "0",
            "Double": "0",
            "CGFloat": "0",
            "Date": "Date()",
        ]
        
        guard let declaration = declaration.as(StructDeclSyntax.self) else {
            return []
        }
        
        let fields = declaration.memberBlock.members.compactMap {
            $0.decl.as(VariableDeclSyntax.self)?.bindings.first?.as(PatternBindingSyntax.self)
        }.compactMap { binding -> Field? in
            guard let name = binding.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else {
                return nil
            }
            
            guard let type = binding.typeAnnotation?.type.description else {
                return nil
            }
            
            let defaultValue: String
            
            if let _ = binding.typeAnnotation?.type.as(SimpleTypeIdentifierSyntax.self)?.name.text {
                defaultValue = fixtures[type] ?? ".fixture()"
            } else if let _ = binding.typeAnnotation?.type.as(OptionalTypeSyntax.self) {
                defaultValue = "nil"
            } else if let _ = binding.typeAnnotation?.type.as(ArrayTypeSyntax.self) {
                defaultValue = "[]"
            } else if let _ = binding.typeAnnotation?.type.as(DictionaryTypeSyntax.self) {
                defaultValue = "[:]"
            } else {
                return nil
            }
            
            return Field(name: name, type: type, defaultValue: defaultValue)
        }
        
        return [DeclSyntax(stringLiteral: fixtureMethod(from: fields))]
    }
}

private func fixtureMethod(from fields: [Field]) -> String {
    var string = "static func fixture(\n"
    fields.indices.forEach { indice in
        let field = fields[indice]
        string += "\(field.name): \(field.type) = \(field.defaultValue)"
        if fields.indices.last != indice {
            string += ","
        }
        string += "\n"
    }
    string += ") -> Self {\n"
    
    string += "Self.init(\n"

    fields.indices.forEach { indice in
        let field = fields[indice]
        string += "\(field.name): \(field.name)"
        if fields.indices.last != indice {
            string += ","
        }
        string += "\n"
    }
    
    string += ")\n"
    string += "}"
    return string
}

