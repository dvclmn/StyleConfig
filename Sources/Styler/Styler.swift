// The Swift Programming Language
// https://docs.swift.org/swift-book

import Stylable

@attached(extension, names: arbitrary)
public macro Styler() = #externalMacro(module: "StylerMacros", type: "StylerMacro")

