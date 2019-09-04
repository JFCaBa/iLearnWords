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
    
    public var isPaused = false
    let synthesizer = AVSpeechSynthesizer()
    public weak var delegate:TalkerDelegate?
    
    var utteranceRate: Float = 0.3
    
    //MARK: Initializers
    override init() {
        super.init()
        synthesizer.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSettings), name: NSNotification.Name(rawValue: "DID_CHANGE_SETTINGS"), object: nil)
        let rate = UserDefaults.standard.float(forKey: "VOICE_SPEED")
        utteranceRate = rate
    }

    //MARK: Public functions
    public func sayText(_ text: String, language: String){
        isPaused = false
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: AVAudioSession.CategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = utteranceRate
        
        synthesizer.speak(utterance)
    }
    
    public func pauseTalk() {
        
        synthesizer.pauseSpeaking(at: .immediate)
        isPaused = true
    }
    
    public func resumeTalk() {
        synthesizer.continueSpeaking()
        isPaused = false
    }
    
    public func stopTalk() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}

extension TalkController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.didFinishTalk()
    }
}

extension TalkController{
    @objc private func didChangeSettings(){
        let value = UserDefaults.standard.float(forKey: "VOICE_SPEED")
        if value != utteranceRate{
            utteranceRate = value
        }
    }
}
