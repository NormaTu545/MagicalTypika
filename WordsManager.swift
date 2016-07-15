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
    var fullArray: [String] = [] //every word in the wordsEn.txt file
    var easyArray: [String] = [] //words 5 characters or less only
    var hardArray: [String] = [] //words 10 characters or less only
    
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
        
        for index in 0...fullArray.count-1 {
            if easyLevel {
                //populate the easy level words array
                if fullArray[index].characters.count <= 5 {
                   easyArray.append(fullArray[index])
                }
                
            } else {
                //populate the hard level words array 
                if fullArray[index].characters.count <= 10 {
                    hardArray.append(fullArray[index])
                }
                
            }
        }
        
        //Return the right array
        if easyLevel {
            return easyArray
        } else {
            return hardArray
        }
    }
} //End of WordsManager