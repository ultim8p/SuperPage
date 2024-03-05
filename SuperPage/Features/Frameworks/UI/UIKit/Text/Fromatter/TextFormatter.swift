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
        
    enum Constant {
        static let defaultFontSize: CGFloat = 12.0
    }
    
    // General
    
    case defaultText(_ fontSize: CGFloat?)
    
    case placeholder(_ fontSize: CGFloat?)
    
    // Code
    
    case defaultCode(_ fontSize: CGFloat?)
    
    case codeKeywords(_ fontSize: CGFloat?)
    
    case codeTypes(_ fontSize: CGFloat?)
    
    case codeStrings(_ fontSize: CGFloat?)
    
    case codeComments(_ fontSize: CGFloat?)
    
    case codeVariableNames(_ fontSize: CGFloat?)
    
    // Interactable
    
    case action(_ fontSize: CGFloat?)
    
    // Markdown
    
    case mdH1(_ fontSize: CGFloat?)
    
    case mdH2(_ fontSize: CGFloat?)
    
    case mdH3(_ fontSize: CGFloat?)
    
    case mdH4(_ fontSize: CGFloat?)
    
    case mdBold(_ fontSize: CGFloat?)
    
    case mdBold1(_ fontSize: CGFloat?)
    
    case mdCode(_ fontSize: CGFloat?)
    
    // Delemiter ranges to match the regexPattern
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
        case .mdH1:
            return "^# [^\n]+"
        case .mdH2:
            return "^## [^\n]+"
        case .mdH3:
            return "^### [^\n]+"
        case .mdH4:
            return "^#### [^\n]+"
        case .mdBold:
            return "\\*(.*?)\\*"
        case .mdBold1:
            return "\\*\\*(.*?)\\*\\*"
        case .mdCode:
            return "`([^`]*)`"
        default:
            return nil
        }
    }
    
    var attribtues: [NSAttributedString.Key : Any]? {
        switch self {
        case let .defaultText(fontSize):
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: NOFont.systemFont(ofSize: fontSize ?? Constant.defaultFontSize),
            ]
        case let .placeholder(fontSize):
            return [
                .foregroundColor: SuperColor.textPlaceholder,
                .font: NOFont.systemFont(ofSize: fontSize ?? Constant.defaultFontSize),
            ]
        case let .defaultCode(fontSize):
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: NOFont(name: "Menlo-Regular", size: fontSize ?? Constant.defaultFontSize)!,
            ]
        case let .codeKeywords(fontSize):
            return [
                .foregroundColor: NOColor(red: 255.0/255.0, green: 83.0/255.0, blue: 160.0/255.0, alpha: 1.0),
                .font: NOFont(name: "Menlo-Bold", size: fontSize ?? Constant.defaultFontSize)!,
            ]
        case let .codeTypes(fontSize):
            return [
                .foregroundColor: NOColor(red: 197.0/255.0, green: 124.0/255.0, blue: 255.0/255.0, alpha: 1.0),
                .font: NOFont(name: "Menlo-Regular", size: fontSize ?? Constant.defaultFontSize)!,
            ]
        case let .codeStrings(fontSize):
            return [
                .foregroundColor: NOColor(red: 250.0/255.0, green: 99.0/255.0, blue: 49.0/255.0, alpha: 1.0),
                .font: NOFont(name: "Menlo-Regular", size: fontSize ?? Constant.defaultFontSize)!,
            ]
        case let .codeComments(fontSize):
            return [
                .foregroundColor: NOColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0),
                .font: NOFont(name: "Menlo-Italic", size: fontSize ?? Constant.defaultFontSize)!,
            ]
        case let .codeVariableNames(fontSize):
            return [
                .foregroundColor: NOColor(red: 29.0/255.0, green: 190.0/255.0, blue: 249.0/255.0, alpha: 1.0),
                .font: NOFont(name: "Menlo-Regular", size: fontSize ?? Constant.defaultFontSize)!,
            ]
        case let .action(fontSize):
            return [
                .foregroundColor: SuperColor.icon,
                .font: NOFont(name: "Menlo-Bold", size: fontSize ?? Constant.defaultFontSize)!,
            ]
        case let .mdH1(fontSize):
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: NOFont.systemFont(
                    ofSize: (fontSize ?? Constant.defaultFontSize) * 2.5,
                    weight: .heavy
                )
            ]
        case let .mdH2(fontSize):
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: NOFont.systemFont(
                    ofSize: (fontSize ?? Constant.defaultFontSize) * 2.1,
                    weight: .heavy
                )
            ]
        case let .mdH3(fontSize):
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: NOFont.systemFont(
                    ofSize: (fontSize ?? Constant.defaultFontSize) * 1.7,
                    weight: .heavy
                )
            ]
        case let .mdH4(fontSize):
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: NOFont.systemFont(
                    ofSize: (fontSize ?? Constant.defaultFontSize) * 1.3,
                    weight: .heavy
                )
            ]
        case let .mdBold(fontSize):
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: NOFont.systemFont(
                    ofSize: (fontSize ?? Constant.defaultFontSize),
                    weight: .heavy)
            ]
        case let .mdBold1(fontSize):
            return [
                .foregroundColor: SuperColor.defaultText,
                .font: NOFont.systemFont(
                    ofSize: (fontSize ?? Constant.defaultFontSize),
                    weight: .bold)
            ]
        case let .mdCode(fontSize):
            return  [
                .foregroundColor: SuperColor.markdownCode,
                .font: NOFont.systemFont(
                    ofSize: fontSize ?? Constant.defaultFontSize,
                    weight: .semibold)
            ]
        }
    }
}

