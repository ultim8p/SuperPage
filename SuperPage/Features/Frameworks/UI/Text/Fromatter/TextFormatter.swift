//
//  TextFormatter.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/12/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

protocol TextFormatter {
    
    var markupRegex: String? { get }
    
    var regexPattern: String? { get }
    
    var attribtues: [NSAttributedString.Key: Any]? { get }
    
}

enum TextFormat: TextFormatter {
    
    // General
    
    case defaultText
    
    case placeholder
    
    // Code
    
    case defaultCode
    
    case codeKeywords
    
    case codeTypes
    
    case codeStrings
    
    case codeComments
    
    case codeVariableNames
    
    var markupRegex: String? {
        switch self {
        case .defaultCode, .codeKeywords, .codeTypes, .codeStrings, .codeComments, .codeVariableNames:
            return "```(.*?)```"
        default:
            return nil
        }
    }
    
    var regexPattern: String? {
        switch self {
        case .defaultText:
            return nil
        case .defaultCode:
            return nil
        case .codeKeywords:
            return "\\b(" + codeKeywords.joined(separator: "|") + ")\\b"
        case .codeTypes:
            return "\\b([A-Z][a-zA-Z0-9_]+)\\b|^(?=@)\\S+|@\\S+"
        case .codeStrings:
            return "\"(.*?)\"|“(.*?)”|'(.*?)'|‘(.*?)’"
        case .codeComments:
            let pattern1 = "(?<=\\s|^)//[^\\r\\n]*"
            return "\(pattern1)"
        case .codeVariableNames:
            let prefixCharacters = ".$&*#!^"
            return "[\(prefixCharacters)](?<=[\(prefixCharacters)])[a-zA-Z0-9\(prefixCharacters)]+.*?(?=[^a-zA-Z0-9\(prefixCharacters)]|$)"
        case .placeholder:
            return nil
        }
    }
    
    var attribtues: [NSAttributedString.Key : Any]? {
        switch self {
        case .defaultText:
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: PlatformFont.systemFont(ofSize: 14.0),
            ]
        case .placeholder:
            return [
                .foregroundColor: SuperColor.textPlaceholder,
                .font: PlatformFont.systemFont(ofSize: 14.0),
            ]
        case .defaultCode:
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: PlatformFont(name: "Menlo-Regular", size: 13)!,
            ]
        case .codeKeywords:
            return [
                .foregroundColor: PlatformColor(red: 255.0/255.0, green: 83.0/255.0, blue: 160.0/255.0, alpha: 1.0),
                .font: PlatformFont(name: "Menlo-Bold", size: 13)!,
            ]
        case .codeTypes:
            return [
                .foregroundColor: PlatformColor(red: 197.0/255.0, green: 124.0/255.0, blue: 255.0/255.0, alpha: 1.0),
                .font: PlatformFont(name: "Menlo-Regular", size: 13)!,
            ]
        case .codeStrings:
            return [
                .foregroundColor: PlatformColor(red: 250.0/255.0, green: 99.0/255.0, blue: 49.0/255.0, alpha: 1.0),
                .font: PlatformFont(name: "Menlo-Regular", size: 13)!,
            ]
        case .codeComments:
            return [
                .foregroundColor: PlatformColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0),
                .font: PlatformFont(name: "Menlo-Italic", size: 13)!,
            ]
        case .codeVariableNames:
            return [
                .foregroundColor: PlatformColor(red: 29.0/255.0, green: 190.0/255.0, blue: 249.0/255.0, alpha: 1.0),
                .font: PlatformFont(name: "Menlo-Regular", size: 13)!,
            ]
        }
    }
}

extension TextFormat {
    
