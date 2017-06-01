//
//  TodayService.swift
//  OneWord
//
//  Created by Songbai Yan on 01/06/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class TodayService {
    func getRandomWord() -> Word{
        // Sample: Word(text: "abandon", soundmark: "[ə'bændən]", partOfSpeech: "vt.", paraphrase: "丢弃，放弃，抛弃")
        var word = Word(text: "", soundmark: "", partOfSpeech: "", paraphrase: "")
        do {
            if let path = Bundle.main.path(forResource: "words", ofType: "txt") {
                let data = try String(contentsOfFile: path)
                let wordLines = data.components(separatedBy: .newlines)
                
                var isWordOK = false
                while !isWordOK {
                    let randomNumber = Int(arc4random_uniform(UInt32(wordLines.count)))
                    let wordString = wordLines[randomNumber]
                    let components = wordString.components(separatedBy: "/")
                    if components.count == 3 {
                        let text = components[0]
                        let soundmark =  "/" + components[1] + "/"
                        var paraphraseComponents = components[2].components(separatedBy: ".")
                        var partOfSpeech = ""
                        var paraphrase = ""
                        if paraphraseComponents.count >= 2 {
                            partOfSpeech = paraphraseComponents[0] + "."
                            paraphraseComponents.remove(at: 0)
                            paraphrase = paraphraseComponents.joined(separator: "")
                            word = Word(text: text, soundmark: soundmark, partOfSpeech: partOfSpeech, paraphrase: paraphrase)
                            isWordOK = true
                        }
                    }
                }
            }
        } catch let error{
            print(error)
        }
        return word
    }
}
