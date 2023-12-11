//
//  UpdateViewModel.swift
//  ProjectApollo III
//
//  Created by userext on 07/12/23.
//

import Foundation
import SpriteKit

class UpdateViewModel: ObservableObject {
    var currentScore = 0
    var currentScoreLabel = SKLabelNode()
    
    func setSocreLabel () -> S {
        currentScoreLabel.text = "Score: \(currentScore)"
        currentScoreLabel.fontName = "Chalkduster"
        currentScoreLabel.fontSize = 40
        currentScoreLabel.fontColor = .orange
        currentScoreLabel.zPosition = 10
        currentScoreLabel.position = CGPoint(x: 750 / 2, y: 1200)
        func updateScore() {
    }
    
        currentScore += 1
        currentScoreLabel.text = "Score: \(currentScore)"
        
        makeBoss(score: currentScore)
    }
    
    func displayLives(lives: Int) {
        if lives == 3 {
            let live = SKSpriteNode(imageNamed: "3hearts.png")
            live.setScale(0.6)
            live.position = CGPoint(x: 130 , y: 1200)
            live.zPosition = 10
            addChild(live)
        }
        else if lives == 2 {
            let live = SKSpriteNode(imageNamed: "2hearts.png")
            live.setScale(0.6)
            live.position = CGPoint(x: 130 , y: 1200)
            live.zPosition = 10
            addChild(live)
        }
        else if lives == 1 {
            let live = SKSpriteNode(imageNamed: "1hearts.png")
            live.setScale(0.6)
            live.position = CGPoint(x: 130 , y: 1200)
            live.zPosition = 10
            addChild(live)
        }
        else if lives == 0 {
            let live = SKSpriteNode(imageNamed: "0hearts.png")
            live.setScale(0.6)
            live.position = CGPoint(x: 130 , y: 1200)
            live.zPosition = 10
            addChild(live)
            GameOver()
        }
    }
    func updateLives() {
        currentLives -= 1
        displayLives(lives: currentLives)
    }
}
