import JaumoSwiftMacros
import Foundation

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

    func baz() {
    }
}

