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
    
    let attackNoise = SKAction.playSoundFileNamed("monAttack", waitForCompletion: true)
    
    var monsterName: String = ""
    var idleAction: SKAction!
    var flinchAction: SKAction!
    var attackAction: SKAction!
    var deathAction: SKAction!
    
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
        self.glowBall.position.x = self.size.width/2
        self.glowBall.position.y = self.size.height/2
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
        
        
        // --------------------------------------------------------------
        // Setup idle animation. This action is made from textures 0 to 2
        // --------------------------------------------------------------
        
        for i in 0...2 {
            let texture = SKTexture(imageNamed: "MON_\(i)")
            textures.append(texture)
        }
        
        let animateIdle = SKAction.animateWithTextures(textures, timePerFrame: 0.05, resize: true, restore: false)
        idleAction = SKAction.repeatActionForever(animateIdle)
        
        // --------------------------------------------------------------
        // Setup flinch animation. (Monster gets hit)
        // --------------------------------------------------------------
        
        textures = []
        
        let ow = SKTexture(imageNamed: "MON_6")
        textures.append(ow)
        
        let wait = SKAction.waitForDuration(0.25) //time offset so player flinches when glowball hits player
        let owch = SKAction.animateWithTextures(textures, timePerFrame: 0.3, resize: true, restore: true)
        
        flinchAction = SKAction.sequence([wait, owch])

        // --------------------------------------------------------------
        // Setup attack animation. This is made from textures 8 to 11
        // --------------------------------------------------------------
        
        textures = []
        
        for i in 8...11 {
            let texture = SKTexture(imageNamed: "MON_\(i)")
            textures.append(texture)
        }
        
        // Make an action to play these texture frames
        let attack = SKAction.animateWithTextures(textures, timePerFrame: 0.1, resize: true, restore: true)
        
        let playAttackSound = SKAction.runBlock {
            self.runAction(self.attackNoise)
        }
        attackAction = SKAction.sequence([attack, playAttackSound])
    }
    
    func idle(){
        runAction(idleAction)
    }
    
    func flinch() {
        runAction(flinchAction)
    }
    
    func attack(){
        runAction(attackAction)
    }
    
    func dying() {
        // --------------------------------------------------------------
        // Setup death animation. (Monster gets hit)
        // --------------------------------------------------------------
        
        monsterIMG = SKTexture(imageNamed: "MON_6")
        
        let fade = SKAction.fadeOutWithDuration(0.35)
        
        self.runAction(fade)
    }
    
    func monsterAttack() {
        
        //Fix parent of glowBall
        let pt = self.parent?.convertPoint(self.position, toNode: self.glowBall.parent! )
        self.glowBall.position = pt!
        
        /* Load attack action */
        
        let waitForAnimation = SKAction.waitForDuration(0.25)
        
        let sendAttack = SKAction.moveTo(self.target.position, duration: 0.4)

        
        let animateAttack = SKAction.runBlock {
            self.attack() //Monster attacking animation
        }
            
        
        /* Create a node removal action */
        let reset = SKAction.runBlock {
            self.glowBall.position = self.position
            self.glowBall.hidden = true
        }
        
        /* Build sequence, flip then remove from scene */
        let sequence = SKAction.sequence([animateAttack, waitForAnimation, sendAttack, reset])
        self.glowBall.hidden = false
        self.glowBall.runAction(sequence)
        
        self.target.health -= self.damage
        self.target.healthBar.value = self.target.health / self.target.totalHealth
        self.target.flinch()
        //MARK: This is where PLAYER IS HIT AND SAYS OW
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
    
    override func flinch() {
        textures = []
        
        let ow = SKTexture(imageNamed: "MON_7")
        textures.append(ow)
        
        let wait = SKAction.waitForDuration(0.3) //time offset so player flinches when glowball hits player
        let owch = SKAction.animateWithTextures(textures, timePerFrame: 0.3, resize: true, restore: true)
        
        flinchAction = SKAction.sequence([wait, owch])
        super.flinch()
    }
    
    override func attack() {
        textures = []
        
        for i in 12...15 {
            let texture = SKTexture(imageNamed: "MON_\(i)")
            textures.append(texture)
        }
        
        let attack = SKAction.animateWithTextures(textures, timePerFrame: 0.15, resize: true, restore: true)
        
        attackAction = attack
        runAction(attackAction)
    }

    override func monsterAttack() {
        print("INSERT BOSS ATTACK HERE")
        
        super.monsterAttack()
        let waitForAnimation = SKAction.waitForDuration(0.25)
        let makeAttackNoise = SKAction.runBlock {
            self.runAction(self.attackNoise)
        }
        
        let bossAttack = SKAction.sequence([waitForAnimation, makeAttackNoise])
        
        self.runAction(bossAttack)
        
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