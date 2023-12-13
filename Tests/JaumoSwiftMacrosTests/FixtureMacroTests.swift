import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import JaumoSwiftMacrosMacros

let testMacros: [String: Macro.Type] = [
    "Fixture": FixtureMacro.self,
]

final class FixtureMacroTests: XCTestCase {
    func testMacro() {
        assertMacroExpansion(
            """
            @Fixture
            struct Foo {
            @Fixture
                struct Bar {
                    let stringVar: String
                }
            
                let integer: Int
                let string: String
                let optional: String?
                let bar: Bar
                let optionalBar: Bar?
                let array: [String]
                let boolean: Bool
                let float: Float
                let double: Double
                let cgFloat: CGFloat
                let date: Date
                let dictionary: [String: Any]
                let generic: Generic<String>
                func baz() {
                }
            }
            """,
            expandedSource: """
            struct Foo {
                struct Bar {
                    let stringVar: String

                static func fixture(
                    stringVar: String = ""
                ) -> Self {
                    Self.init(
                        stringVar: stringVar
                    )
                }
                }

                let integer: Int
                let string: String
                let optional: String?
                let bar: Bar
                let optionalBar: Bar?
                let array: [String]
                let boolean: Bool
                let float: Float
                let double: Double
                let cgFloat: CGFloat
                let date: Date
                let dictionary: [String: Any]
                let generic: Generic<String>
                func baz() {
                }

                static func fixture(
                    integer: Int = 0,
                    string: String = "",
                    optional: String? = nil,
                    bar: Bar = .fixture(),
                    optionalBar: Bar? = nil,
                    array: [String] = [],
                    boolean: Bool = false,
                    float: Float = 0,
                    double: Double = 0,
                    cgFloat: CGFloat = 0,
                    date: Date = Date(),
                    dictionary: [String: Any] = [:],
                    generic: Generic<String> = .fixture()
                ) -> Self {
                    Self.init(
                        integer: integer,
                        string: string,
                        optional: optional,
                        bar: bar,
                        optionalBar: optionalBar,
                        array: array,
                        boolean: boolean,
                        float: float,
                        double: double,
                        cgFloat: cgFloat,
                        date: date,
                        dictionary: dictionary,
                        generic: generic
                    )
                }
            }
            """,
            macros: testMacros
        )
    }
}
