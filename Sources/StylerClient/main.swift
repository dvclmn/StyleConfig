
//
//let a = 17
//let b = 25
//
//let (result, code) = #stringify(a + b)
//
//print("The value \(result) was produced by the code \"\(code)\"")
//

import Styler
import Stylable
import SwiftUI



struct TestConfiguration {
  var myColour: Color = .red
}

@Styler
struct ExampleView: View, Stylable {
  
  typealias StyleConfiguration = TestConfiguration
  
  var config = TestConfiguration()
    
  var body: some View {
    
    Text("Hello")
      .background(config.myColour)
      
  }
}
