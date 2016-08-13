//
//  LevelContent.swift
//  MagicalTypika
//
//  Created by Norma Tu on 8/4/16.
//  Copyright © 2016 NormaTu. All rights reserved.
//

import Foundation
import SpriteKit


protocol LevelContentDelegate: class {
    func spawnWord()
}

class LevelContent: SKSpriteNode {
    
    var backgroundMusic: SKAudioNode!
    
    let monster: Monster
    let song: String
    weak var delegate: LevelContentDelegate?
    
    init(color: UIColor, size: CGSize, monster: Monster, song: String) {
        
        self.monster = monster
        self.song = song
        super.init(texture: nil, color: color, size: size)

        anchorPoint = CGPoint(x: 0, y: 0)
        self.addChild(monster)
        
    }
    
    
    func levelEnded() {
        //monster died
        monster.dying()
    }
    
    
    
    // TODO: refactor actual monster attack at Monster.swift
    func startEverything() {
        
        if let musicURL = NSBundle.mainBundle().URLForResource(song, withExtension: "mp3") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            backgroundMusic.autoplayLooped = true
            
            addChild(backgroundMusic)
            
        }
        
        let wait = SKAction.waitForDuration(2) //how often to spawn a word
        
        let spawnWord = SKAction.runBlock {
            if let delegate = self.delegate {
                delegate.spawnWord()
            }
        }
        
        let keepSpawning = SKAction.repeatActionForever(SKAction.sequence([wait, spawnWord]))
        runAction(keepSpawning)
        
        let monsterAttackWait = SKAction.waitForDuration(3)
        
        let monsterAttack = SKAction.runBlock { 
            self.monster.monsterAttack()
        }
        
        let keepAttacking = SKAction.repeatActionForever(SKAction.sequence([monsterAttackWait,monsterAttack]))
        runAction(keepAttacking)
    }
    
    

    func stopEverything() {
        print("stop everythaaaaaaaaaaaaaang")
        monster.removeAllActions()
        removeAllActions()
        backgroundMusic.removeFromParent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}