import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct JaumoSwiftMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        FixtureMacro.self,
    ]
}
