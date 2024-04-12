//
//  PoseProcessor.swift
//  Pushup Watcher
//
//  Created by zby on 4/18/23.
//

import Foundation
import CoreGraphics


class PoseProcessor {
    enum State {
        case possibleDown
        case down
        case possibleUp
        case up
        case unknown
    }
    
    typealias PushPoints = (
        leftWrist: CGPoint,
        leftElbow: CGPoint,
        leftShoulder: CGPoint,
        rightWrist: CGPoint,
        rightElbow: CGPoint,
        rightShoulder: CGPoint,
        neck: CGPoint
    )
    
    private var downEvidenceCounter = 0
    private var upEvidenceCounter = 0
    
    var didChangeStateClosure: ((State) -> Void)?
    private (set) var lastProcessedPushPoints = PushPoints(.zero, .zero, .zero, .zero, .zero, .zero, .zero)
    
    private var state = State.unknown {
        didSet {
            didChangeStateClosure?(state)
        }
    }
    
    init() {
        
    }
    
    func reset() {
        state = .unknown
        upEvidenceCounter = 0
        downEvidenceCounter = 0
    }
    
    func processPointsPair(_ points: PushPoints) {
        lastProcessedPushPoints = points
        let leftArmAngle = CGPoint.angleBetweenThreePoints(center: points.leftElbow, pointA: points.leftWrist, pointB: points.leftShoulder)
        let rightArmAngle = CGPoint.angleBetweenThreePoints(center: points.rightElbow, pointA: points.rightWrist, pointB: points.rightShoulder)
        let angleDiff = rightArmAngle > leftArmAngle ? rightArmAngle - leftArmAngle: leftArmAngle - rightArmAngle
        
   
        
        if(leftArmAngle > 150.0 && rightArmAngle > 150.0 && angleDiff < 40.0 ) {
            upEvidenceCounter += 1
            downEvidenceCounter = 0
            state = (upEvidenceCounter > 10) ? .up : .possibleUp
        }else {
            downEvidenceCounter += 1
            upEvidenceCounter = 0
            state = (upEvidenceCounter > 10) ? .down : .possibleDown
        
        }
        
    }
    
}


extension CGPoint {

    static func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    func distance(from point: CGPoint) -> CGFloat {
        return hypot(point.x - x, point.y - y)
    }
    
    static func angleBetweenThreePoints(center: CGPoint, pointA: CGPoint, pointB: CGPoint) -> CGFloat {
        let angleA = atan2(pointA.y - center.y, pointA.x - center.x)
        let angleB = atan2(pointB.y - center.y, pointB.x - center.x)
        var angleDiff = angleA - angleB > 0 ? angleA - angleB : angleB - angleA
        if angleDiff > CGFloat.pi {
            angleDiff = 2.0 * CGFloat.pi - angleDiff
        }
        
        return angleDiff / CGFloat.pi * 180
    }
}
