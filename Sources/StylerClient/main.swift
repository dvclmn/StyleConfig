
//
//let a = 17
//let b = 25
//
//let (result, code) = #stringify(a + b)
//
//print("The value \(result) was produced by the code \"\(code)\"")
//

import Styler
import SwiftUI


@Styler
struct TestConfiguration {
  var myColour: Color = .red
}


struct ExampleView: View, Stylable {
  
  typealias StyleConfiguration = TestConfiguration
  
  var config = TestConfiguration()
    
  var body: some View {
    
    Text("Hello")
      .background(config.myColour)
      
  }
}


struct ParentView: View {
  
  var body: some View {
    
    ExampleView()
      .with(.init(myColour: .green))
      .padding(40)
      .frame(width: 600, height: 700)
      .background(.black.opacity(0.6))
    
  }
}

#if DEBUG
#Preview {
  ParentView()
}
#endif







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
