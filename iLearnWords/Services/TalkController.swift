//
//  TalkController.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 01/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import AVFoundation

public protocol TalkerDelegate: class {
    func didFinishTalk()
}

class TalkController: NSObject {
    
    static let shared = TalkController()
    let synthesizer = AVSpeechSynthesizer()
    public weak var delegate:TalkerDelegate?
    
    var utteranceRate: Float = 0.3
    
    //MARK: Initializers
    private override init() {
        super.init()
        synthesizer.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSettings), name: NSNotification.Name(rawValue: "DID_CHANGE_SETTINGS"), object: nil)
        let rate = UserDefaults.standard.float(forKey: "VOICE_SPEED")
        utteranceRate = rate
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: AVAudioSession.CategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }

    //MARK: Public functions
    /** On charge of create the AudioSession object, Synthesiser stuff and start the Utterance with the passed word. The language settings for the voice is passed as a parameter*/
    public func sayText(_ text: String, language: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = utteranceRate
        synthesizer.speak(utterance)
    }
    
    public func pauseTalk() {
        synthesizer.pauseSpeaking(at: .immediate)
    }
    
    public func resumeTalk() {
        synthesizer.continueSpeaking()
    }
    
    public func stopTalk() -> Bool {
        return synthesizer.stopSpeaking(at: .immediate)
    }
    
    public func isSpeaking() -> Bool {
        return synthesizer.isSpeaking
    }
    
    public func isPaused() -> Bool {
        return synthesizer.isPaused
    }
}

extension TalkController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if let del = delegate {
                del.didFinishTalk()
        }
    }
    
    @objc private func didChangeSettings(){
        let value = UserDefaults.standard.float(forKey: "VOICE_SPEED")
        if value != utteranceRate{
            utteranceRate = value
        }
    }
}
