//
//  TitleScene.swift
//  ChromaCatch
//
//  Created by Eric Internicola on 2/28/16.
//  Copyright © 2016 Eric Internicola. All rights reserved.
//

import SpriteKit

class TitleScene: SKScene {
    
    var btnPlay: UIButton?
    var gameTitle: UILabel?
    
    override func didMove(to view: SKView) {
        backgroundColor = ColorProvider.backgroundColor
        setupText()
    }
}


// MARK: - Helper Methods
extension TitleScene {
    func setupText() {
        if let view = view {
            btnPlay = UIButton(frame: CGRect(x: 100, y: 100, width: 400, height: 100))
            if let btnPlay = btnPlay {
                btnPlay.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
                btnPlay.titleLabel?.font = UIFont(name: "Futura", size: 60)
                btnPlay.setTitle("Play!", for: UIControlState())
                btnPlay.setTitleColor(ColorProvider.offWhiteColor, for: UIControlState())
                btnPlay.addTarget(self, action: #selector(TitleScene.playTheGame), for: .touchUpInside)
                view.addSubview(btnPlay)
            }
            
            gameTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
            if let gameTitle = gameTitle {
                gameTitle.textColor = ColorProvider.offWhiteColor
                gameTitle.font = UIFont(name: "Futura", size: 40)
                gameTitle.textAlignment = .center
                gameTitle.text = "Block Got"
                view.addSubview(gameTitle)
            }
        }
    }
    
    func playTheGame() {
        if let view = view {
            view.presentScene(GameScene(), transition: SKTransition.crossFade(withDuration: 1))
            btnPlay?.removeFromSuperview()
            gameTitle?.removeFromSuperview()
            
            if let gameScene = GameScene(fileNamed: "GameScene") {
                view.ignoresSiblingOrder = true
                gameScene.scaleMode = .resizeFill
                view.presentScene(gameScene)
            }
        }
        
    }
}
