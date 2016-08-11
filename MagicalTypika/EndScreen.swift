//
//  EndScreen.swift
//  MagicalTypika
//
//  Created by Norma Tu on 8/11/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

class EndScreen: SKSpriteNode {
    let endLabel: SKLabelNode
    let wordsLabel: SKLabelNode
    let WPMLabel: SKLabelNode
    
    let okButton: ButtonNode
    
    init(size: CGSize, background: String, score: Int, timePassed: Double, win: Bool, callBack: () -> Void) {
        
        print("Initializing End Screen, win is \(win)")
        
        let texture = SKTexture(imageNamed: background)
        
        endLabel = SKLabelNode(fontNamed: "Courier New Bold")
        endLabel.fontSize = 40
        endLabel.position.x = size.width/2
        endLabel.position.y = size.height - (size.height/8)
        endLabel.zPosition = 100
        
        wordsLabel = SKLabelNode(fontNamed: "Courier New Bold")
        wordsLabel.fontSize = 30
        wordsLabel.text = "Words Typed: \(score)"
        wordsLabel.fontColor = UIColor.blackColor()
        wordsLabel.position.x = size.width/2
        wordsLabel.position.y = size.height - (size.height/4)
        wordsLabel.zPosition = 100
        
        let endWPM_double = 2 * (Double(score) / timePassed)
        let endWPM = Int(endWPM_double)
        
        WPMLabel = SKLabelNode(fontNamed: "Courier New Bold")
        WPMLabel.fontSize = 30
        WPMLabel.text = "Mobile WPM: \(endWPM)"
        WPMLabel.fontColor = UIColor.blackColor()
        WPMLabel.position.x = size.width/2
        WPMLabel.position.y = size.height - (size.height/4) - 75
        WPMLabel.zPosition = 100
        
        //MARK: [OK Button] Brings us back to main menu
        okButton = ButtonNode(normalImageNamed: "okButton", activeImageNamed: "okButton", disabledImageNamed: "okButton")
        okButton.position.x = size.width/2
        okButton.position.y = size.height/2
        okButton.zPosition = 20
            
        super.init(texture: texture, color: UIColor.clearColor(), size: size)
        
        addChild(endLabel)
        addChild(wordsLabel)
        addChild(WPMLabel)
        addChild(okButton)
        
        if win {
            showWinScreen()
        } else {
            showLoseScreen()
        }
        
        okButton.selectedHandler = {
            self.removeFromParent() //should remove the encscreen
            callBack() //Goes to Main menu
            
        }
        
    }
    
    func showWinScreen() {
            
            self.endLabel.fontColor = UIColor.init(hue: 0.47, saturation: 1, brightness: 0.5, alpha: 1)
            self.endLabel.text = "You win!"
            
            // ---------------------------------------------------------------
            //  Setup victory animation. This action is from textures 9 to 10
            // ---------------------------------------------------------------
            
            var textures = [SKTexture]()
            
            for i in 9...10 {
                let texture = SKTexture(imageNamed: "MT_\(i)")
                textures.append(texture)
            }
            
            let happyPlayer = SKSpriteNode(texture: textures[0], size: textures[0].size())
            
            happyPlayer.position.x = okButton.position.x
            happyPlayer.position.y = okButton.position.y - 100
            happyPlayer.zPosition = 20
            
            let animateHappy = SKAction.animateWithTextures(textures, timePerFrame: 0.2, resize: true, restore: false)
            let happyAction = SKAction.repeatActionForever(animateHappy)
            addChild(happyPlayer)
            happyPlayer.runAction(happyAction)
        
    }
    
    func showLoseScreen() {
        
        endLabel.fontColor = UIColor.redColor()
        endLabel.text = "You Lost..."
        
        // ---------------------------------------------------------------
        //  Setup losing animation. This action is from textures 11 to 12
        // ---------------------------------------------------------------
        
        var textures = [SKTexture]()
        
        for i in 11...12 {
            let texture = SKTexture(imageNamed: "MT_\(i)")
            textures.append(texture)
        }
        
        let losingPlayer = SKSpriteNode(texture: textures[0], size: textures[0].size())
        
        losingPlayer.position.x = okButton.position.x
        losingPlayer.position.y = okButton.position.y - 200
        losingPlayer.zPosition = 20
        addChild(losingPlayer)
        
        let animateLoser = SKAction.animateWithTextures(textures, timePerFrame: 0.2, resize: true, restore: false)
        let loserAction = SKAction.repeatActionForever(animateLoser)
        losingPlayer.runAction(loserAction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}