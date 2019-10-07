//
//  TalkManager.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 01/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//

import UIKit
import AVFoundation

enum TalkManagerError: Error {
    case sayTextUnexpectedWord
    case sayTextUnexpectedLanguage
    case unexpectedViewModel
}

public protocol TalkerDelegate: class {
    func didFinishTalk()
}

class TalkManager: NSObject {
    
    static let shared = TalkManager()
    let synthesizer = AVSpeechSynthesizer()
    public weak var delegate:TalkerDelegate?
    
    var utteranceRate: Float = 0.3
    var talkIndex = 0
    var isOriginal: Bool = true
    var shouldStop: Bool = false
    private var proxyViewModel: MainHistoryVM?
    
    // MARK: Initializers
    private override init() {
        super.init()
        synthesizer.delegate = (self as AVSpeechSynthesizerDelegate)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeSettings), name: NSNotification.Name(rawValue: UserDefaults.keys.DidChangeDefaultValues), object: nil)
        let rate = UserDefaults.standard.float(forKey: UserDefaults.keys.VoiceSpeed)
        utteranceRate = rate
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: AVAudioSession.CategoryOptions.mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Generic error")
            print(error.localizedDescription)
        }
    }

    // MARK: Public functions
    
    /// To use the sunthesizer to hear the word
    ///
    /// - Parameters:
    ///  - viewModel: The MainHistoryViewModel
    public func sayText(viewModel: MainHistoryVM) throws {
        if let lang = viewModel.history?.language {
            let word = viewModel.viewModelWords().wordsData[talkIndex]
            guard let  wordToSay  =  isOriginal ? word.original : word.translated else {
                throw TalkManagerError.sayTextUnexpectedWord
            }
            guard let langToSay = isOriginal ? lang.sayOriginal : lang.sayTranslated else {
                throw TalkManagerError.sayTextUnexpectedLanguage
            }
            proxyViewModel = viewModel
            sayText(text: wordToSay, language: langToSay)
            shouldStop = false
        }
        else {
            
        }
    }
    
    public func sayText(text: String, language: String) {
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
        shouldStop = true
        return synthesizer.stopSpeaking(at: .immediate)
    }
    
    public func isSpeaking() -> Bool {
        return synthesizer.isSpeaking
    }
    
    public func isPaused() -> Bool {
        return synthesizer.isPaused
    }
    
}

extension TalkManager: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if shouldStop { return }
        if !isOriginal { talkIndex += 1 }
        isOriginal = !isOriginal
        if proxyViewModel?.history?.words?.count == talkIndex {
            if let delegate = delegate {
                talkIndex = 0
                delegate.didFinishTalk()
            }
        }
        else {
            if let proxyViewModel = proxyViewModel {
                do {
                    try sayText(viewModel: proxyViewModel)
                }
                catch let error as TalkManagerError {
                    print(error.localizedDescription)
                }
                catch {
                    print("Generic error")
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    /// Notification when the user change values in Settings
    @objc private func didChangeSettings(){
        let value = UserDefaults.standard.float(forKey: UserDefaults.keys.VoiceSpeed)
        if value != utteranceRate{
            utteranceRate = value
        }
    }
}

extension TalkManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .sayTextUnexpectedWord:
            return "Cannot get the word from the viewModel"
        case .sayTextUnexpectedLanguage:
            return "Cannot get the Language from the viewModel"
        case .unexpectedViewModel:
            return "The viewModel passed is probably null/nil"
        }
    }
}