extension TextFormat {
    
    var codeKeywords: [String] {
        
        // swift
        return [
            "if", "else", "switch", "case", "default", "break", "continue", "for", "while", "return", "throw", "catch", "try", "var", "const", "bool", "int", "float", "double", "char", "string",
            "public", "private", "protected", "static", "final", "abstract", "func", "extension", "let", "init", "class", "struct", "import", "some", "enum"
        ]

        
    }
}

//




/*
 
 
 return [
     "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout", "internal", "let", "open", "operator", "private", "protocol", "public", "rethrows", "return", "static", "struct", "subscript", "typealias", "var", "break", "case", "continue", "default", "defer", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "switch", "where", "while", "as", "Any", "catch", "false", "is", "nil", "super", "self", "Self", "throw", "throws", "true", "try", "_", "associativity", "convenience", "dynamic", "didSet", "final", "get", "infix", "indirect", "lazy", "left", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "right", "set", "Type", "unowned", "weak", "willSet", "some", "abstract", "boolean", "byte", "char", "extends", "float", "implements", "instanceof", "int", "interface", "long", "module", "native", "new", "package", "protected", "short", "strictfp", "synchronized", "this", "transient", "void", "volatile", "const", "debugger", "delete", "export", "null", "asm", "auto", "bool", "double", "dynamic_cast", "explicit", "extern", "friend", "goto", "inline", "mutable", "namespace", "reinterpret_cast", "signed", "sizeof", "static_cast", "template", "typeid", "typename", "union", "unsigned", "using", "virtual", "wchar_t", "associatedtype", "alias", "begin", "elsif", "end", "ensure", "next", "not", "or", "redo", "rescue", "retry", "undef", "unless", "until", "when", "yield", "array", "empty", "enddeclare", "endfor", "endforeach", "endif", "endswitch", "endwhile", "eval", "exit", "foreach", "function", "global", "include", "isset", "list", "number_format", "object", "print", "require", "string", "trait", "unset", "var", "xor", "ALTER", "AND", "ASC", "BETWEEN", "BY", "COUNT", "CREATE", "DESC", "DISTINCT", "DROP", "EXISTS", "FROM", "GROUP", "HAVING", "INDEX", "INNER", "INSERT", "INTO", "JOIN", "LIKE", "LIMIT", "NOT", "ON", "ORDER", "OUTER", "SELECT", "SET", "SUM", "TABLE", "UNION", "UNIQUE", "UPDATE", "VALUES", "as?", "fun", "!in", "!is", "crate", "declare", "implicit", "number", "readonly", "readwrite", "unsafe_unretained", "BOOL", "Class", "IMP", "NO", "Nil", "NULL", "SEL", "YES", "assign", "atomic", "copy", "retain", "strong", "checked", "decimal", "do", "event", "fixed", "lock", "ref", "sbyte", "sealed", "stackalloc", "unchecked", "unsafe", "ushort", "AAA", "AAD", "AAM", "AAS", "ADC", "ADD", "register", "restrict", "typedef", "absolute", "and", "constructor", "decrement", "div", "dword", "except", "file", "finalization", "implementation", "increment", "inherited", "initialization", "label", "library", "mod", "of", "packed", "procedure", "program", "property", "shl", "shr", "then", "threadvar", "to", "type", "unit", "uses", "val", "with", "word"
 ]
 
 wtih duplicates
 return [
     "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout", "internal", "let", "open", "operator", "private", "protocol", "public", "rethrows", "return", "static", "struct", "subscript", "typealias", "var", "break", "case", "continue", "default", "defer", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "switch", "where", "while", "as", "Any", "catch", "false", "is", "nil", "super", "self", "Self", "throw", "throws", "true", "try", "_", "associativity", "convenience", "dynamic", "didSet", "final", "get", "infix", "indirect", "lazy", "left", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "right", "set", "Type", "unowned", "weak", "willSet", "some", "abstract", "boolean", "byte", "catch", "char", "extends", "float", "implements", "instanceof", "int", "interface", "long", "module", "native", "new", "package", "protected", "short", "strictfp", "synchronized", "this", "transient", "void", "volatile", "const", "debugger", "delete", "export", "instanceof", "null", "asm", "auto", "bool", "double", "dynamic_cast", "explicit", "extern", "friend", "goto", "inline", "mutable", "namespace", "reinterpret_cast", "signed", "sizeof", "static_cast", "template", "typeid", "typename", "union", "unsigned", "using", "virtual", "wchar_t", "associatedtype", "indirect", "repeat", "required", "where", "alias", "begin", "elsif", "end", "ensure", "next", "not", "or", "redo", "rescue", "retry", "undef", "unless", "until", "when", "yield", "array", "empty", "enddeclare", "endfor", "endforeach", "endif", "endswitch", "endwhile", "eval", "exit", "extends", "final", "finally", "float", "foreach", "function", "global", "if", "implements", "include", "instanceof", "interface", "isset", "list", "namespace", "new", "null", "number_format", "object", "print", "private", "protected", "public", "require", "static", "string", "switch", "throw", "trait", "true", "try", "unset", "use", "var", "while", "xor", "ALTER", "AND", "AS", "ASC", "BETWEEN", "BY", "COUNT", "CREATE", "DELETE", "DESC", "DISTINCT", "DROP", "EXISTS", "FROM", "GROUP", "HAVING", "IN", "INDEX", "INNER", "INSERT", "INTO", "IS", "JOIN", "LIKE", "LIMIT", "NOT", "NULL", "ON", "OR", "ORDER", "OUTER", "SELECT", "SET", "SUM", "TABLE", "UNION", "UNIQUE", "UPDATE", "VALUES", "WHERE", "as?", "fun", "!in", "!is", "object", "bool", "crate", "debugger", "declare", "export", "implicit", "number", "readonly", "readwrite", "unsafe_unretained", "BOOL", "Class", "IMP", "NO", "Nil", "NULL", "SEL", "YES", "assign", "atomic", "copy", "retain", "strong", "unsafe_unretained", "weak", "abstract", "checked", "decimal", "do", "event", "fixed", "implicit", "lock", "readonly", "ref", "sbyte", "sealed", "stackalloc", "unchecked", "unsafe", "ushort", "using", "yield", "AAA", "AAD", "AAM", "AAS", "ADC", "ADD", "AND",
     "auto", "register", "restrict", "typedef", "char", "double", "float", "int", "long", "short", "signed", "unsigned", "void", "volatile", "absolute", "and", "array", "asm", "begin", "case", "const", "constructor", "continue", "decrement", "div", "dword", "else", "end", "except", "exit", "export", "false", "file", "finalization", "finally", "for", "function", "goto", "if", "implementation", "in", "increment", "inherited", "initialization", "inline", "interface", "is", "label", "library", "mod", "nil", "not", "of", "on", "operator", "packed", "procedure", "program", "property", "set", "shl", "shr", "string", "then", "threadvar", "to", "true", "try", "type", "unit", "until", "uses", "val", "while", "with", "word", "xor"
 ]
 
 , "real", "record", "repeat"
 
 , "defined?"
 
 "@dynamic", "@optional", "@required", "@autoreleasepool", "@catch", "@class", "@compatibility_alias", "@defs", "@encode", "@end", "@finally", "@implementation", "@interface", "@keypath", "@public", "@package", "@protected", "@private", "@property", "@protocol", "@selector", "@synchronized", "@synthesize", "@throw", "@try", "@dynamic", "@optional", "@required",
 
"CALL", "CBW", "CLC", "CLD", "CLI", "CMC", "CMP", "CWD", "DAA", "DAS", "DEC", "DIV", "ESC", "HLT", "IDIV", "IMUL", "IN", "INC", "INT", "INTO", "IRET", "JA", "JC", "JCXZ", "JE", "JG", "JMP", "JNA", "JNC", "JNE", "JNG", "JNO", "JNP", "JNS", "JNZ", "JO", "JP", "JPE", "JPO", "JS", "JZ", "LAHF", "LDS", "LEA", "LES", "LOCK", "LODSB", "LODSW", "LOOP", "LOOPE", "LOOPNE", "LOOPNZ", "LOOPZ", "MOV", "MOVSB", "MOVSW", "MUL", "NEG", "NOP", "NOT", "OR", "OUT", "POP", "POPF", "PUSH", "PUSHF", "RCL", "RCR", "RET", "RETF", "REPNZ", "REPZ", "RETN", "SAHF", "SBB", "SCASB", "SCASW", "SHL", "SHR", "STC", "STD", "STI", "STOSB", "STOSW", "SUB", "TEST", "WAIT", "XCHG", "XLAT", "XOR",

*/
