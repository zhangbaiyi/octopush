//
//  EncourageView.swift
//  
//
//  Created by zby on 4/19/23.
//

import SwiftUI
struct EncourageView : View {
    
    var encourageString : String
    
    var body: some View{
        HStack {
            Text(encourageString)
                .font(.custom("Times New Roman", size: 45))
                .fontWeight(.bold)
        }
        
    }
}

