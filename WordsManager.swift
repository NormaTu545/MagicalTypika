//
//  WordsManager.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/14/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import GameplayKit //Just need it for shuffling an array's members

class WordsManager {
    static let sharedInstance = WordsManager()
    
    var bundle: NSBundle!
    var fullArray: [String] = [] //every word in the wordsEn.txt file
    var easyArray: [String] = [] //words 5 characters or less only
    var hardArray: [String] = [] //words 10 characters or less only
    var easyLevel: Bool = true //initialize to true
    
    init() {
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
        
        //Shuffle so that different random seeds happen
        easyArray = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(easyArray) as! [String]
        hardArray = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(hardArray) as! [String]

    }
    
    func getArrayOfWords(easyLevel: Bool) -> [String] {
        //Getter function to return the correct array
        if easyLevel {
            return easyArray
        } else {
            return hardArray
        }
    }
    
    
    func getRandomWord(easyLevel: Bool) -> String {
        //return a random string value in either easy or hard array
        if (easyLevel) {
            return easyArray[random() % (easyArray.count)]
        } else {
            return hardArray[random() % (hardArray.count)]
        }
    }
} //End of WordsManager