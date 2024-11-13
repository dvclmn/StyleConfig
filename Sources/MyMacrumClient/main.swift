import MyMacrum

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

@StyleConfig
public struct SliderConfiguration: Sendable {
  public var icon: String? = nil
  public var decimals: Int = 2
}
