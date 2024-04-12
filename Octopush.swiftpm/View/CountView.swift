//
//  WelcomeView.swift
//
//
//  Created by zby on 4/19/23.
//

import SwiftUI
struct CountView : View {
    
    @State var boxWidth: CGFloat
    @State var boxHeight: CGFloat
    
    @Binding var count: Int
    
    var body: some View{
        Text(count.formatted(.number))
            .font(.custom("Impact", size: 100))
            .fontWeight(.heavy)
            .padding()
            .foregroundColor(Color.white)
            .frame(width: boxWidth , height: boxHeight)
            .background(.black)
            .mask(RoundedRectangle(cornerRadius: 30))
            .multicolorGlow()
            .position(CGPoint(x: UIScreen.main.bounds.minX + 125 , y: UIScreen.main.bounds.minY + 80))
        
    }
}

extension View {
    func multicolorGlow() -> some View {
        return ZStack {
            ForEach(0..<2) { i in
                Rectangle()
                    .fill(AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center))
                    .mask(self.blur(radius: 20))
                    .overlay(self.blur(radius: 5 - CGFloat(i * 5)))
            }
        }
    }
}
