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
    var wordLabel: SKLabelNode!
    
    var bundle: NSBundle!
    var fullArray: [String] = []
    
    var theWord = "" {
        didSet {
            wordLabel.text = theWord
        }
    }
    
    //MARK: - TEXT FIELD DELEGATE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
    
    func textDidChange (textField: UITextField) {
        theWord = textField.text!
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
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
        //MARK: ///////////// END OF WORD LIST READ & ARRAY-IFY PART //////////////////////////////////

        wordLabel = SKLabelNode(fontNamed: "Helvetica")
        addChild(wordLabel)
        wordLabel.position.x = view.frame.width - (view.frame.width / 3)
        wordLabel.position.y = view.frame.height / 3
        //fix origin of label to right of label box:
        wordLabel.horizontalAlignmentMode = .Right
        
        let frame = CGRect (x: 20, y: 20, width: view.frame.width-40, height: 40)
        inputText = UITextField(frame: frame)
        inputText.font = UIFont(name: "Helvetica", size: 16)
        inputText.textColor = UIColor.blackColor()
        inputText.hidden = true //hides the text field
        
        view.addSubview(inputText) //Same as addChild in SpriteKit
        inputText.becomeFirstResponder() //Makes Keyboard appear first
        
        inputText.addTarget(self, action: #selector(UITextInputDelegate.textDidChange(_:)), forControlEvents: .EditingChanged)
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
