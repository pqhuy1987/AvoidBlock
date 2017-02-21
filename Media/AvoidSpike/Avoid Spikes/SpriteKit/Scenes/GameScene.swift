//
//  GameScene.swift
//  Avoid Spikes
//
//  Created by Internicola, Eric on 2/24/16.
//  Copyright (c) 2016 iColasoft. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var player: SKSpriteNode?
    var spike: SKTriangle?
    var ground: SKSpriteNode?

    var lblMain: SKLabelNode?
    var lblScore: SKLabelNode?

    var spikeSpeed = 1.0
    var isAlive = true
    var score = 0
    var location: CGPoint?
    var spikeTimeSpawnNumber = 0.3

    override func didMove(to view: SKView) {
        backgroundColor = ColorProvider.themeColor
        physicsWorld.contactDelegate = self

        spawnPlayer()
        spawnGround()

        spawnMainLabel()
        spawnScoreLabel()

        spawnSpikeTimer()
        hideLabel()
        updateScoreTimer()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            location = touch.location(in: self)
            if let player = player, let location = location, isAlive {
                player.position.x = location.x
            } else if let player = player, !isAlive {
                player.position.x = -200
            }
        }
    }
   
    override func update(_ currentTime: TimeInterval) {

    }
}


// MARK: - Spawn Functions
extension GameScene {
    func spawnPlayer() {
        player = SKSpriteNode(color: ColorProvider.offWhiteColor, size: CGSize(width: 50, height: 90))
        if let player = player {
            player.position = CGPoint(x: frame.midX, y: frame.minY + 100)
            player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.allowsRotation = false
            player.physicsBody?.isDynamic = false
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.spike

            addChild(player)
        }
    }

    func spawnSpike() {
        spike = SKTriangle.createTriangleOfSize(10, height: 70)
        
        if let spike = spike {
            spike.color = ColorProvider.offBlackColor
            spike.position.x = random() * frame.maxX
            spike.position.y = frame.maxY + spike.size.height
            spike.physicsBody = SKPhysicsBody(rectangleOf: spike.size)
            spike.physicsBody?.affectedByGravity = false
            spike.physicsBody?.allowsRotation = false
            spike.physicsBody?.isDynamic = true
            spike.physicsBody?.categoryBitMask = PhysicsCategory.spike
            spike.physicsBody?.collisionBitMask = PhysicsCategory.player

            spike.run(SKAction.moveTo(y: -200, duration: spikeSpeed))
            addChild(spike)
        }
    }

    func spawnGround() {
        ground = SKSpriteNode(color: ColorProvider.offBlackColor, size: CGSize(width: frame.width, height: 150))
        if let ground = ground {
            ground.position = CGPoint(x: frame.midX, y: frame.minY)
            addChild(ground)
        }
    }

    func spawnMainLabel() {
        lblMain = SKLabelNode(fontNamed: "Futura")
        if let lblMain = lblMain {
            lblMain.fontSize = 100
            lblMain.fontColor = ColorProvider.offWhiteColor
            lblMain.position = CGPoint(x: frame.midX, y: frame.midY+150)
            lblMain.text = "Start!"

            addChild(lblMain)
        }
    }

    func spawnScoreLabel() {
        lblScore = SKLabelNode(fontNamed: "Futura")
        if let lblScore = lblScore {
            lblScore.fontSize = 50
            lblScore.fontColor = ColorProvider.offWhiteColor
            lblScore.position = CGPoint(x: frame.midX, y: frame.minY+25)
            lblScore.text = "Start!"

            addChild(lblScore)
        }
    }
}

// MARK: - Spawn Timer Functions
extension GameScene {
    func spawnSpikeTimer() {
        let spikeTimer = SKAction.wait(forDuration: spikeTimeSpawnNumber)
        let spawn = SKAction.run {
            if self.isAlive {
                self.spawnSpike()
            }
        }
        run(SKAction.repeatForever(SKAction.sequence([spikeTimer, spawn])))
    }

    func hideLabel() {
        let wait = SKAction.wait(forDuration: 3)
        let hideLabel = SKAction.run {
            self.lblMain?.alpha = 0
        }
        run(SKAction.sequence([wait, hideLabel]))
    }

    func updateScoreTimer() {
        let wait = SKAction.wait(forDuration: 1)
        let scoreAction = SKAction.run {
            if self.isAlive {
                self.score += 1
                self.updateScore()
            }
        }
        run(SKAction.repeatForever(SKAction.sequence([wait, scoreAction])))
    }
}


// MARK: - Physics Delegate
extension GameScene : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        if (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.spike) {
            spikeCollision(firstBody.node as? SKSpriteNode, spikeTemp: secondBody.node as? SKTriangle)
        } else if (firstBody.categoryBitMask == PhysicsCategory.spike && secondBody.categoryBitMask == PhysicsCategory.player) {
            spikeCollision(secondBody.node as? SKSpriteNode, spikeTemp: firstBody.node as? SKTriangle)
        }
    }

    func spikeCollision(_ playerTemp: SKSpriteNode?, spikeTemp: SKTriangle?) {
        if let playerTemp = playerTemp, let _ = spikeTemp {
            playerTemp.removeFromParent()
            isAlive = false
            showGameOver()
        }
    }

    func showGameOver() {
        if let lblMain = lblMain {
            lblMain.alpha = 1
            lblMain.fontSize = 60
            lblMain.text = "Game Over"
        }
        waitThenMoveToTitleScene()
    }
}

// MARK: - PhysicsCategory
extension GameScene {
    struct PhysicsCategory {
        static let player = UInt32(1 << 0)
        static let spike = UInt32(1 << 1)
    }
}

// MARK: - Helper Methods
extension GameScene {
    func updateScore() {
        if let lblScore = lblScore {
            lblScore.text = "Score: \(score)"
        }
    }
    
    func waitThenMoveToTitleScene() {
        let wait = SKAction.wait(forDuration: 1)
        let transition = SKAction.run {
            if let titleScene = TitleScene(fileNamed: "TitleScene"), let view = self.view {
                view.presentScene(titleScene, transition: SKTransition.crossFade(withDuration: 1))
            }
        }
        run(SKAction.sequence([wait, transition]))
    }
}
