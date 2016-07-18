//
//  GameScene.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/5/16.
//  Copyright (c) 2016 NormaTu. All rights reserved.
//

import SpriteKit
import UIKit

let textColors = [ UIColor.whiteColor(), UIColor.whiteColor()] //,UIColor.redColor(), UIColor.cyanColor(), UIColor.greenColor(), UIColor.whiteColor(), UIColor.whiteColor()]
let screenWidth = 320 //Number from GameScene.sks file

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
        /* Setup your scene here */
        
        //print(WordsManager.sharedInstance.getArrayOfWords(true))
        
        //MARK: ~~~~~~~~~~~~ Setting up UITextField -> SKLabel conversion ~~~~~~~~~~~~~~~~//
        wordLabel = self.childNodeWithName("userWord") as! SKLabelNode //connect label from .sks file
        
        //fix origin of label to right of label box:
        wordLabel.horizontalAlignmentMode = .Right

        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width-40, height: 40)
        inputText = UITextField(frame: frame)
        inputText.font = UIFont(name: "Helvetica", size: 16)
        inputText.hidden = true //hides the text field
        inputText.autocapitalizationType = .None
        
        view.addSubview(inputText) //Same as addChild in SpriteKit
        inputText.becomeFirstResponder() //Makes Keyboard appear first
        
        inputText.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), forControlEvents: .EditingChanged)
        
        //MARK: ~~~~~~~~~~~~ Setting up timer to spawn a falling word every 2 seconds ~~~~~~~~//
        
        //Spawn the first word so we don't have to wait for it
        spawnWord()
        //set duration between calls to function test
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(GameScene.spawnWord), userInfo: nil, repeats: true)

    }
    
    func spawnWord() {
        //spawn a random word from easyArray
        //let wordArray = WordsManager.sharedInstance.getArrayOfWords(true);
        let word = WordsManager.sharedInstance.getRandomWord(true);
        
        let fallingLabel = SKLabelNode(text: word)
        
        fallingLabel.text = word
        fallingLabel.horizontalAlignmentMode = .Left
        fallingLabel.verticalAlignmentMode = .Bottom
        
        fallingLabel.position.y = view!.frame.height
        //Constrict range for X from 0 to (width of scene - width of wordLabel)
        // let range = random() % Int(view!.frame.width - fallingLabel.frame.size.width)
        let range = random() % Int(screenWidth - Int(fallingLabel.frame.size.width))
        
        print("\(word) \(range) \(view!.frame.width) \(fallingLabel.frame.size.width)")
        
        fallingLabel.position.x = CGFloat(range)
        fallingLabel.fontColor = textColors[random() % textColors.count ]
        self.addChild(fallingLabel)
        
        let fall = SKAction.moveToY(view!.frame.height/3, duration: 7)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([fall, remove])
        
        fallingLabel.runAction(seq)
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
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
        
  

    }
}