#  Hi! Welcome to my submission!

## :overview

The project uses camera and Vision to work as a coach to count users' pushes.

## :build

- It's better to run on an iPad
- If running on macOS, please select `run destination` as Mac(Catalyst)

## :features

- Use Vision to detect human pose.
- Judge and assert user's action by mathmatically analyze points of the pose (2-D).
- Bind actions with progress ring view to show the statistics.
- Combine the UIKit and SwiftUI in one project.
- Encourage and motivate the user while doing exercise.



## :technologies

- `Vision` framework

The project's core function is human pose estimation. The Vision framework provides various detection options. One of them is to detect human body, which is very simple to use. First I make a `VNDetectHumanBodyPoseRequest` to the frame image of the camera feed. Then ideally I can obtain the key landmarks. I need to filter the useful points (using multiple `guard` statements) and pass them to the processor to determine the user's action. Swift is a type safe language, which makes processing very easy. Because if the processor function is called, the parameters are valid and can be analyzed.

- `AVCaptureSession`

The camera feed is the main view showing on the screen. The main task is to make an extension to my ViewController that adopts `AVCaptureVideoDataOutputSampleBufferDelegate` protocol. In the `captureOutput` method, send the detected points to processor and use `guard` statement to discard incomplete point group.This method also displays the landmarks and emojis on the view to show the user the progress.

- `PoseProcessor`

This class focuses on data processing. When receives the point group, it identifies the useful ones. In this project, these are the shoulder, elbow and wrist points. Because the landmarks are `CGPoint` rather than 3-D points, the processor determines the user's position and evaluates whether the projection of the angles matches a specified action. It has an intermediate state to buffer the large volume of incoming groups of landmarks.

- Views 

The main view, CameraView, is at the bottom of the ZStack, while BoxView which displays text and ProgressView which shows progress ring are on top of the ZStack. The views are directed by the State, which is determined by the user's actions. 
