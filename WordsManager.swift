//
//  WordsManager.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/14/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation

class WordsManager {
    static let sharedInstance = WordsManager()
    
    var bundle: NSBundle!
    var fullArray: [String] = []
    
    //let words = ["A", "B", ]
    //
    //func getWord() -> String {
        
    //}
    
    
    func arrayOfWords(easyLevel: Bool) -> [String] {
        
        //~~~~~~~ Reading into a word list text file and populating an array with the words ~~~~~~~~~~//
        bundle = NSBundle.mainBundle()
        let path = bundle.pathForResource("wordsEn", ofType: "txt")!
        
        //~~~~~~~ Copies entire word list into a super long string to split ~~~~~~~~~~~~~~~~~~~~~~~~~~//
        let contents: String?
        
        do {
            contents = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        } catch _ {
            contents = nil
        }
        
        var tempArray: [String] = []
        tempArray = contents!.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        
        //~~~~~~~ Individual strings of the word list are now members of fullArray ~~~~~~~~~~~~~~~~~~~//
        for index in 0...tempArray.count-1 {
            fullArray.append(tempArray[index])
        }
        
        //MARK: ~~~~~~~~~~~~ Picking from full array to make Easy/Hard Array ~~~~~~~~~~~~~~~~~~~~~~~~~//
        
        if easyLevel {
        //return Easy Array (words of length 5 characters & under)
        
        } else {
            
        //return Hard Array (words of length 10 characters & under)
        }
        
        
        
        return fullArray //To be deleted once the above is implemented
    }

} //End of WordsManager