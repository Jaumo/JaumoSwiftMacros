// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(member, names: arbitrary)
public macro Fixture() = #externalMacro(module: "JaumoSwiftMacrosMacros", type: "FixtureMacro")
