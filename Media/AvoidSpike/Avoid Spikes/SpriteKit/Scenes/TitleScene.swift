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
    
    override func didMove(to view: SKView) {
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
                gameScene.scaleMode = .resizeFill
                
                view.presentScene(gameScene, transition: SKTransition.crossFade(withDuration: 1))
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
                btnPlay.setTitle("Play!", for: UIControlState())
                btnPlay.setTitleColor(ColorProvider.offBlackColor, for: UIControlState())
                btnPlay.addTarget(self, action: #selector(TitleScene.playTheGame), for: .touchUpInside)
                view.addSubview(btnPlay)
            }
            
            gameTitle = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
            if let gameTitle = gameTitle {
                gameTitle.textColor = ColorProvider.offWhiteColor
                gameTitle.font = UIFont(name: "Futura", size: 40)
                gameTitle.textAlignment = .center
                gameTitle.text = "AVOID SPIKES!"
                view.addSubview(gameTitle)
            }
        }
    }
}
