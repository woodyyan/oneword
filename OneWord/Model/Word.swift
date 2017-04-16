//
//  Word.swift
//  OneWord
//
//  Created by Songbai Yan on 25/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class Word{
    var text:String!
    var soundmark:String!
    var partOfSpeech:String!
    var paraphrase:String!
    
    init(text:String, soundmark:String, partOfSpeech:String, paraphrase:String){
        self.text = text
        self.soundmark = soundmark
        self.partOfSpeech = partOfSpeech
        self.paraphrase = paraphrase
    }
}
