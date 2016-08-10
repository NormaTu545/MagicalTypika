//
//  Monster.swift
//  MagicalTypika
//
//  Created by Norma Tu on 7/26/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit

protocol MonsterDelegate {
    func monsterDied()
}

class Monster: SKSpriteNode {
    /* Instance variables */
    
    var delegate: MonsterDelegate?
    
    var monsterName: String = ""
    var idleAction: SKAction!
    
    var healthBar: HealthBar!
    var damage: CGFloat = 0 //How much damage it can inflict
    var health: CGFloat = 100 {
        didSet {
            if health <= 0 {
                // This monster is dead
                if let delegate = delegate {
                    delegate.monsterDied()
                }
            }
        }
    }
    var totalHealth: CGFloat = 100
    
    //var attackSpeed: Double = 0 //Easy monster attacks faster, Boss attacks slower
    //var damageRange: Double = 0 //10 - 20 for easy monster, 20 - 25 for boss monster
    var monsterIMG: SKTexture!
    var target: Player!
    var glowBall: SKSpriteNode!
    var textures = [SKTexture]()
    
    init(name: String, xPos: CGFloat, yPos: CGFloat, attackTarget: Player, attackBall: SKSpriteNode) {
        
        monsterIMG = SKTexture(imageNamed: "MON_0")
        
        //SKSpriteNode's init
        super.init(texture: monsterIMG, color: UIColor.clearColor(), size: monsterIMG.size())
        
        // put your initializer content here
        self.monsterName = name
        self.position.x = xPos
        self.position.y = yPos
        self.size.width = 95
        self.size.height = 75
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.target = attackTarget
        self.glowBall = attackBall
        
        self.glowBall.anchorPoint = CGPoint(x: 0, y: 0)
        self.glowBall.position.x = 0 //self.position.x
        self.glowBall.position.y = 0 //self.position.y
        self.glowBall.size.width = 30
        self.glowBall.size.height = 30
        self.glowBall.zPosition = -1
        self.glowBall.hidden = true
        
        self.healthBar = HealthBar()
        self.addChild(healthBar)
        self.healthBar.zPosition = 2
        self.healthBar.anchorPoint = CGPoint(x: 0, y: 0)

        self.healthBar.position.x = 0
        self.healthBar.position.y = self.size.height + 10
        
        self.damage = 25
    }
    
    func idle(){
        
        // --------------------------------------------------------------
        // Setup idle animation. This action is made from textures 0 to 2
        // --------------------------------------------------------------
        
        for i in 0...2 {
            let texture = SKTexture(imageNamed: "MON_\(i)")
            textures.append(texture)
        }
        
        let animateIdle = SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize: true, restore: false)
        idleAction = SKAction.repeatActionForever(animateIdle)
        runAction(idleAction)
    }
    
    func monsterAttack() {
        self.glowBall.position = self.position //starting position of glowball = monster

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
        
        self.health = 400
        self.totalHealth = 400
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
       
        self.size.width = 150
        self.size.height = 85
        self.health = 600
        self.totalHealth = 600
        
        self.healthBar.position.x = 25
        self.healthBar.position.y = self.size.height + 25
        
        self.glowBall.size.width = 60
        self.glowBall.size.height = 60
    }
    
    override func idle() {
        
        textures = []
        
        // --------------------------------------------------------------
        // Setup idle action. This action is made from textures 0 to 2
        // --------------------------------------------------------------
        
        monsterIMG = SKTexture(imageNamed: "MON_3")
        
        for i in 3...5 {
            let texture = SKTexture(imageNamed: "MON_\(i)")
            textures.append(texture)
        }
        
        let animateIdle = SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize: true, restore: false)
        idleAction = SKAction.repeatActionForever(animateIdle)
        runAction(idleAction)
    }
    
    override func monsterAttack() {
        print("INSERT BOSS ATTACK HERE")
        
        super.monsterAttack()
        
        self.damage = 50
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
            return DaBug(name: "MON_0", xPosition: xPosition, yPosition: yPosition, attackTarget: attackTarget, attackBall: attackBall)
        }
        if monster == "DeeBug" {
            return DeeBug(name: "MON_3", xPosition: xPosition, yPosition: yPosition, attackTarget: attackTarget, attackBall: attackBall)
        }
        return nil
    }
}