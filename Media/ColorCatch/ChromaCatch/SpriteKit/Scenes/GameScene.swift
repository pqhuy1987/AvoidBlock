//
//  GameScene.swift
//  ChromaCatch
//
//  Created by Eric Internicola on 2/28/16.
//  Copyright (c) 2016 Eric Internicola. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var isAlive = true
    var score = 0
    
    var lblMain: SKLabelNode!
    var lblScore: SKLabelNode!
    var isLightColor = true
    
    let blockSpeed = 2.5
    let blockSpawnTime = 0.2
    let blockSize = CGSize(width: 15, height: 15)
    let colorChangeTime = 10.0
    var colorChangeTimeCounter = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = ColorProvider.backgroundColor
        physicsWorld.contactDelegate = self
        
        player = spawnPlayer()
        lblMain = spawnMainLabel()
        lblScore = spawnScoreLabel()
        
        // now start the timers
        darkBlockSpawnTimer()
        lightBLockSpawnTimer()
        
        changeColor()
        countdownTimer()
    }
   
    override func update(_ currentTime: TimeInterval) {
        if !isAlive {
            player.position.x = -200
        }
    }
}

// MARK: - Touch Handler
extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let dragLocation = touch.location(in: self)
            if isAlive {
                player.position.x = dragLocation.x
            } else {
                player.position.x = -200
            }
        }
    }
}

// MARK: - SKPhysicsContactDelegate Methods
extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        // Player / Light Block
        if (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.lightBlock) || (firstBody.categoryBitMask == PhysicsCategory.lightBlock && secondBody.categoryBitMask == PhysicsCategory.player) {
            if let firstNode = firstBody.node as? SKSpriteNode, let secondNode = secondBody.node as? SKSpriteNode {
                lightBlockCollision(firstNode, player: secondNode)
            }
        }
        // Player / Dark Block
        if (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.darkBlock) || (firstBody.categoryBitMask == PhysicsCategory.darkBlock && secondBody.categoryBitMask == PhysicsCategory.player) {
            if let firstNode = firstBody.node as? SKSpriteNode, let secondNode = secondBody.node as? SKSpriteNode {
                darkBlockCollision(firstNode, player: secondNode)
            }
        }
    }
}

// MARK: - Spawn Methods
extension GameScene {
    func spawnPlayer() -> SKSpriteNode {
        let player = SKSpriteNode(color: ColorProvider.offWhiteColor, size: CGSize(width: 50, height: 50))
        player.position = CGPoint(x: frame.midX, y: frame.minX + 120)
        player.name = "player"
        
        // Physics
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.darkBlock | PhysicsCategory.lightBlock
        player.physicsBody?.isDynamic = false
        
        addChild(player)
        return player
    }
    
    func spawnDarkBlock() -> SKSpriteNode {
        let darkBlock = SKSpriteNode(color: ColorProvider.offBlackColor, size: blockSize)
        darkBlock.position.x = random() * frame.maxX
        darkBlock.position.y = frame.maxY + blockSize.height * 2
        
        // Physics
        darkBlock.physicsBody = SKPhysicsBody(rectangleOf: darkBlock.size)
        darkBlock.physicsBody?.affectedByGravity = false
        darkBlock.physicsBody?.allowsRotation = false
        darkBlock.physicsBody?.isDynamic = true
        darkBlock.physicsBody?.categoryBitMask = PhysicsCategory.darkBlock
        darkBlock.physicsBody?.contactTestBitMask = PhysicsCategory.player
        darkBlock.name = "darkBlock"
        
        // Motion
        let moveDown = SKAction.moveTo(y: -100, duration: blockSpeed)
        let destroy = SKAction.removeFromParent()
        darkBlock.run(SKAction.sequence([moveDown, destroy]))
        
        addChild(darkBlock)
        return darkBlock
    }
    
    func spawnLightBlock() -> SKSpriteNode {
        let lightBlock = SKSpriteNode(color: ColorProvider.offWhiteColor, size: blockSize)
        lightBlock.position.x = random() * frame.maxX
        lightBlock.position.y = frame.maxY + blockSize.height * 2
        lightBlock.name = "lightBlock"
        
        // Physics
        lightBlock.physicsBody = SKPhysicsBody(rectangleOf: lightBlock.size)
        lightBlock.physicsBody?.affectedByGravity = false
        lightBlock.physicsBody?.allowsRotation = false
        lightBlock.physicsBody?.isDynamic = true
        lightBlock.physicsBody?.categoryBitMask = PhysicsCategory.lightBlock
        lightBlock.physicsBody?.contactTestBitMask = PhysicsCategory.player

        // Motion
        let moveDown = SKAction.moveTo(y: -100, duration: blockSpeed)
        let destroy = SKAction.removeFromParent()
        lightBlock.run(SKAction.sequence([moveDown, destroy]))
        
        addChild(lightBlock)
        return lightBlock
    }
    
