//
//  Monster.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/26/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

class Monster: SKSpriteNode {
    /* Instance variables */
    
    var monsterName: String = ""
    
    var healthBar: HealthBar!
    var damage: CGFloat = 0 //How much damage it can inflict
    var health: CGFloat = 100
    var totalHealth: CGFloat = 100
    
    //var attackSpeed: Double = 0 //Easy monster attacks faster, Boss attacks slower
    //var damageRange: Double = 0 //10 - 20 for easy monster, 20 - 25 for boss monster
    var monsterIMG: SKTexture!
    var target: Player!
    var glowBall: SKSpriteNode!
    
    
    init(name: String, xPos: CGFloat, yPos: CGFloat, attackTarget: Player, attackBall: SKSpriteNode) {
        
        monsterIMG = SKTexture(imageNamed: name)
        
        //SKSpriteNode's init
        super.init(texture: monsterIMG, color: UIColor.clearColor(), size: monsterIMG.size())
        
        // put your initializer content here
        self.monsterName = name
        self.position.x = xPos
        self.position.y = yPos
        self.size.width = 75
        self.size.height = 75
        
        self.target = attackTarget
        self.glowBall = attackBall
        
        self.glowBall.position.x = self.position.x
        self.glowBall.position.y = self.position.y
        self.glowBall.size.width = 30
        self.glowBall.size.height = 30
        self.glowBall.zPosition = -1
        self.glowBall.hidden = true
        
        self.healthBar = HealthBar()
        self.addChild(healthBar)
        self.healthBar.xScale = -1
        self.healthBar.zPosition = 0
        //self.healthBar.anchorPoint = CGPointMake(0.5, 0.5)

        self.healthBar.position.x = self.size.width/2 //monster w/2
        self.healthBar.position.y = self.size.height/2 +  self.size.height/3
        
        self.damage = 10
        
    }
    
    func monsterAttack() {
        
        /* Load attack action */
        let sendAttack = SKAction.moveTo(self.target.position, duration: 0.25)
        
        /* Create a node removal action */
        let reset = SKAction.runBlock {
            self.glowBall.position = self.position
            self.glowBall.hidden = true
        }
        
        /* Build sequence, flip then remove from scene */
        let sequence = SKAction.sequence([sendAttack,reset])
        self.glowBall.hidden = false
        self.glowBall.runAction(sequence)
        
        self.target.health -= self.damage
        self.target.healthBar.value = self.target.health / self.target.totalHealth
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//  [LEVEL 1 MONSTER]
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

class DaBug: Monster {
    init(name: String, xPosition: CGFloat, yPosition: CGFloat, attackTarget: Player, attackBall: SKSpriteNode) {
        
        super.init(name: name, xPos: xPosition, yPos: yPosition, attackTarget: attackTarget, attackBall: attackBall)
        
        self.health = 500
        self.totalHealth = 500
        
    }
    
    override func monsterAttack() {
        print("INSERT DABUG ATTACK HERE")
        
        super.monsterAttack()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//  [FINAL BOSS MONSTER]
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

class DeeBug: Monster {
    init(name: String, xPosition: CGFloat, yPosition: CGFloat, attackTarget: Player, attackBall: SKSpriteNode) {
        
        super.init(name: name, xPos: xPosition, yPos: yPosition, attackTarget: attackTarget, attackBall: attackBall)
       
        self.size.width = 175
        self.size.height = 175
        self.health = 1000 //~10 hits to die
        self.totalHealth = 1000
        self.glowBall.size.width = 60
        self.glowBall.size.height = 60
    }
    
    override func monsterAttack() {
        print("INSERT BOSS ATTACK HERE")
        
        super.monsterAttack()
        
        self.damage = 25
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
//  [MONSTER FACTORY] Returns monster of interest
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//

class MonsterFactory {
    static func create(monster : String, xPosition: CGFloat, yPosition: CGFloat, attackTarget: Player, attackBall: SKSpriteNode) -> Monster? {
        if monster == "DaBug" {
            return DaBug(name: "DaBug", xPosition: xPosition, yPosition: yPosition, attackTarget: attackTarget, attackBall: attackBall)
        }
        if monster == "DeeBug" {
            return DeeBug(name: "DeeBug", xPosition: xPosition, yPosition: yPosition, attackTarget: attackTarget, attackBall: attackBall)
        }
        return nil
    }
}