//
//  FoulLanguageFilter.swift
//  BoardingPass
//
//  Created by Tom Seymour on 12/9/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

//enum FoulLanguageFilter {
//    case isOn, isOff
//}
//
//class FoulLanguageManager {
//    
//    var filter: FoulLanguageFilter = .isOn
//    
//    let curseWordSet: Set = ["fuck", "fucks", "fucking", "fuckin", "fuckity", "fucked", "fucker", "motherfucker", "motherfuck", "fucktard", "shit", "cock", "cocks", "cocksplat", "pussy", "pussies", "twat", "twats", "arse", "asshole", "bitch", "dick", "dicks", "dickface", "ass", "bollocks"]
//    
//    func filteredString(str: String) -> String {
//        var filteredString = str
//        let words = str.components(separatedBy: CharacterSet.punctuationCharacters.union(.whitespacesAndNewlines))
//        for word in words {
//            if curseWordSet.contains(word.lowercased()) {
//                var cleanWord = ""
//                var replacedFirstVowel = false
//                for c in word.characters {
//                    if !replacedFirstVowel {
//                        switch c {
//                        case "a", "e", "i", "o", "u", "A", "E", "I", "O", "U":
//                            cleanWord += "*"
//                            replacedFirstVowel = true
//                            continue
//                        default:
//                            break
//                        }
//                    }
//                    cleanWord += String(c)
//                }
//                filteredString = filteredString.replacingOccurrences(of: word, with: cleanWord)
//            }
//        }
//        return filteredString
//    }
//    
//}
