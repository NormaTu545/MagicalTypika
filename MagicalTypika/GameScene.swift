//
//  GameScene.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/5/16.
//  Copyright (c) 2016 NormaTu. All rights reserved.
//

import SpriteKit
import UIKit

let textColors = [ UIColor.whiteColor(), UIColor.whiteColor()] //,UIColor.redColor(), UIColor.cyanColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor(), UIColor.whiteColor() ]

class FallingLabelNode: SKLabelNode {
    //used to differentiate between the user's input SKLabelNode
}

class GameScene: SKScene, UITextFieldDelegate {
    //Finding height of Keyboard

    var inputText: UITextField! //will be hidden
    var wordLabel: SKLabelNode! //will be user's typed word
    var inputBG: SKSpriteNode!
    var level: Level!
    var correct: Bool = false //used to flag if falling word was correctly typed
    //var doCheck: Bool = false //used to flag so that wordCheck happens once user presses return
    var scoreLabel:  SKLabelNode! //for MVP
    var blankTheLabel: Bool = false
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var theWord = "" {
        didSet {
            wordLabel.text = theWord
        }
    }

    var targetLabel: FallingLabelNode! //What word user is attempting
    
    func textDidChange (textField: UITextField) {
        //Makes whatever user typed go into the SKLabel
        //if there IS a value (not nil) for textField.text, then
        //unwrap it and stick it in current word
        
        if let currentWord = textField.text {
            //proccess a word
            theWord = currentWord
        } else {
            theWord = ""
        }
        
        //MARK: [DETECT MATCHING WORDS]***********************************************************
        //if doCheck {
            wordCheck()
            //doCheck = false
        //}

        if blankTheLabel {
            inputText.text = ""
            wordLabel.text = ""
            blankTheLabel = false
        }
    }
    
    func wordCheck() {
        // Compares user's word by first letter to see if it
        // matches the first letter of the target falling word
        
        if let tl = getWordFromFirstLetter(wordLabel.text!) {
            targetLabel = tl
            if targetLabel.text! == theWord {
                print("WAHOO THEY MATCH YOU DID IT.")
                score += 1
                flip(tl)
                blankTheLabel = true
            }
        }
    }
    
    //MARK: [When user hits the RETURN key]*****************************************************
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("You hit the return key")
        // checked = true  // <~~~~HERE
        
        if wordLabel.text != "" {
            wordLabel.text = ""
            //blankTheLabel = true //clear the messed up text

        }
        
        
        //wordLabel.text = "" //Blanks the User Input so they won't have to backspace everything
        //ALSO MUST BLANK THE UITEXTFIELD INPUT LABEL
        
        //doCheck = true

