import Foundation

class MainService {
    let allPartOfSpeech = ["a.&ad.", "conj.&n.", "vt.&aux.", "vt.&vi.&n.", "vi.&vt.&n.", "n.&vi.&vt.", "n.&vt.&vi.", "n.&vt.", "vi.&n.", "n.&vi.", "vt.&n.", "n.&v.", "vi.&vt.", "prep.", "vt.&vi.", "pron.", "n.", "a.", "v.", "conj.", "vi.", "vt.", "aux.", "adj.", "adv.", "art.", "num.", "int.", "u.", "c.", "pl."]
    
    private var expiredNumbers = [Int]()
    
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
                    if !expiredNumbers.contains(randomNumber) {
                        expiredNumbers.append(randomNumber)
                        let wordString = wordLines[randomNumber]
                        let components = wordString.components(separatedBy: "/")
                        if components.count == 3 {
                            let text = components[0]
                            let soundmark =  "/" + components[1] + "/"
                            let allParaphrase = components[2]
                            var paraphraseComponents = getParaphraseComponents(wholeParaphrase: allParaphrase)
                            var partOfSpeech = ""
                            var paraphrase = ""
                            if paraphraseComponents.count >= 2 {
                                partOfSpeech = paraphraseComponents[0]
                                paraphraseComponents.remove(at: 0)
                                paraphrase = paraphraseComponents.joined(separator: "")
                                word = Word(text: text, soundmark: soundmark, partOfSpeech: partOfSpeech, paraphrase: paraphrase)
                                isWordOK = true
                            }
                        }
                    }
                }
            }
        } catch let error{
            print(error)
        }
        return word
    }
    
    func getParaphraseComponents1(wholeParaphrase:String) -> [String]{
        var components = [String]()
        if hasPartOfSpeech(paraphrase: wholeParaphrase){
            let coms = getCurrentComponents(wholeParaphrase: wholeParaphrase)
            for com in coms{
                if hasPartOfSpeech(paraphrase: com){
                    let coms2 = getCurrentComponents(wholeParaphrase: com)
                    for com2 in coms2{
                        if hasPartOfSpeech(paraphrase: com2){
                            let coms3 = getCurrentComponents(wholeParaphrase: com2)
                            for com3 in coms3{
                                if hasPartOfSpeech(paraphrase: com3){
                                    
                                }else{
                                    components.append(com3)
                                }
                            }
                        }else{
                            components.append(com2)
                        }
                    }
                }else{
                    components.append(com)
                }
            }
        }
        
        return components
    }
    
    func getParaphraseComponents(wholeParaphrase:String) -> [String]{
        var components = [String]()
        if hasPartOfSpeech(paraphrase: wholeParaphrase){
            components = getComponents(paraphrase: wholeParaphrase)
        }
        
        return components
    }
    
    private func getComponents(paraphrase:String) -> [String] {
        var components = [String]()
        let currentComponents = getCurrentComponents(wholeParaphrase: paraphrase)
        for component in currentComponents{
            if hasPartOfSpeech(paraphrase: component){
                let tempComponents = getComponents(paraphrase:component)
                for temp in tempComponents{
                    components.append(temp)
                }
            }else{
                components.append(component)
            }
        }
        
        return components
    }
    
    func hasPartOfSpeech(paraphrase:String) -> Bool{
        return !allPartOfSpeech.contains(paraphrase) && paraphrase.contains(".")
    }
    
    func getCurrentComponents(wholeParaphrase:String) -> [String] {
        var components = [String]()
        for part in allPartOfSpeech{
            let str = NSString(string: wholeParaphrase)
            let range = str.range(of: part)
            if range.length > 0{
                let s1 = str.substring(to: range.location)
                let s2 = str.substring(with: range)
                let s3 = str.substring(from: range.location + range.length)
                if s1.trimmingCharacters(in: CharacterSet.whitespaces).count > 0{
                    components.append(s1)
                }
                if s2.trimmingCharacters(in: CharacterSet.whitespaces).count > 0{
                    components.append(s2)
                }
                if s3.trimmingCharacters(in: CharacterSet.whitespaces).count > 0{
                    components.append(s3)
                }
                break
            }
        }
        return components
    }
}
