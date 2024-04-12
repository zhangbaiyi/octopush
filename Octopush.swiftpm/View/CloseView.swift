
import SwiftUI

struct CloseView : View {
    
    @State var stats: Statistics
    
    var body: some View {
        
        let stringList = ["Excellent work completing the pushes. Try again?", "Great job! You've successfully completed the pushes. Try again?","Wonderful, you powered through the pushes. Try again?"]
        
        HStack{
            HStack{
                VStack(alignment: .leading){
                    
                    Text(stringList.randomElement()!)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(.linearGradient(colors: [Color.red, Color.orange, Color.yellow, Color.green], startPoint:.leading, endPoint: .trailing))
        
                    .padding(10)
                    
                    HStack{
                        Spacer()
                        Button(action: reset) {
                                Label("", systemImage: "arrow.counterclockwise")
                                .font(.custom("Impact", size: 60)).foregroundColor(.primary)
                            }
                        
                        
                    }

                }
                .padding()
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(lineWidth: 5, antialiased: false)
            )
            .padding()
            Spacer()
        }
    }
    
    private func reset() -> Void {
        stats.currentRound = 0
        stats.currentCount = 0
        stats.currentProgressOne = 0.0
        stats.currentProgressTwo = 0.0
        stats.currentProgressThree = 0.0
    }
    
}