        return false //so keyboard won't close
    }
    
    override func didMoveToView(view: SKView) {
        //Set up background
        let background = SKSpriteNode(imageNamed: "MTbackground")
        addChild(background)
        background.position.x = view.frame.width / 2
        background.position.y = view.frame.height / 2
        background.size = view.frame.size
        background.zPosition = -2
        
        //Set up score for MVP
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.fontSize = 40
        addChild(scoreLabel)
        scoreLabel.position.x = view.frame.width - (view.frame.width/3)
        scoreLabel.position.y = view.frame.height - 50
        scoreLabel.zPosition = 10
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontColor = UIColor.cyanColor()
        
        //MARK: ~~~~~~~~~~~~[Setting up UITextField -> SKLabel conversion]~~~~~~~~~~~~~~~~//
        
        //For finding Keyboard sizes
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GameScene.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width-40, height: 40)
        inputText = UITextField(frame: frame)
        inputText.font = UIFont(name: "Courier New Bold", size: 16)
        inputText.hidden = true //hides the text field
        inputText.autocapitalizationType = .None //User starts typing in lowercase
        inputText.autocorrectionType = .No  //Disables autocorrect suggestor
        
        view.addSubview(inputText) //Like addChild in SpriteKit
        inputText.becomeFirstResponder() //Makes Keyboard appear first
        inputText.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), forControlEvents: .EditingChanged)
        inputText.delegate = self
        
        //MARK: ~~~~~~~~~~~~[ Setting up timer to spawn a falling word every 2 seconds ]~~~~~~~~//
        
        //Manually spawn the first word so we don't have to wait for it
        spawnWord()
        
        //Set 4-second delay between continuous calls to function spawnWord
        _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(GameScene.spawnWord), userInfo: nil, repeats: true)
        
        
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

    
    //******************************************************************************************************//
    // [Shows User Input SKLabel & its background] - as soon as the keyboard comes up
    //******************************************************************************************************//
    
    func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        let keyboardWidth = keyboardRectangle.width
        
        //Set up user input text's background relative to keyboard
        
        inputBG = SKSpriteNode(imageNamed: "inputBar")
        addChild(inputBG)
        inputBG.anchorPoint = CGPointMake(0, 0) //change anchor point to bottom left of the spritenode.
        inputBG.position.x = 0
        inputBG.position.y = keyboardHeight

        inputBG.size.width = keyboardWidth
        inputBG.size.height = keyboardHeight / 4
        inputBG.zPosition = 5
 
        
        //[USER INPUT WORD LABEL HERE]******************************//
        wordLabel = SKLabelNode(fontNamed: "Courier New Bold")
        wordLabel.fontSize = 40
        addChild(wordLabel)
        
        wordLabel.horizontalAlignmentMode = .Center
        wordLabel.position.x = inputBG.size.width/2
        wordLabel.position.y = inputBG.size.height + keyboardHeight - 40
        wordLabel.zPosition = 10
        
        //MARK: [TEMP ART]***************************************************************************
        
        let monster = SKSpriteNode(imageNamed: "kyubey")
        addChild(monster)
        monster.position.x = keyboardWidth/8
        monster.position.y = keyboardHeight + 90
        monster.size.width = 40
        monster.size.height = 40
        monster.zPosition = -1
        
        let typika = SKSpriteNode(imageNamed: "Sayaka")
        addChild(typika)
        typika.position.x = keyboardWidth - (keyboardWidth / 4)
        typika.position.y = keyboardHeight + 100
        typika.size.width = 75
        typika.size.height = 80
        typika.xScale = -1
        typika.zPosition = -1
    }
    
    
    //******************************************************************************************************//
    // [SPAWN A UNIQUE WORD] - check all other nodes to make sure all visible words start w/ diff 1st letter
    //******************************************************************************************************//
    

    func spawnWord() {
        
        var fallingLabel: FallingLabelNode?
        
        while fallingLabel == nil {
            //get a random word from Easy Array & get that first letter for the fallingLabel
            let word = WordsManager.sharedInstance.getRandomWord(true)
            let firstLetter  = word[word.startIndex]
            
            var foundLabel: FallingLabelNode? //For if we find another label that has same first letter
            
            for c in children {
                if let thisLabel = c as? FallingLabelNode {  //fallingLabel is a SKLabelNode Child
                    
                    let thisLabelText = thisLabel.text!
                    
                    let thisFirstChar = thisLabelText[(thisLabelText.startIndex)]
                    
                    if thisFirstChar == firstLetter {
                        foundLabel = thisLabel //found a label that has same 1st letter
                        break
                    }
                }
            }
            
            if foundLabel != nil {
                continue //go back to top of while to try spawning a unique word again
            }
            
            fallingLabel = FallingLabelNode(text: word)

            //~~[ Add label to scene, assuming label is non-null ]~~~~~~~//
            
            //Constrict range for X from 0 to half the width of the scene
            let range = random() % Int(Int(view!.frame.width) / 2 )
            
            //print("\(word) \(range) \(frame.width) \(fallingLabel.frame.size.width)")
            
            fallingLabel!.position.x = CGFloat(range)
            
            fallingLabel!.position.y = view!.frame.height
            
            fallingLabel!.horizontalAlignmentMode = .Left
            
            fallingLabel!.verticalAlignmentMode = .Bottom
            
            fallingLabel!.zPosition = 0
            
            fallingLabel!.fontName = "Courier New Bold"
            fallingLabel!.fontColor = textColors[random() % textColors.count ]
            self.addChild(fallingLabel!)
            
            let fall = SKAction.moveToY(frame.height/3, duration: 10)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([fall, remove])
            
            fallingLabel!.runAction(seq)
        }
    }

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //  [Detecting attempted falling word]  -> Returns the falling label that user is trying
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

    func getWordFromFirstLetter(word: String) -> FallingLabelNode? {
        
        if word == "" {
            return nil
        }
        
        for c in children { //look through all children
            if let fallingLabel = c as? FallingLabelNode {  //fallingLabel is a SKLabelNode Child
                //get first letter of the word if not empty string
                let letter = word[word.startIndex]
                
                //letter is user's first typed letter, compared with fallingLabel's first letter
                if letter == fallingLabel.text![fallingLabel.text!.startIndex] {
                    //user is attempting that particular fallingLabel
                    return fallingLabel
                }
            }
        }
        return nil
    }
    
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //  [Check Words to see if user typed it right]
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    //func checkWords() {
        
   // }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    
    func flip(fallingLabel: FallingLabelNode) {
        /* Flip the correctly typed word out of the screen, at the monster */
        //TODO: Refine the flip animation to flip at the monster, not offscreen to the right
        
        var actionName: String = ""
        
        actionName = "tossWord"
        
        /* Load appropriate action */
        let flip = SKAction(named: actionName)!
        
        /* Create a node removal action */
        let remove = SKAction.removeFromParent()
        
        /* Build sequence, flip then remove from scene */
        let sequence = SKAction.sequence([flip,remove])
        fallingLabel.runAction(sequence)
        
    }
    
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