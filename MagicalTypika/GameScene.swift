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
    //Used to differentiate between the user's input SKLabelNode
}

class GameScene: SKScene, UITextFieldDelegate, LevelContentDelegate, MonsterDelegate, PlayerDelegate {
    
    var player: Player!
    
    //Player SFX
    let wrongSound = SKAction.playSoundFileNamed("MT_no", waitForCompletion: false)
    let attackSound = SKAction.playSoundFileNamed("MT_attack", waitForCompletion: false)
    
    //Monster SFX
    let ouchSoundMonster = SKAction.playSoundFileNamed("monOW", waitForCompletion: false)
    
    var keyboardVisible = false
    
    var oldLVL: LevelContent?
    var level: Int = 0
    var levels = [LevelContent]()  //Empty array of SKNodes
    var transitionTime: CFTimeInterval = 0.5
    var transitioning = false
    
    //var wordSpawnTimer: NSTimer!
    //var attackTimer: NSTimer!
    
    var playerWins: Bool = false
    var correct: Bool = false
    
    var stopGame: Bool = false
    var gameState: GameState = .Loading
    
    var inputText: UITextField! //will be hidden
    var wordLabel: SKLabelNode! //will be user's typed word
    var scoreLabel: SKLabelNode! //for MVP
    
    var inputBG: SKSpriteNode!
    var endScreen: SKSpriteNode!

    var spawnSpeed: Double = 10 //speed of timer's interval between falling word spawns
    var glowBall: SKSpriteNode!
        
    var wordCount: Int = 0 //total words that spawned during gameplay
    var endWPM: Int = 0
    var timePassed: Double = 0.0 //minutes
    var secondsPassed: Double = 0.0
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
            
