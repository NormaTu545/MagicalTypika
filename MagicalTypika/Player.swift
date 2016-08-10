//
//  Player.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/28/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

class Player: SKSpriteNode {
    var playerName: String = "Typika"
    var playerIMG: SKTexture!
    
    var idleAction: SKAction!
    var attackAction: SKAction!
    var isAttacking = false
    
    var healthBar: HealthBar!
    var damage: CGFloat = 0
    var health: CGFloat = 700
    let totalHealth: CGFloat = 700
    
    
    init(name: String, xPos: CGFloat, yPos: CGFloat) {
        
        //MARK: Original still image set up ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        playerIMG = SKTexture(imageNamed: "MT_0") //default
        
        //SKSpriteNode's init
        super.init(texture: playerIMG, color: UIColor.clearColor(), size: playerIMG.size())
        
        // put your initializer content here
        self.playerName = name
        self.position.x = xPos
        self.position.y = yPos
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.healthBar = HealthBar()
        self.addChild(healthBar)
        self.healthBar.zPosition = 0
        self.healthBar.anchorPoint = CGPoint(x: 0, y: 0)
        self.healthBar.position.x = 0
        self.healthBar.position.y = self.size.height// + 10
        
        //Player's damage is a random number between 75-100
        self.damage = CGFloat(arc4random_uniform(76) + 75)
        
        //MARK: Sprite Animations!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
        
        var textures = [SKTexture]()
        
        // --------------------------------------------------------------
        // Setup idle action. This action is made from textures 4 to 6
        // --------------------------------------------------------------
        
        for i in 0...3 {
            let texture = SKTexture(imageNamed: "MT_\(i)")
            textures.append(texture)
        }
        
        let animateIdle = SKAction.animateWithTextures(textures, timePerFrame: 0.5, resize: true, restore: false)
        idleAction = SKAction.repeatActionForever(animateIdle)
        runAction(idleAction)
        
        // --------------------------------------------------------------
        // Setup attack action. This action is made from textures 4 to 6
        // --------------------------------------------------------------
        textures = []
        
        for i in 4...6 {
            let texture = SKTexture(imageNamed: "MT_\(i)")
            textures.append(texture)
        }
        
        // Make an action to play these texture frames
        let attack = SKAction.animateWithTextures(textures, timePerFrame: 0.15, resize: true, restore: false)
        
        let endAttack = SKAction.runBlock {
            self.texture = SKTexture(imageNamed: name)
            self.isAttacking = false
        }
        
        attackAction = SKAction.sequence([attack, endAttack])
    }
    
    func dealDamage(target: Monster) {
        target.health -= self.damage
        target.healthBar.value = target.health / target.totalHealth
    }
    
    func attack() {
        // only player is not already attacking
        if !isAttacking {
            isAttacking = true
            runAction(attackAction)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//  [PLAYER FACTORY] Returns player-character of interest. As of now only 1 character choice
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

class PlayerFactory {
    static func create(player : String, xPosition: CGFloat, yPosition: CGFloat) -> Player? {
        if player == "Typika" {
            return Player(name: "MT_0", xPos: xPosition, yPos: yPosition)
        }
        return nil
    }
}