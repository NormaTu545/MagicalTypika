//
//  GameScene.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/5/16.
//  Copyright (c) 2016 NormaTu. All rights reserved.
//

//print(WordsManager.sharedInstance.getArrayOfWords(true))

import SpriteKit
import UIKit

let textColors = [ UIColor.whiteColor(), UIColor.whiteColor()] //,UIColor.redColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.whiteColor(), UIColor.whiteColor()]

class GameScene: SKScene, UITextFieldDelegate {
    
    var inputText: UITextField! //will be hidden
    var wordLabel: SKLabelNode! //will be user's typed word
    var level: Level!
    
    var theWord = "" {
        didSet {
            wordLabel.text = theWord
        }
    }
    
    //MARK: - TEXT FIELD DELEGATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    
    func textDidChange (textField: UITextField) {
        //Makes whatever user typed go into the SKLabel
        theWord = textField.text!
    }
    
    override func didMoveToView(view: SKView) {
        
        //Set up background
        let background = SKSpriteNode(imageNamed: "background2")
        addChild(background)
        background.position.x = view.frame.width / 2
        background.position.y = view.frame.height / 2
        background.size = view.frame.size
        background.zPosition = -1
        
        //MARK: ~~~~~~~~~~~~[Setting up UITextField -> SKLabel conversion]~~~~~~~~~~~~~~~~//
        
        //[USER INPUT WORD LABEL HERE]***************************************
        wordLabel = SKLabelNode(fontNamed: "Helvetica")
        wordLabel.position.x = view.frame.width - 20
        wordLabel.position.y = view.frame.height - (view.frame.height / 3)
        //PUT WORD INPUT LABEL 2/3 DOWN THE SCREEN^
        wordLabel.fontSize = 40
        addChild(wordLabel)
        
        //fix origin of label to right of label box:
        wordLabel.horizontalAlignmentMode = .Right

        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width-40, height: 40)
        inputText = UITextField(frame: frame)
        inputText.font = UIFont(name: "Courier New Bold", size: 16)
        inputText.hidden = true //hides the text field
        inputText.autocapitalizationType = .None
        
        view.addSubview(inputText) //Same as addChild in SpriteKit
        inputText.becomeFirstResponder() //Makes Keyboard appear first
        
        inputText.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), forControlEvents: .EditingChanged)
        
        //MARK: ~~~~~~~~~~~~ Setting up timer to spawn a falling word every 2 seconds ~~~~~~~~//
        
        //Spawn the first word so we don't have to wait for it
        spawnWord()
        
        //set duration between calls to function test
        _ = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(GameScene.spawnWord), userInfo: nil, repeats: true)
        
        //getWordFromFirstLetter(inputText.text!)
        
        
        /* MITCHELL'S SCREEN FIT TEST~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        let box = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 100, height: 100))
        addChild(box)
        box.zPosition = 9999
        box.position.x = 50
        box.position.y = 450
        
        let box2 = SKSpriteNode(color: UIColor.orangeColor(), size: CGSize(width: 100, height: 100))
        addChild(box2)
        box2.zPosition = 9999
        box2.position.x = view.frame.width - 50
        box2.position.y = 450
        
        print("***************")
        print(frame.width)
        print(view.frame.width)
        print("***************")
        
        
        //let range = random() % Int(Int(frame.width) - Int(fallingLabel.frame.size.width))
        // let anotherRange = random() % Int(Int(frame.width) - Int(fallingLabel.frame.size.width))
         
        MITCHELL'S SCREEN FIT TEST~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

 
    }
    
    func spawnWord() {
        //spawn a random word from easyArray
        //let wordArray = WordsManager.sharedInstance.getArrayOfWords(true);
        let word = WordsManager.sharedInstance.getRandomWord(true)
        let anotherWord = WordsManager.sharedInstance.getRandomWord(true)
        let yetAnotherWord = WordsManager.sharedInstance.getRandomWord(true)
        let oneMoreWord = WordsManager.sharedInstance.getRandomWord(true)
        
        let firstLetterF = word[word.startIndex]
        let firstLetterN = anotherWord[anotherWord.startIndex]
        
        let fallingLabel = SKLabelNode(text: word)
        let nextLabel = SKLabelNode(text: anotherWord)
        
        //Ensure the next falling Label won't have the same starting letter
        if (firstLetterN != firstLetterF) {
            fallingLabel.text = word
            nextLabel.text = anotherWord
        } else {
            fallingLabel.text = yetAnotherWord
            nextLabel.text = oneMoreWord
        }
        
        //Constrict range for X from 0 to (width of scene - width of wordLabel)
        // let range = random() % Int(frame.width - fallingLabel.frame.size.width)
        let range = random() % Int(Int(view!.frame.width) / 2 ) //- Int(fallingLabel.frame.size.width))
        //let anotherRange = random() % Int(Int(view!.frame.width) / 4) // - Int(fallingLabel.frame.size.width))
        let anotherRange = Int(arc4random_uniform(UInt32(view!.frame.width)/4) + 20)
        
        print("\(word) \(range) \(frame.width) \(fallingLabel.frame.size.width)")
        
        fallingLabel.position.x = CGFloat(range)
        nextLabel.position.x = CGFloat(anotherRange)
        
        fallingLabel.position.y = view!.frame.height
        nextLabel.position.y = view!.frame.height / CGFloat(anotherRange)

        fallingLabel.horizontalAlignmentMode = .Left
        nextLabel.horizontalAlignmentMode = .Left
        
        fallingLabel.verticalAlignmentMode = .Bottom
        nextLabel.verticalAlignmentMode = .Bottom
        
        fallingLabel.fontName = "Courier New Bold"
        fallingLabel.fontColor = textColors[random() % textColors.count ]
        self.addChild(fallingLabel)
        
        nextLabel.fontName = "Courier New Bold"
        nextLabel.fontColor = textColors[random() % textColors.count ]
        self.addChild(nextLabel)
        
        let fall = SKAction.moveToY(frame.height/3, duration: 10)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([fall, remove])
        
        fallingLabel.runAction(seq)
        nextLabel.runAction(seq)
    }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //Currently working on detecting attempted falling word, then moving it right above user input
    func getWordFromFirstLetter(word: String) -> String? {
        for c in children { //look through all children
            if let fallingLabel = c as? SKLabelNode {  //fallingLabel is a SKLabelNode Child
                //get first letter of the word
                let letter = word[word.startIndex]
                //letter is user's first typed letter, compared with fallingLabel's first letter
                if letter == fallingLabel.text![fallingLabel.text!.startIndex] {
                    //user is attempting that fallingLabel
                    print("*******************YEP GOT IT**********************")
                    return fallingLabel.text
                }
            }
        }
        return nil
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    func setLevel(level: Level) {
        self.level = level //because Steve said so
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        /*
         for touch in touches {
         //yada yada yada

         }*/
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        //compares first letter user typed with first letter of falling words, returns text string of attempted falling word
        //getWordFromFirstLetter(inputText.text!)

    }
}