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
    
    //MARK: Initializers
    override init() {
        super.init()
        synthesizer.delegate = self
    }

    //MARK: Public functions
    public func sayText(_ text: String, language: String){
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: AVAudioSession.CategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        utterance.rate = 0.3
        
        synthesizer.speak(utterance)
    }
    
    public func pauseTalk(){
        synthesizer.pauseSpeaking(at: .immediate)
        isPaused = true
    }
    
    public func resumeTalk(){
        synthesizer.continueSpeaking()
        isPaused = false
    }
}

extension TalkController: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.didFinishTalk()
    }
}
