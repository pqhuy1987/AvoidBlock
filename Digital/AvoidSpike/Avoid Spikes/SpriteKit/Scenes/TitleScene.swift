//
//  TitleScene.swift
//  Avoid Spikes
//
//  Created by Eric Internicola on 2/27/16.
//  Copyright © 2016 iColasoft. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    var btnPlay: UIButton?
    var gameTitle: UILabel?
    
    override func didMoveToView(view: SKView) {
        backgroundColor = ColorProvider.themeColor
        setupText()
    }
}

// MARK: - UI Actions
extension TitleScene {
    func playTheGame() {
        if let view = view {
            btnPlay?.removeFromSuperview()
            gameTitle?.removeFromSuperview()
            
            if let gameScene = GameScene(fileNamed: "GameScene") {
                view.ignoresSiblingOrder = true
                gameScene.scaleMode = .ResizeFill
                
                view.presentScene(gameScene, transition: SKTransition.crossFadeWithDuration(1))
            }
        }
    }
}


// MARK: - Helper Methods
extension TitleScene {
    func setupText() {
        if let view = view {
            btnPlay = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 100))
            if let btnPlay = btnPlay {
                btnPlay.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height / 2)
                btnPlay.titleLabel!.font = UIFont(name: "Futura", size: 150)
                btnPlay.setTitle("Play!", forState: .Normal)
                btnPlay.setTitleColor(ColorProvider.offBlackColor, forState: .Normal)
                btnPlay.addTarget(self, action: Selector("playTheGame"), forControlEvents: .TouchUpInside)
                view.addSubview(btnPlay)
            }
            
            gameTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
            if let gameTitle = gameTitle {
                gameTitle.textColor = ColorProvider.offWhiteColor
                gameTitle.font = UIFont(name: "Futura", size: 40)
                gameTitle.textAlignment = .Center
                gameTitle.text = "AVOID SPIKES!"
                view.addSubview(gameTitle)
            }
        }
    }
}