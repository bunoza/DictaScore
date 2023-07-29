import AVFoundation
import Combine
import Foundation
import Speech
import SwiftUI
import UIKit

class ScoreKeeperViewModel: ObservableObject {
    @Published var showNoPermissionAlert: Bool
    @Published var listeningAuthStatus: SFSpeechRecognizerAuthorizationStatus
    @Published var isListening: Bool
    
    @Published var players: [PlayerInfo]
    @Published var playerNumber: Int
    @Published var speechTrigger: UUID?
    
    @Published var orientation: UIDeviceOrientation = .unknown
    @Published var error: Error?
    @Published var shouldShowError: Bool = false
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var timestamp: Date = .now
    private var recognizedWords: [String] = []
    
    init(players: [PlayerInfo], playerNumber: Int) {
        self.showNoPermissionAlert = false
        self.listeningAuthStatus = SFSpeechRecognizer.authorizationStatus()
        self.isListening = false
        self.players = players
        self.orientation = .unknown
        self.playerNumber = playerNumber
    }
    
    func onAppear() {
        quitAudio()
    }
    
    func toggleListening() {
        requestTranscribePermissions() {
            self.recordButtonTapped()
        }
    }
    
    func requestTranscribePermissions(onAuthorised: @escaping () -> ()) {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    self.showNoPermissionAlert = false
                    onAuthorised()
                } else {
                    self.showNoPermissionAlert = true
                }
            }
        }
    }
    
    private func startRecording() throws {
        isListening = true
        try getAudioSession()
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionRequest.requiresOnDeviceRecognition = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                
                if self.isListening {
                    if let lastSegment = result.transcriptions.last?.segments.first {
                        for player in self.players {
                            if lastSegment.substring.lowercased().contains(player.hotword.lowercased()) || lastSegment.substring.lowercased().contains(player.nickname.lowercased()) {
                                self.speechTrigger = player.id
                                self.timestamp = .now
                            }
                        }
                        self.quitAudio()
                        inputNode.removeTap(onBus: 0)
                        
                        do {
                            try self.startRecording()
                        } catch (let error) {
                            self.quitAudio()
                            self.error = error
                            self.shouldShowError = true
                            print("Failed to start audio engine")
                        }
                    }
                }
            }
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        self.audioEngine.prepare()
        try self.audioEngine.start()
        print("Listening started")
    }
    
    func recordButtonTapped() {
        if audioEngine.isRunning {
            quitAudio()
        } else {
            do {
                try startRecording()
            } catch(let error) {
                self.error = error
                shouldShowError = true
                quitAudio()
            }
        }
    }
    
    func getAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setActive(false)
        try audioSession.setCategory(.playAndRecord, mode: .default, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    func turnOffAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setActive(false)
    }
    
    func quitAudio() {
        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        self.isListening = false
        audioEngine.stop()
        do {
            try turnOffAudioSession()
        } catch { }
    }
}

extension ScoreKeeperViewModel {
    func handleWidthCalculation(
        geometryProxy: GeometryProxy
    ) -> CGFloat {
        let parentWidth = geometryProxy.size.width
        if playerNumber == 4 {
            return parentWidth/2
        } else {
            return orientation.isLandscape ? parentWidth/CGFloat(integerLiteral: playerNumber) : parentWidth
        }
    }
    
    func handleHeightCalculation(
        geometryProxy: GeometryProxy
    ) -> CGFloat {
        let parentHeight = geometryProxy.size.height
        if playerNumber == 4 {
            return parentHeight/2
        } else {
            return orientation.isLandscape ? parentHeight : parentHeight/CGFloat(integerLiteral: playerNumber)
        }
    }
}
