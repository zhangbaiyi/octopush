//
//  ProgressRingView.swift
//
//
//  Created by zby on 4/19/23.
//

import Foundation
import SwiftUI

struct ProgressRingView: View {
    @Binding var progressOne: CGFloat
    @Binding var progressTwo: CGFloat
    @Binding var progressThree: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: progressThree)
//                .trim(from: 0, to: 1)
                .stroke(
                    Color.outerColor,
                    style: StrokeStyle(lineWidth: 33, lineCap: .round)
                ).rotationEffect(.degrees(-90))
                .shadow(color: Color.outerColor, radius: 20, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
            .padding(20)
            Circle()
                .trim(from: 0, to: progressTwo)
//                .trim(from: 0, to: 1)
                .stroke(
                    Color.middleColor,
                    style: StrokeStyle(lineWidth: 33, lineCap: .round)
                ).rotationEffect(.degrees(-90))
                .shadow(color: Color.middleColor, radius: 15, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                .padding(60)
            Circle()
                .trim(from: 0, to: progressOne)
//                .trim(from: 0, to: 1)
                .stroke(
                    Color.innerColor,
                    style: StrokeStyle(lineWidth: 30, lineCap: .round)
                ).rotationEffect(.degrees(-90))
                .shadow(color: Color.innerColor, radius: 5, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                .padding(100)
        }.frame(maxWidth: UIScreen.main.bounds.width / 3, maxHeight: UIScreen.main.bounds.width / 3)
            .opacity(0.7)
        
        
        .animation(.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
            
        
    }
 
}

extension Color {

    public static var outerColor: Color{
        return Color(decimalRed: 255, green: 90, blue: 95)
    }
    
    public static var middleColor: Color{
        return Color(decimalRed: 150, green: 245, blue: 80)
    }
    
    public static var innerColor: Color{
        return Color(decimalRed: 114, green: 244, blue: 234)
    }
    
    public init(decimalRed red: Double, green: Double, blue: Double) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255)
    }
}
