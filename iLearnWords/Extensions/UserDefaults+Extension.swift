//
//  UserDefaults+Extension.swift
//  iLearnWords
//
//  Created by Jose Francisco Catalá Barba on 08/09/2019.
//  Copyright © 2019 Jose Francisco Catalá Barba. All rights reserved.
//


import Foundation
import UIKit

/** Extension created to be used as a NameSpace for the
 User settings constants
 */
extension UserDefaults {
    enum keys {
        /** The app did run once */
        static let RunOnce = "RUN_ONCE"
        
        /** Related to the Synthezyser */
        //The speed for the utterance object
        static let VoiceSpeed = "VOICE_SPEED"
        //If the user wants to repeat 3 times the original word before to hear the translation
        static let RepeatOriginal = "REPEAT_ORIGINAL"
        //Start to play again when the last word is played
        static let PlayInLoop = "PLAY_IN_LOOP"
        //From what language to what languate
        static let TranslateWay = "TRANSLATE_WAY"
        //Language defenition of the original word for the Synthethiser
        static let TalkOriginal = "TALK_ORIGINAL"
        //Language definition of the translated word for the Synthethiser
        static let TalkTranslate = "TALK_TRANSLATED"
        //Default translate way in the first app instalation
        static let DefaultTranslateWay = "ru-en"
        
        /** Related to Colors */
        //The speed for the utterance object
        static let CellSelectedBackgroundColor = "CELL_SELECTED_BACKGROUND_COLOR"
        //The speed for the utterance object
        static let CellBackgroundColor = "CELL_BACKGROUND_COLOR"
        
        /** Related to Notifications */
        static let DidChangeDefaultValues = "DID_CHANGE_SETTINGS"
    }
    
    /** CoreData stuff */
    enum Languages {
        static let Title = "title"
        static let IsSelected = "isSelected"
        static let RecordID = "recordID"
        static let SayOriginal = "sayOriginal"
        static let SayTranslated = "sayTranslated"
        static let Way = "way"
        static let RecordName = "recordName"
        static let LastUpdate = "modificationDate"
        static let History = "history"
    }
    
    enum History {
        static let Title = "title"
        static let IsSelected = "isSelected"
        static let RecordID = "recordID"
        static let RecordName = "recordName"
        static let LastUpdate = "modificationDate"
        static let Words = "words"
        static let Language = "language"
    }
    
    enum Words {
        static let Original = "original"
        static let Translated = "translated"
        static let RecordID = "recordID"
        static let RecordName = "recordName"
        static let LastUpdate = "modificationDate"
        static let History = "history"
    }
    
    enum Entity {
        static let Languages = "Languages"
        static let History = "History"
        static let Words = "Words"
    }

    /** Convenient functions to store color in UserDefaults */
    func colorForKey(key: String) -> UIColor? {
        if let colorData = data(forKey: key) {
            do {
                let color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
                return color
            }
            catch let error {
                print(error)
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    func setColor(color: UIColor?, forKey key: String) {
        if let color = color {
            do {
                let  colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
                set(colorData, forKey: key)
            }
            catch let error as NSError {
                print(error)
            }
        }
    }
}
