////
////  GameOver.swift
////  ProjectApollo III
////
////  Created by userext on 06/12/23.
////
//
//import SwiftUI
//import SpriteKit
//
//class GameOver: SKScene, View {
//    override func didMove(to view: SKView) {
//        var size = CGSize(width: 750, height: 1335)
//        let gameOver = SKLabelNode()
//        gameOver.text = "GAME OVER"
//        gameOver.fontSize = 90
//        gameOver.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        gameOver.fontColor = UIColor.orange
//        let fadeIn = SKAction.fadeIn(withDuration: 2)
//        let fade = SKAction.colorize(with: SKColor.gray, colorBlendFactor: 1.0, duration: 2.0)
//        let sequence = SKAction.sequence([fade,fadeIn])
//        addChild(gameOver)
//    }
//}
//
//struct GameOverView: View {
//    var body: some View {
//        GameOver() 
//    }
//}

//import SwiftUI
//import SpriteKit
//
//class GameOverScene: SKScene, ObservableObject {
//    override func didMove(to view: SKView) {
//        let gameOver = SKLabelNode()
//        gameOver.text = "GAME OVER"
//        gameOver.fontSize = 90
//        gameOver.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        gameOver.fontColor = UIColor.orange
//        addChild(gameOver)
//        
//        // Fade in animation
//        let fadeIn = SKAction.fadeIn(withDuration: 2)
//        gameOver.alpha = 0
//        gameOver.run(fadeIn)
//    }
//}
//
//struct GameOverView: UIViewRepresentable {
//    func makeUIView(context: Context) -> SKView {
//        let skView = SKView()
//        let scene = GameOverScene(size: CGSize(width: 750, height: 1335))
//        skView.presentScene(scene)
//        return skView
//    }
//    
//    func updateUIView(_ uiView: SKView, context: Context) {
//        // Update code here if needed
//    }
//}
//
//struct CView: View {
//    var body: some View {
//        GameOverView()
//    }
//}
//
//struct CView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
