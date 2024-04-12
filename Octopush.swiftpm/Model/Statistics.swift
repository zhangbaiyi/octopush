//
//  Statistics.swift
//  Pushup Watcher
//
//  Created by zby on 4/19/23.
//

import Foundation

class Statistics: ObservableObject{
    @Published var currentRound: Int = 0
    @Published var currentCount: Int = 0
    @Published var currentProgressOne: CGFloat = 0.0
    @Published var currentProgressTwo: CGFloat = 0.0
    @Published var currentProgressThree: CGFloat = 0.0
    
 
}