            //~~[Increase difficulty as user gets better]~~~~~~~~
            if score % 5 == 0 {
                spawnSpeed -= 1.5 //make falling word fall faster every 5 words typed
                
                if spawnSpeed < 3 {
                    spawnSpeed = 3  //This is as fast as it'll get
                }
            }
        }
    }
    
    var theWord = "" {
        didSet {
            wordLabel.text = theWord
        }
    }
    
    var targetLabel: FallingLabelNode! //What word user is attempting
    
    //******************************************************************************************************//
    // [USER TEXT] - Handling when text changes & comparing it by first letter
    //******************************************************************************************************//
    
    func textDidChange (textField: UITextField) {
        //Makes whatever user typed go into the SKLabel
        //if there IS a value (not nil) for textField.text, then
        //unwrap it and stick it in current word
        
        if let currentWord = textField.text {
            //proccess a word
            theWord = currentWord
        } else {
            theWord = "~Type & Return~"
            
            //When user presses enter on a wrong entry?
            
        }
    }
    
    func wordCheck() {
        
        // Compares user's word by first letter to see if it
        // matches the first letter of the target falling word
        
        if let tl = getWordFromFirstLetter(wordLabel.text!) {
            targetLabel = tl
            
            //MARK: This is where PLAYER LAUNCHES ATTACK
            if targetLabel.text! == theWord {
                print("WAHOO THEY MATCH YOU DID IT.")
                
                correct = true
                
                score += 1
                player.attack()
                self.runAction(attackSound)
                flip(tl)
                
                let monster = levels[level].monster
                player.dealDamage(monster)
                monster.flinch()
                //MARK: THIS IS WHERE MONSTER GETS HIT"
                
                let wait = SKAction.waitForDuration(0.5)
                let monsterReact = SKAction.runBlock({ 
                    self.runAction(self.ouchSoundMonster)
                })
                let animateMonsterOw = SKAction.sequence([wait, monsterReact])
                self.runAction(animateMonsterOw)
                
            }
            else {
                correct = false
            }
        }
    }
    
    
    //MARK: - [DETECT MATCHING WORDS/CLEAR USER INPUT]
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        wordCheck()
        
        //PRESSING RETURN BLANKS BOTH THE LABELS AND STRING CONTENT
        if wordLabel.text != "" {
            wordLabel.text = ""
            inputText.text = ""
            
            if !correct {
            //PLAY "MT_NO"
                self.runAction(wrongSound) //DOESN'T WORK AHHHH.
//MARK: NORMA GO HERE FOR WHERE YOU LEFT OFF
            }
            
        }
        
        //PRESSING RETURN ON EMPTY STRING WON'T CRASH THE GAME ANYMORE
        if wordLabel.text == "" && inputText.text == "" {
            wordLabel.text = "~:~" //THANK YOU PLACEHOLDER STRING
            inputText.text = ""
        }
        
        return false //so keyboard won't close
    }
    
    
    //******************************************************************************************************//
    // [LEVEL MANAGEMENT] - Switching between levels using their content nodes
    //******************************************************************************************************//
    
    // TODO: - Refactor later
    
    func contentSetUpLvl() {
    
        let monsterX = player.position.x - ((view?.frame.width)!/2) //MARK: 1st Monster positioning
        let monsterY = player.position.y
        
        let monster = MonsterFactory.create("DaBug", xPosition: monsterX, yPosition: monsterY, attackTarget: player, attackBall: glowBall)!
        monster.idle()
        //monster.xScale = -1
        monster.zPosition = 1
        monster.delegate = self
        
        let level = LevelContent(color: UIColor.clearColor(), size: size,
                                 monster: monster, song: "lvlOneBGM")
        level.delegate = self

        levels.append(level)
    }
    
    func contentSetUpBoss() {
        
        let monsterX = player.position.x - ((view?.frame.width)!/1.8) //MARK: Boss Monster positioning
        let monsterY = player.position.y
        
                                                    //local variable monster
        let monster = MonsterFactory.create("DeeBug", xPosition: monsterX, yPosition: monsterY, attackTarget: player, attackBall: glowBall)!
        monster.idle()
        //monster.xScale = -1
        monster.zPosition = 1
        monster.delegate = self
        
        let level = LevelContent(color: UIColor.clearColor(), size: size,
                                 monster: monster, song: "bossLvlBGM")
        level.delegate = self
        
        levels.append(level)
    }
    
    
    func stopLVL(node: LevelContent) {
        // TODO: resets all level values so that player can play again
        
        let move = SKAction.moveToX(-size.width, duration: transitionTime) //left
        let remove = SKAction.removeFromParent()
        
        node.stopEverything()
        node.runAction(SKAction.sequence([move, remove]))
        
    }
    
    func changeLVL(node: LevelContent) {
        if let oldLVL = oldLVL {
            stopLVL(oldLVL)
        }
        
        node.position.x = size.width
        addChild(node)
        
        let moveAction = SKAction.moveToX(0, duration: transitionTime)
        
        let start =  SKAction.runBlock {
            
            node.startEverything()
            
            //self.startFight()
        }
        
        node.runAction(SKAction.sequence([moveAction, start])) //Move LVLContent node onto scene & start it
        spawnWord() //Manually spawns first word so user doesn't have to wait

        oldLVL = node
    }
        
    override func didMoveToView(view: SKView) {
        
        //Set up background
        let background = SKSpriteNode(imageNamed: "MTbackground")
        addChild(background)
        background.position.x = view.frame.width / 2
        background.position.y = view.frame.height / 2
        background.size = view.frame.size
        background.zPosition = -2
        
        //Set up correctly typed word score in background of gameplay
        scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.fontSize = 175
        addChild(scoreLabel)
        scoreLabel.position.x = view.frame.width/2
        scoreLabel.position.y = view.frame.height - (view.frame.height/3) + 20
        scoreLabel.zPosition = -1
        scoreLabel.text = "\(score)"
        scoreLabel.fontColor = UIColor(hue: 0.45, saturation: 0.75, brightness: 1, alpha: 0.25)
        
        
        
        
        //MARK: - [Setting up UITextField -> SKLabel conversion]~~~~~~~~~~~~~~~~//
        
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
        inputText.keyboardType = UIKeyboardType.ASCIICapable
        
        //Seconds of gameplay elapsed
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(GameScene.timeCount), userInfo: nil, repeats: true)
        
    }
    
    //------------------------------------------------------------------------------
    // MARK: Gameplay timer function - Divide timePassed by 60 to convert to minutes
    //------------------------------------------------------------------------------

    func timeCount() {
        /* Counter that tracks how many seconds of gameplay has passed. */
        secondsPassed += 1.0 //Will be used to calculate raw WPM
        timePassed = secondsPassed/60 //Converted to minutes
    }
    
    
    //******************************************************************************************************//
    // [Shows User Input SKLabel & its background] - as soon as the keyboard comes up
    //******************************************************************************************************//
    
    func keyboardWillShow(notification:NSNotification) {
        if keyboardVisible == true {
            return
        }
        
        let userInfo:NSDictionary = notification.userInfo!
        let keyboardFrame:NSValue = userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.CGRectValue()
        let keyboardHeight = keyboardRectangle.height
        let keyboardWidth = keyboardRectangle.width
        
        //Lets everything load first; game officially starts when keyboard appears
        gameState = .Playing
        
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
        wordLabel.text = "~Type & Return~"
        wordLabel.fontSize = 30
        addChild(wordLabel)
        
        wordLabel.horizontalAlignmentMode = .Center
        wordLabel.position.x = inputBG.size.width/2
        wordLabel.position.y = inputBG.size.height + keyboardHeight - 40
        wordLabel.zPosition = 10
        
        //MARK: [MONSTER/PLAYER ART]********************************************************************
        glowBall = SKSpriteNode(imageNamed: "ball")
        addChild(glowBall)
        
        player = PlayerFactory.create("Typika", xPosition: keyboardWidth - (keyboardWidth / 3), yPosition: keyboardHeight + keyboardHeight/4)
        addChild(player)
        
        player.zPosition = 1
        
        player.delegate = self
        
        //Load level-specific details
        contentSetUpLvl()
        contentSetUpBoss()
        
        changeLVL(levels[0]) //start with regular level
        
        keyboardVisible = true
        
    }
    
    //******************************************************************************************************//
    // [SPAWN A UNIQUE WORD] - check all other nodes to make sure all visible words start w/ diff 1st letter
    //******************************************************************************************************//
    
    
    func spawnWord() {
        
        var fallingLabel: FallingLabelNode?
        var level1flag: Bool!
        
        while fallingLabel == nil {
            
            if level == 0 {
                level1flag = true
            } else {
                level1flag = false
            }
            
            //Get a random word from Easy Array (true) or Hard Array (false) & get that first letter for the fallingLabel
            let word = WordsManager.sharedInstance.getRandomWord(level1flag)
            let firstLetter = word[word.startIndex]
            
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
            
            let fall = SKAction.moveToY(frame.height/3, duration: spawnSpeed)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([fall, remove])
            
            fallingLabel!.runAction(seq)
            wordCount += 1
        }
    }
    
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    //  [Detecting attempted falling word]  -> Returns the falling label that user is trying
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~//
    
    func getWordFromFirstLetter(word: String) -> FallingLabelNode? {
        //when user returns an empty string (backspaces an attempt & presses return on a blank entry)
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
    
    /* Flip the correctly typed word at the monster, and remove it */
    func flip(fallingLabel: FallingLabelNode) {
        
        let monster = levels[level].monster
        let monsterX = monster.position.x + monster.size.width/2 //AnchorPoint of monster image is (0,0)
        let monsterY = monster.position.y + monster.size.height/2 //center of monster image
        
        let flip = SKAction.moveTo(CGPoint(x: monsterX, y: monsterY), duration: 0.25)
        
        /* Create a node removal action */
        let remove = SKAction.removeFromParent()
        
        let boom = SKAction.runBlock {
            let boom = SKEmitterNode(fileNamed: "Boom")!
            self.addChild(boom)
            boom.zPosition = 10
            boom.position = CGPoint(x: monsterX, y: monsterY)
            let wait = SKAction.waitForDuration(0.6)
            let removeBoom = SKAction.removeFromParent()
            
            let boomSequence = SKAction.sequence([wait, removeBoom])
            boom.runAction(boomSequence)
        }
        
        /* Build sequence, flip then remove from scene */
        let sequence = SKAction.sequence([flip, remove, boom])
        fallingLabel.runAction(sequence)
        
        //Player's damage is a random number between 50-100 every time a word is flipped
        player.damage = CGFloat(arc4random_uniform(51) + 50)
        print("~~~~~damage: \(player.damage)")
    }
    
    
    
    override func willMoveFromView(view: SKView) {
        print("Will move from view happened!~~~~~~~~~~")
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func startNewGame() {
        
        //Resets the game
        let skView = self.view as SKView!
        
        let scene = MainMenu(fileNamed: "MainMenu") as MainMenu!
        scene.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    func gameOver() {
        gameState = .GameOver
        stopLVL(levels[1]) //stop boss level, destroy its levelContent node
        level = 0
        wordLabel.text = "" //Clears the "~:~" placeholder string
        
        //Hide Keyboard
        inputText.resignFirstResponder()
        
        let background = playerWins ? "endGreen" : "endRed"
        let userWin = playerWins ? true : false
        let endScreen = EndScreen(size: view!.frame.size, background: background,
                                  score: score, timePassed: timePassed,
                                  win: userWin, callBack: startNewGame)
        addChild(endScreen)
        endScreen.zPosition = 10
        endScreen.anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    func monsterDied() {
        //MARK: Player defeats level 1 monster
       
        levels[level].levelEnded()
        let wait = SKAction.waitForDuration(1)
        
        let check = SKAction.runBlock {
            self.level += 1
            
            // Player defeats level 2 BOSS monster
            if self.level == self.levels.count {
                self.level = 1 //stay on boss level
                
                // Game Over: you win!
                self.playerWins = true
                self.gameOver()
            }
            if self.playerWins == false {
                self.changeLVL(self.levels[self.level])
            }
        }
        
        runAction(SKAction.sequence([wait, check]))
    }
    
    func playerDied() {
        if gameState == .Playing && player.health <= 0 {
            
            //game over: you lose...
            player.dead() //dying animation
            
            let dying = SKAction.waitForDuration(0.6)
            
            let end = SKAction.runBlock {
                self.gameOver()
            }
            
            //Let player finish dying before going to gameOver Screen
            let seq = SKAction.sequence([dying, end])
            runAction(seq)
        }
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        /*
         for touch in touches {
         //yada yada yada implement pause button here eventually
         }
         */
    }
    
}