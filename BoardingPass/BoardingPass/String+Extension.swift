//
//  String+Extension.swift
//  BoardingPass
//
//  Created by Tom Seymour on 12/9/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

extension String {
    func filteredIfFilteringIsOn() -> String {
        
        switch FoaasDataManager.shared.filter {
        case .isOff:
            return self
        case .isOn:
            let foulWords: Set<String> = ["fuck", "bitch", "ass", "dick", "pussy", "shit", "twat", "cunt", "cock"]
            let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
            
            func filterFoulWords (_ str: String) -> String {
                var words = str.components(separatedBy: " ")
                for (index, word) in words.enumerated() {
                    let filteredWord = word.replacingOccurrences(of: word, with: filter(word), options: .caseInsensitive, range: nil)
                    words[index] = filteredWord
                }
                return words.joined(separator: " ")
            }
            func filter(_ word: String) -> String {
                for foulWord in foulWords where word.lowercased().contains(foulWord){
                    for char in word.lowercased().characters where vowels.contains(char) {
                        return word.replacingOccurrences(of: String(char), with: "*", options: .caseInsensitive, range: nil)
                    }
                }
                return word
            }
            return filterFoulWords(self)
        }
        
    }
}



