/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app's main view controller object.
*/

import UIKit
import AVFoundation
import Vision

class CameraViewController: UIViewController {

    
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    private var cameraFeedSession: AVCaptureSession?
    private var bodyPoseRequest = VNDetectHumanBodyPoseRequest()
    private var lastObservationTimestamp = Date()
    private var lastState: PoseProcessor.State?
    
    private let roundOneEmojis = ["🍎","🍋","🥝","🍊","🫒","🥔","🥬","🍔","🍓"]
    private let roundTwoEmojis = ["⚽️","🏀","🎱","🏉","🏈","🥎","🎲","💣","🏐"]
    
    var stats: Statistics?
    
    
    var leftEmojiLabel: UILabel!
    var rightEmojiLabel: UILabel!
    var crownEmojiLabel: UILabel!
    
    private var poseProcessor = PoseProcessor()
    
    override func loadView() {
        view = CameraView()
    }
    
    private var cameraView: CameraView { view as! CameraView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        poseProcessor.didChangeStateClosure = { [weak self] state in
            self?.handlePoseStateChange(state: state)
        }
        leftEmojiLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: 100, height: 100))
        leftEmojiLabel.text = ""
        leftEmojiLabel.font = .boldSystemFont(ofSize: 100)
        
        rightEmojiLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: 100, height: 100))
        rightEmojiLabel.text = ""
        rightEmojiLabel.font = .boldSystemFont(ofSize: 100)
        
        crownEmojiLabel = UILabel(frame:  CGRect(x: 0, y: 0, width: 150, height: 150))
        crownEmojiLabel.text = "👑"
        crownEmojiLabel.font = .boldSystemFont(ofSize: 150)

        
        view.addSubview(leftEmojiLabel)
        view.addSubview(rightEmojiLabel)
        view.addSubview(crownEmojiLabel)

        leftEmojiLabel.isHidden = true
        rightEmojiLabel.isHidden = true
        crownEmojiLabel.isHidden = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            if cameraFeedSession == nil {
                cameraView.previewLayer.videoGravity = .resizeAspectFill
                try setupAVSession()
                cameraView.previewLayer.session = cameraFeedSession
            }
            startCaptureSession()
        } catch {
            AppError.display(error, inViewController: self)
        }
    }
    
    func updatePoints(point1: CGPoint, point2: CGPoint) {
        
        leftEmojiLabel.center = point1
        rightEmojiLabel.center = point2
        crownEmojiLabel.center = .midPoint(p1: point1, p2: point2)
        
        let maxY = view.frame.height - leftEmojiLabel.frame.height
        
        leftEmojiLabel.frame.origin.y = min(maxY, max(0, leftEmojiLabel.frame.origin.y)) - 70
        rightEmojiLabel.frame.origin.y = min(maxY, max(0, rightEmojiLabel.frame.origin.y)) - 70
        crownEmojiLabel.frame.origin.y = min(maxY, max(0, crownEmojiLabel.frame.origin.y)) - 70

        
        

    }
    
    func updateEmojis(){
        switch stats?.currentRound{
        case 0, 1:
            leftEmojiLabel.text = roundOneEmojis.randomElement()
            rightEmojiLabel.text = roundOneEmojis.randomElement()
        case 2:
            leftEmojiLabel.text = roundTwoEmojis.randomElement()
            rightEmojiLabel.text = roundTwoEmojis.randomElement()
        case 3:
            leftEmojiLabel.text = "🐙"
            rightEmojiLabel.text = "🐙"
        default:
            leftEmojiLabel.text = ""
            rightEmojiLabel.text = ""
        }
    }
    
    func startCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.cameraFeedSession?.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    func setupAVSession() throws {
        // Select a front facing camera, make an input.
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw AppError.captureSessionSetup(reason: "Could not find a front facing camera.")
        }
        
       
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            throw AppError.captureSessionSetup(reason: "Could not create video device input.")
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = AVCaptureSession.Preset.high
        
        // Add a video input.
        guard session.canAddInput(deviceInput) else {
            throw AppError.captureSessionSetup(reason: "Could not add video device input to the session")
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            // Add a video data output.
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.captureSessionSetup(reason: "Could not add video data output to the session")
        }
        session.commitConfiguration()
        cameraFeedSession = session
}
    
    func processPoints(leftWrist: CGPoint?, leftElbow: CGPoint?, rightWrist: CGPoint?, rightElbow: CGPoint?, leftShoulder: CGPoint?, rightShoulder: CGPoint?, neck: CGPoint?) {
        
        guard let leftWristPoint = leftWrist, let leftElbowPoint = leftElbow, let leftShoulderPoint = leftShoulder, let rightWristPoint = rightWrist, let rightElbowPoint = rightElbow, let rightShoulderPoint = rightShoulder, let neckPoint = neck else{
            if Date().timeIntervalSince(lastObservationTimestamp) > 0.1 {
                poseProcessor.reset()
            }
            cameraView.hidePoints()
            cameraView.hideLayer()
            leftEmojiLabel.isHidden = true
            rightEmojiLabel.isHidden = true
            crownEmojiLabel.isHidden = true

            return
        }
        
        // Convert points from AVFoundation coordinates to UIKit coordinates.
        let previewLayer = cameraView.previewLayer
        let leftWristPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: leftWristPoint)
        let leftElbowPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: leftElbowPoint)
        let leftShoulderPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: leftShoulderPoint)
        let rightWristPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: rightWristPoint)
        let rightElbowPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: rightElbowPoint)
        let rightShoulderPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: rightShoulderPoint)

        let neckPointConverted = previewLayer.layerPointConverted(fromCaptureDevicePoint: neckPoint)
        // Process new points
        poseProcessor.processPointsPair((leftWristPointConverted, leftElbowPointConverted, leftShoulderPointConverted, rightWristPointConverted, rightElbowPointConverted, rightShoulderPointConverted, neckPointConverted))
    }
    
    private func handlePoseStateChange(state: PoseProcessor.State) {
        
        let pushPoints = poseProcessor.lastProcessedPushPoints
        var tipsColor: UIColor
        
        if(stats?.currentRound != 4){
            
            switch state {
            case .possibleUp, .possibleDown, .down:
                tipsColor = .orange
                lastState = .down
            case .up:
                if(lastState != .up){
                    updateEmojis()
                    stats?.currentCount += 1
                    if(stats?.currentRound == 0) {
                        stats?.currentRound = 1
                    }
                    if(stats?.currentCount == 9) {
                        stats?.currentCount = 1
                        stats?.currentRound += 1
                        if(stats?.currentRound == 4){
                            updateEmojis()
                            return
                        }
                        updateEmojis()
                    }
                    if(stats?.currentProgressOne != 1.0){
                        stats?.currentProgressOne = CGFloat(stats!.currentCount) / 8
                    } else if( stats?.currentProgressTwo != 1.0 ) {
                        stats?.currentProgressTwo = CGFloat(stats!.currentCount) / 8
                    } else{
                        stats?.currentProgressThree = CGFloat(stats!.currentCount) / 8
                    }
                    
                }
                tipsColor = .green
                lastState = .up
            case .unknown:
                tipsColor = .red
                lastState = .unknown
            }
            cameraView.showLayer()
            cameraView.showPoints([pushPoints.leftWrist, pushPoints.leftElbow, pushPoints.leftShoulder, pushPoints.rightWrist, pushPoints.rightElbow, pushPoints.rightShoulder, pushPoints.neck], color: tipsColor)
            leftEmojiLabel.isHidden = false
            rightEmojiLabel.isHidden = false
            
            if(stats?.currentRound == 3 && (stats?.currentCount == 8)){
                crownEmojiLabel.isHidden = false
            }else{
                crownEmojiLabel.isHidden = true
            }
            
            updatePoints(point1: pushPoints.leftWrist, point2: pushPoints.rightWrist)
            
        }else {
            cameraView.showLayer()
            stats?.currentCount = 0
            stats?.currentProgressThree = 1
        }
        
    }
    

}

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        var leftWrist: CGPoint?
        var rightWrist: CGPoint?
        var leftElbow: CGPoint?
        var rightElbow: CGPoint?
        var leftShoulder: CGPoint?
        var rightShoulder: CGPoint?
        var neck: CGPoint?
        defer {
            DispatchQueue.main.sync {
                self.processPoints(leftWrist: leftWrist,leftElbow: leftElbow, rightWrist: rightWrist, rightElbow: rightElbow, leftShoulder: leftShoulder, rightShoulder: rightShoulder, neck: neck)

            }
        }

        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up, options: [:])
        do {
            try handler.perform([bodyPoseRequest])
            
            guard let bodyObservation = bodyPoseRequest.results?.first else {
                return
            }
            
            let bodyPoints = try bodyObservation.recognizedPoints(.all)
            
            guard let leftWristPoint = bodyPoints[.leftWrist], let rightWristPoint = bodyPoints[.rightWrist], let leftElbowPoint = bodyPoints[.leftElbow], let rightElbowPoint = bodyPoints[.rightElbow], let leftShoulderPoint = bodyPoints[.leftShoulder], let rightShoulderPoint = bodyPoints[.rightShoulder], let neckPoint = bodyPoints[.neck] else{
                return
            }
            
            
            guard leftWristPoint.confidence > 0.2 && rightWristPoint.confidence > 0.2 && leftElbowPoint.confidence > 0.2 && rightElbowPoint.confidence > 0.2 && leftShoulderPoint.confidence > 0.2 && rightShoulderPoint.confidence > 0.2 &&  neckPoint.confidence > 0.2 else{
                return
            }

            leftWrist = CGPoint(x: leftWristPoint.location.x, y: 1 - leftWristPoint.location.y)
            leftElbow = CGPoint(x: leftElbowPoint.location.x, y: 1 - leftElbowPoint.location.y)
            leftShoulder = CGPoint(x: leftShoulderPoint.location.x, y: 1 - leftShoulderPoint.location.y)

            rightWrist = CGPoint(x: rightWristPoint.location.x, y: 1 - rightWristPoint.location.y)
            rightElbow = CGPoint(x: rightElbowPoint.location.x, y: 1 - rightElbowPoint.location.y)
            rightShoulder = CGPoint(x: rightShoulderPoint.location.x, y: 1 - rightShoulderPoint.location.y)
            
            neck = CGPoint(x: neckPoint.location.x, y: 1 - neckPoint.location.y)

        } catch {
            cameraFeedSession?.stopRunning()
            let error = AppError.visionError(error: error)
            DispatchQueue.main.async {
                error.displayInViewController(self)
            }
        }
    }
    

}

