import SpriteKit
import SwiftUI
import GameKit

class GameScene: SKScene, ObservableObject {
    
    private var videoNode: SKVideoNode!
    let background = SKSpriteNode(imageNamed: "nebula")
    var player = SKSpriteNode()
    var enemy = SKSpriteNode()
    //var dougPower = SKSpriteNode()
    var dougPower = SKSpriteNode()
    var playerFire = SKSpriteNode()
    var fireTimer = Timer()
    var dougTimer = Timer()
    var enemyTimer = Timer()
    
    
    override func didMove(to view: SKView) {
        scene?.size = CGSize(width: 750, height: 1335)
        background.position = CGPoint(x: size.width / 2, y:  size.height / 2)
        background.setScale(1.5)
        background.zPosition = 1
        addChild(background)
        makePlayer(playerCh: 1)
        dougPowerSpawn()
        //DougPowerz()
        enemyTimer = .scheduledTimer(timeInterval: 2, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
        fireTimer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireFunc), userInfo: nil, repeats: true)
        dougTimer = .scheduledTimer(timeInterval: 10, target: self, selector: #selector(dougPowerSpawn), userInfo: nil, repeats: true)
    }
    
    func makePlayer(playerCh: Int) {
        var shipName = ""
        
        switch playerCh {
        case 1:
            shipName = "playerShip1"
            
        case 2:
            shipName = "playerShip2"
            
        default:
            shipName = "playerShip3"
        }
        player = .init(imageNamed: shipName)
        player.position = CGPoint(x: size.width / 2, y: 120)
        player.zPosition = 10
        player.setScale(1.1)
        addChild(player)
    }
    
    @objc func playerFireFunc() {
        let moveAction = SKAction.moveTo(y: 1400, duration: 1)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        
        playerFire = .init(imageNamed: "playerShot")
        playerFire.position = player.position
        playerFire.zPosition = 3
        playerFire.setScale(4.5)
        addChild(playerFire)
        playerFire.run(combine)
    }
    
    func randomPoint() -> Int {
            return Int.random(in: 30...1400)
        }
    
    @objc func makeEnemy() {
        enemy = .init(imageNamed: "enemyShip1")
        enemy.position = CGPoint(x: randomPoint(), y: 1200)
        enemy.zPosition = 5
        addChild(enemy)
        
        let moveAction = SKAction.moveTo(y: -100, duration: 3)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        
        enemy.run(combine)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            player.position.x = location.x
        }
    }
    
    //    func DougPowerz() {
    //        dougPower = .init(imageNamed:"dougPower")
    //        dougPower.position = CGPoint(x: size.width / 2, y: 1020)
    //        dougPower.zPosition = 10
    //        dougPower.setScale(1.5)
    //        addChild(dougPower)
    //    }
    @objc func enemySpawnFunc() {
        let moveAction = SKAction.moveTo(y: 1400, duration: 1)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        
        playerFire = .init(imageNamed: "playerShot")
        playerFire.position = player.position
        playerFire.zPosition = 3
        playerFire.setScale(4.5)
        addChild(playerFire)
        playerFire.run(combine)
    }
    
    func randomPoint() -> Int {
        return Int.random(in: 30...1400)
    }
    @objc func dougPowerSpawn() {
        let moveAction = SKAction.moveTo(y: -100, duration: 5)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        
        dougPower = .init(imageNamed: "dougPower")
        dougPower.position = CGPoint(x: randomPoint() / 2, y: 1200)
        dougPower.zPosition = 11
        dougPower.setScale(0.20)
        addChild(dougPower)
        dougPower.run(moveAction)
//        addChild(playerFire)
//        playerFire.run(combine)
    }
}
//        let video = SKVideoNode(fileNamed: "video")
//        video.size = CGSize(width: 750, height: 1335)
//        addChild(video)
//        videoNode.position = CGPoint(x: frame.midX, y: frame.midY)
//        videoNode.play()