    func spawnMainLabel() -> SKLabelNode {
        let mainLabel = SKLabelNode(fontNamed: "Futura")
        mainLabel.fontSize = 150
        mainLabel.fontColor = ColorProvider.offWhiteColor
        mainLabel.position = CGPoint(x: frame.midX, y: frame.maxY - mainLabel.frame.height - 150)
        mainLabel.text = "Start!"
        addChild(mainLabel)
        
        return mainLabel
    }
    
    func spawnScoreLabel() -> SKLabelNode {
        let scoreLabel = SKLabelNode(fontNamed: "Futura")
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = ColorProvider.offWhiteColor
        scoreLabel.position = CGPoint(x: frame.midX, y: 30)
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
        
        return scoreLabel
    }
}

// MARK: - Timer Methods
extension GameScene {
    func darkBlockSpawnTimer() {
        let wait = SKAction.wait(forDuration: blockSpawnTime)
        let spawn = SKAction.run {
            self.spawnDarkBlock()
        }
        run(SKAction.repeatForever(SKAction.sequence([wait, spawn])))
    }
    
    func lightBLockSpawnTimer() {
        let wait = SKAction.wait(forDuration: blockSpawnTime)
        let spawn = SKAction.run {
            self.spawnLightBlock()
        }
        run(SKAction.repeatForever(SKAction.sequence([wait, spawn])))
    }
    
    func changeColor() {
        let wait = SKAction.wait(forDuration: colorChangeTime)
        let changeColorAction = SKAction.run {
            if self.isAlive {
                self.isLightColor = !self.isLightColor
                if self.isLightColor {
                    self.changeToLightColor()
                } else {
                    self.changeToDarkColor()
                }
            }
        }
        let sequence = SKAction.sequence([wait, changeColorAction])
        run(SKAction.repeatForever(sequence))
    }
    
    func countdownTimer() {
        let wait = SKAction.wait(forDuration: 1)
        let countDown = SKAction.run {
            if self.isAlive {
                self.colorChangeTimeCounter -= 1
                if self.colorChangeTimeCounter <= 0 {
                    self.colorChangeTimeCounter = 10
                }
                self.lblMain.text = "\(self.colorChangeTimeCounter)"
            }
        }
        
        run(SKAction.repeatForever(SKAction.sequence([wait, countDown])))
    }
}

// MARK: - Helper Methods
extension GameScene {
    func changeToDarkColor() {
        player.color = ColorProvider.offBlackColor
        lblScore.fontColor = ColorProvider.offBlackColor
        lblMain.fontColor = ColorProvider.offBlackColor
    }
    
    func changeToLightColor() {
        player.color = ColorProvider.offWhiteColor
        lblScore.fontColor = ColorProvider.offWhiteColor
        lblMain.fontColor = ColorProvider.offWhiteColor
    }
    
    func lightBlockCollision(_ lightBlock: SKSpriteNode, player: SKSpriteNode) {
        if lightBlock == self.player {
            lightBlockCollision(player, player: lightBlock)
            return
        }
        
        if isLightColor {
            lightBlock.removeFromParent()
            incrementScore()
        } else {
            gameOver()
        }
    }
    
    func darkBlockCollision(_ darkBlock: SKSpriteNode, player: SKSpriteNode) {
        if darkBlock == self.player {
            darkBlockCollision(player, player: darkBlock)
            return
        }
        
        if isLightColor {
            gameOver()
        } else {
            darkBlock.removeFromParent()
            incrementScore()
        }
    }
    
    func updateScore() {
        lblScore.text = "Score: \(score)"
    }
    
    func incrementScore() {
        score += 1
        updateScore()
    }
    
    func gameOver() {
        isAlive = false
        player.removeFromParent()
        lblMain.text = "Game Over!"
        lblMain.fontSize = 50
        
        let wait = SKAction.wait(forDuration: 2)
        let gotoTitle = SKAction.run {
            if let titleScene = TitleScene(fileNamed: "TitleScene"), let view = self.view {
                view.presentScene(titleScene, transition: SKTransition.crossFade(withDuration: 1))
            }
        }
        run(SKAction.sequence([wait, gotoTitle]))
    }
}

// MARK: - Structures
extension GameScene {
    struct PhysicsCategory {
        static let player = UInt32(1 << 0)
        static let darkBlock = UInt32(1 << 1)
        static let lightBlock = UInt32(1 << 2)
    }
}