    var codeKeywords: [String] {
        return [
            "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout", "internal", "let", "open", "operator", "private", "protocol", "public", "rethrows", "return", "static", "struct", "subscript", "typealias", "var", "break", "case", "continue", "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "switch", "where", "while", "as", "Any", "catch", "false", "is", "nil", "super", "self", "Self", "throw", "throws", "true", "try", "_", "associativity", "convenience", "dynamic", "didSet", "final", "get", "infix", "indirect", "lazy", "left", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "right", "set", "Type", "unowned", "weak", "willSet", "some", "abstract", "boolean", "byte", "catch", "char", "extends", "float", "implements", "instanceof", "int", "interface", "long", "module", "native", "new", "package", "protected", "short", "strictfp", "synchronized", "this", "transient", "void", "volatile", "const", "debugger", "delete", "export", "instanceof", "null", "asm", "auto", "bool", "double", "dynamic_cast", "explicit", "extern", "friend", "goto", "inline", "mutable", "namespace", "reinterpret_cast", "signed", "sizeof", "static_cast", "template", "typeid", "typename", "union", "unsigned", "using", "virtual", "wchar_t", "associatedtype", "indirect", "repeat", "required", "where", "alias", "begin", "defined?", "elsif", "end", "ensure", "next", "not", "or", "redo", "rescue", "retry", "undef", "unless", "until", "when", "yield", "array", "empty", "enddeclare", "endfor", "endforeach", "endif", "endswitch", "endwhile", "eval", "exit", "extends", "final", "finally", "float", "foreach", "function", "global", "if", "implements", "include", "instanceof", "interface", "isset", "list", "namespace", "new", "null", "number_format", "object", "print", "private", "protected", "public", "require", "static", "string", "switch", "throw", "trait", "true", "try", "unset", "use", "var", "while", "xor", "ALTER", "AND", "AS", "ASC", "BETWEEN", "BY", "COUNT", "CREATE", "DELETE", "DESC", "DISTINCT", "DROP", "EXISTS", "FROM", "GROUP", "HAVING", "IN", "INDEX", "INNER", "INSERT", "INTO", "IS", "JOIN", "LIKE", "LIMIT", "NOT", "NULL", "ON", "OR", "ORDER", "OUTER", "SELECT", "SET", "SUM", "TABLE", "UNION", "UNIQUE", "UPDATE", "VALUES", "WHERE", "as?", "fun", "!in", "!is", "object", "@dynamic", "@optional", "@required", "bool", "crate", "debugger", "declare", "export", "implicit", "number", "readonly", "readwrite", "unsafe_unretained", "@autoreleasepool", "@catch", "@class", "@compatibility_alias", "@defs", "@encode", "@end", "@finally", "@implementation", "@interface", "@keypath", "@public", "@package", "@protected", "@private", "@property", "@protocol", "@selector", "@synchronized", "@synthesize", "@throw", "@try", "BOOL", "Class", "IMP", "NO", "Nil", "NULL", "SEL", "YES", "assign", "atomic", "copy", "retain", "strong", "unsafe_unretained", "weak", "@dynamic", "@optional", "@required", "abstract", "checked", "decimal", "do", "event", "fixed", "implicit", "lock", "readonly", "ref", "sbyte", "sealed", "stackalloc", "unchecked", "unsafe", "ushort", "using", "yield", "AAA", "AAD", "AAM", "AAS", "ADC", "ADD", "AND", "CALL", "CBW", "CLC", "CLD", "CLI", "CMC", "CMP", "CWD", "DAA", "DAS", "DEC", "DIV", "ESC", "HLT", "IDIV", "IMUL", "IN", "INC", "INT", "INTO", "IRET", "JA", "JC", "JCXZ", "JE", "JG", "JMP", "JNA", "JNC", "JNE", "JNG", "JNO", "JNP", "JNS", "JNZ", "JO", "JP", "JPE", "JPO", "JS", "JZ", "LAHF", "LDS", "LEA", "LES", "LOCK", "LODSB", "LODSW", "LOOP", "LOOPE", "LOOPNE", "LOOPNZ", "LOOPZ", "MOV", "MOVSB", "MOVSW", "MUL", "NEG", "NOP", "NOT", "OR", "OUT", "POP", "POPF", "PUSH", "PUSHF", "RCL", "RCR", "RET", "RETF", "REPNZ", "REPZ", "RETN", "SAHF", "SBB", "SCASB", "SCASW", "SHL", "SHR", "STC", "STD", "STI", "STOSB", "STOSW", "SUB", "TEST", "WAIT", "XCHG", "XLAT", "XOR", "auto", "register", "restrict", "typedef", "char", "double", "float", "int", "long", "short", "signed", "unsigned", "void", "volatile", "absolute", "and", "array", "asm", "begin", "case", "const", "constructor", "continue", "decrement", "div", "dword", "else", "end", "except", "exit", "export", "false", "file", "finalization", "finally", "for", "function", "goto", "if", "implementation", "in", "increment", "inherited", "initialization", "inline", "interface", "is", "label", "library", "mod", "nil", "not", "of", "on", "operator", "packed", "procedure", "program", "property", "real", "record", "repeat", "set", "shl", "shr", "string", "then", "threadvar", "to", "true", "try", "type", "unit", "until", "uses", "val", "while", "with", "word", "xor"
        ]
    }
}
