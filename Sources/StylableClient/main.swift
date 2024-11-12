//import Stylable
//
//let a = 17
//let b = 25
//
//let (result, code) = #stringify(a + b)
//
//print("The value \(result) was produced by the code \"\(code)\"")
//

import Stylable


@Stylable
struct TestConfiguration {
  var example: String = ""
}


extension TestConfiguration: Stylable {
  typealias StyleConfiguration = TestConfiguration
  
  var config: TestConfiguration {
    get {
      self
    }
    set(newValue) {
      self = newValue
    }
  }
  
  
}

// Now you can use it
//let test = TestConfiguration()
//.example("Hello")

//
//struct ExampleView: View, Stylable {
//
//  typealias StyleConfiguration = TestConfiguration
//
//  /// Important: `config` needs to be both gettable and settable
//  var config: TestConfiguration {
//    get {
//      self
//    }
//    set(newValue) {
//      self = newValue
//    }
//  }
//
//  var body: some View // etc...
//
//}
//
//struct ExampleParentView: View {
//  var body: some View {
//    ExampleView()
//      .config(.example("Hello"))
//  }
//}
