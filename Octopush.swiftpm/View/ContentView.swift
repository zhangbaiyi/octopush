import SwiftUI

struct ContentView: View {
    
    @ObservedObject var statistics = Statistics()
    @State var blurRadius : CGFloat = 20
    @State var opacityEncourage: CGFloat = 0
    @State var stringEncourage: String = "Raise your hands!"
    
    var stringList = ["Raise your hands.","Higher","Close your rings.","Hold on.","Almost there."]

    
    
    var body: some View {
        
        VStack {
            Text("Octopush!")
                .italic()
                .font(.custom("Impact", size: 60))
                .fontWeight(.heavy)
                .padding()
            ZStack {
                
                GeometryReader { geo in

                    CameraViewWrapper(statistics: statistics)
                        .blur(radius: blurRadius)
                        .onChange(of: statistics.currentRound) { newValue in
                            print(statistics.currentRound)
                            if(newValue == 0 || newValue == 4){
                                withAnimation {
                                    blurRadius = 20
                                }
                            }else{
                                withAnimation {
                                    blurRadius = 0
                                }
                            }
                        }
                    
                }
                VStack(alignment: .leading) {
                    VStack() {
                        HStack{
                            if(statistics.currentRound == 0) {
                                WelcomeView(boxWidth: UIScreen.main.bounds.width / 2 , boxHeight: UIScreen.main.bounds.height / 3)
                            } else if(statistics.currentRound == 4) {
                                CloseView(stats: statistics)
                            } else{
                                    CountView(boxWidth: UIScreen.main.bounds.width / 4, boxHeight: UIScreen.main.bounds.width / 4, count: $statistics.currentCount)
                                }
                            Spacer()
                        }
                    }
                    Spacer()
                    HStack{
                        Spacer()
                        ProgressRingView(progressOne: $statistics.currentProgressOne, progressTwo:  $statistics.currentProgressTwo, progressThree:  $statistics.currentProgressThree)
                            .scaledToFit()
                            .padding(10)
                    }
                    
                }
                
            }
            
            if(statistics.currentRound > 0 && statistics.currentRound < 3){
                EncourageView(encourageString: stringEncourage)
                    .opacity(opacityEncourage)
                    .onChange(of: statistics.currentCount) { newValue in
                        if(statistics.currentCount == 8){
                            stringEncourage = "Ring closed."
                        }else if(statistics.currentCount == 1){
                            stringEncourage = "One more round."
                        }else{
                            stringEncourage = stringList.randomElement()!
                        }
                        if(newValue > Int.random(in: 0...4)){
                            withAnimation {
                                opacityEncourage = 1
                            }
                        }else{
                            withAnimation {
                                opacityEncourage = 0
                            }
                        }
                    }
            }else if (statistics.currentRound == 0){
                EncourageView(encourageString: "Adjust your position to start.").opacity(1)
            }else if (statistics.currentRound == 3 && statistics.currentCount != 8){
                EncourageView(encourageString: "Final round.").opacity(1)
            }else if(statistics.currentRound == 3 && statistics.currentCount == 8){
                EncourageView(encourageString: "One more push.").opacity(1)
            }else{
                EncourageView(encourageString: "Thanks for using Octopush.").opacity(1)
            }
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


