//
//  WelcomeView.swift
//  
//
//  Created by zby on 4/19/23.
//

import SwiftUI

struct WelcomeView : View {
    
    @State var boxWidth: CGFloat
    @State var boxHeight: CGFloat
    
    var body: some View {
        
        
        HStack{
            HStack{
                VStack(alignment: .leading){
                    
                    Text("Hi!\nWelcome to Baiyi's WWDC23 submission🫨\nSitting for a while? Let's lift some stuff!🍎⚽️🍊\nOctopush provides an exercise\nto relax your body")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    HStack{
                        Text("It uses")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Text(" Vision ")
                            .font(.title)
                            .fontWeight(.black)
                            .lineLimit(1)
                            .foregroundStyle(.linearGradient(colors: [Color.red, Color.orange, Color.yellow, Color.green], startPoint:.leading, endPoint: .trailing))
                        Text("to detect your pose")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                    }
                    Text("When you arms are up\nthe dots🟠 on your body becomes green🟢\nTo complete the exercise,")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    HStack{
                        Text("you lift")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text("8 times for 3 rounds")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.orange)
                    }
                    
                    Text("If you are ready, please")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("🧍stand up🧍and\n✋raise your hands!🤚")
                        .font(.custom("Impact", size: 50))
                        .fontWeight(.black)
                        .foregroundColor(.primary)
                    
                    
                    
                }
                .padding(10)
                Spacer()
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

//
//        Text("Raise\nyour\nhands!")
//            .fontWeight(.heavy)
//            .padding()
//            .foregroundColor(Color.white)
//            .font(.custom("SF", size: 40))
//            .frame(width: UIScreen.main.bounds.width / 1.3 , height: UIScreen.main.bounds.width / 2 )
//            .background(.white)
//            .mask(RoundedRectangle(cornerRadius: 30))
//            .multicolorGlow()
//            .position(.init(x: UIScreen.main.bounds.maxX / 2, y: 200))
            
       
        
    
    





