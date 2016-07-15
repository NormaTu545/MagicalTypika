//
//  GameScene.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/5/16.
//  Copyright (c) 2016 NormaTu. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, UITextFieldDelegate {
    
    var inputText: UITextField! //will be hidden
    var wordLabel: SKLabelNode! //will be user's typed word
    
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
        
        //print(WordsManager.sharedInstance.arrayOfWords(true))
        
        //MARK: ~~~~~~~~~~~~ Setting up UITextField -> SKLabel conversion ~~~~~~~~~~~~~~~~//
        wordLabel = self.childNodeWithName("userWord") as! SKLabelNode //connect label from .sks file
        
        //fix origin of label to right of label box:
        wordLabel.horizontalAlignmentMode = .Right
        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width-40, height: 40)
        inputText = UITextField(frame: frame)
        inputText.font = UIFont(name: "Helvetica", size: 16)
        inputText.hidden = true //hides the text field
        
        view.addSubview(inputText) //Same as addChild in SpriteKit
        inputText.becomeFirstResponder() //Makes Keyboard appear first
        
        inputText.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), forControlEvents: .EditingChanged)
        
        //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

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