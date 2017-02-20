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

    override func didMoveToView(view: SKView) {
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
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            location = touch.locationInNode(self)
            if let player = player, location = location where isAlive {
                player.position.x = location.x
            } else if let player = player where !isAlive {
                player.position.x = -200
            }
        }
    }
   
    override func update(currentTime: CFTimeInterval) {

    }
}


// MARK: - Spawn Functions
extension GameScene {
    func spawnPlayer() {
        player = SKSpriteNode(color: ColorProvider.offWhiteColor, size: CGSize(width: 50, height: 90))
        if let player = player {
            player.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame) + 100)
            player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
            player.physicsBody?.affectedByGravity = false
            player.physicsBody?.allowsRotation = false
            player.physicsBody?.dynamic = false
            player.physicsBody?.categoryBitMask = PhysicsCategory.player
            player.physicsBody?.contactTestBitMask = PhysicsCategory.spike

            addChild(player)
        }
    }

    func spawnSpike() {
        spike = SKTriangle.createTriangleOfSize(10, height: 70)
        
        if let spike = spike {
            spike.color = ColorProvider.offBlackColor
            spike.position.x = random() * CGRectGetMaxX(frame)
            spike.position.y = CGRectGetMaxY(frame) + spike.size.height
            spike.physicsBody = SKPhysicsBody(rectangleOfSize: spike.size)
            spike.physicsBody?.affectedByGravity = false
            spike.physicsBody?.allowsRotation = false
            spike.physicsBody?.dynamic = true
            spike.physicsBody?.categoryBitMask = PhysicsCategory.spike
            spike.physicsBody?.collisionBitMask = PhysicsCategory.player

            spike.runAction(SKAction.moveToY(-200, duration: spikeSpeed))
            addChild(spike)
        }
    }

    func spawnGround() {
        ground = SKSpriteNode(color: ColorProvider.offBlackColor, size: CGSize(width: CGRectGetWidth(frame), height: 150))
        if let ground = ground {
            ground.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame))
            addChild(ground)
        }
    }

    func spawnMainLabel() {
        lblMain = SKLabelNode(fontNamed: "Futura")
        if let lblMain = lblMain {
            lblMain.fontSize = 100
            lblMain.fontColor = ColorProvider.offWhiteColor
            lblMain.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMidY(frame)+150)
            lblMain.text = "Start!"

            addChild(lblMain)
        }
    }

    func spawnScoreLabel() {
        lblScore = SKLabelNode(fontNamed: "Futura")
        if let lblScore = lblScore {
            lblScore.fontSize = 50
            lblScore.fontColor = ColorProvider.offWhiteColor
            lblScore.position = CGPoint(x: CGRectGetMidX(frame), y: CGRectGetMinY(frame)+25)
            lblScore.text = "Start!"

            addChild(lblScore)
        }
    }
}

// MARK: - Spawn Timer Functions
extension GameScene {
    func spawnSpikeTimer() {
        let spikeTimer = SKAction.waitForDuration(spikeTimeSpawnNumber)
        let spawn = SKAction.runBlock {
            if self.isAlive {
                self.spawnSpike()
            }
        }
        runAction(SKAction.repeatActionForever(SKAction.sequence([spikeTimer, spawn])))
    }

    func hideLabel() {
        let wait = SKAction.waitForDuration(3)
        let hideLabel = SKAction.runBlock {
            self.lblMain?.alpha = 0
        }
        runAction(SKAction.sequence([wait, hideLabel]))
    }

    func updateScoreTimer() {
        let wait = SKAction.waitForDuration(1)
        let scoreAction = SKAction.runBlock {
            if self.isAlive {
                self.score += 1
                self.updateScore()
            }
        }
        runAction(SKAction.repeatActionForever(SKAction.sequence([wait, scoreAction])))
    }
}


// MARK: - Physics Delegate
extension GameScene : SKPhysicsContactDelegate {
    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        if (firstBody.categoryBitMask == PhysicsCategory.player && secondBody.categoryBitMask == PhysicsCategory.spike) {
            spikeCollision(firstBody.node as? SKSpriteNode, spikeTemp: secondBody.node as? SKTriangle)
        } else if (firstBody.categoryBitMask == PhysicsCategory.spike && secondBody.categoryBitMask == PhysicsCategory.player) {
            spikeCollision(secondBody.node as? SKSpriteNode, spikeTemp: firstBody.node as? SKTriangle)
        }
    }

    func spikeCollision(playerTemp: SKSpriteNode?, spikeTemp: SKTriangle?) {
        if let playerTemp = playerTemp, _ = spikeTemp {
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
        let wait = SKAction.waitForDuration(1)
        let transition = SKAction.runBlock {
            if let titleScene = TitleScene(fileNamed: "TitleScene"), view = self.view {
                view.presentScene(titleScene, transition: SKTransition.crossFadeWithDuration(1))
            }
        }
        runAction(SKAction.sequence([wait, transition]))
    }
}