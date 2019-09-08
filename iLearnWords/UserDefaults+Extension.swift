//
//  UserDefaults+Extension.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 08/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//


import Foundation

/** Extension created to be used as a NameSpace for the
 User settings constants
 */
extension UserDefaults {
    enum keys {
        static let VoiceSpeed = "VOICE_SPEED" //The speed for the utterance object
        static let RepeatOriginal = "REPEAT_ORIGINAL" //If the user wants to repeat 3 times the original word before to hear the translation
        static let PlayInLoop = "PLAY_IN_LOOP" //Start to play again when the last word is played
        static let TranslateWay = "TRANSLATE_WAY" //From what language to what languate
        static let TalkOriginal = "TALK_ORIGINAL" //Language defenition of the original word for the Synthethiser
        static let TalkTranslate = "TALK_TRANSLATED" //Language definition of the translated word for the Synthethiser
    }
}
