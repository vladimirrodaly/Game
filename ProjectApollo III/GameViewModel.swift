import SpriteKit


class GameState: ObservableObject {
    @Published var isPaused = false
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var videoNode: SKVideoNode!
    let background = SKSpriteNode(imageNamed: "nebula")
    var player = SKSpriteNode()
    var enemy = SKSpriteNode()
    var dougPower = SKSpriteNode()
    var playerFire = SKSpriteNode()
    var enimyFire = SKSpriteNode()
    var fireTimer = Timer()
    var dougTimer = Timer()
    var enemyTimer = Timer()
    var enemyFireTimer = Timer()
    var gameOver = 0
    var gameState: GameState?
    
    override func didMove(to view: SKView) {
        scene?.size = CGSize(width: 750, height: 1335)
        background.position = CGPoint(x: size.width / 2, y:  size.height / 2)
        background.setScale(1.5)
        background.zPosition = 1
        addChild(background)
        makePlayer(playerCh: 2)
        //dougPowerSpawn()
        enemyTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
        enemyFireTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(enimyFireFunc), userInfo: nil, repeats: true)
        fireTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireFunc), userInfo: nil, repeats: true)
        //   dougTimer = .scheduledTimer(timeInterval: 10, target: self, selector: #selector(dougPowerSpawn), userInfo: nil, repeats: true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            player.position.x = location.x
        }
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
    
    @objc func enimyFireFunc() {
        let moveAction = SKAction.moveTo(y: -100, duration: 2.0)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        enimyFire = .init(imageNamed: "playerShot")
        enimyFire.physicsBody = SKPhysicsBody(texture: enimyFire.texture!, size: enimyFire.texture!.size())
        enimyFire.position = enemy.position
        enimyFire.zPosition = 3
        enimyFire.setScale(4.5)
        addChild(enimyFire)
        enimyFire.run(combine)
    }
    
    @objc func makeEnemy() {
        let moveAction = SKAction.moveTo(y: -100, duration: 3)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        enemy = .init(imageNamed: "enemyShip1")
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.texture!.size())
        enemy.position = CGPoint(x: randomPoint(), y: 1200)
        enemy.zPosition = 5
        addChild(enemy)
        enemy.run(combine)
    }
    
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
    
    @objc func dougPowerSpawn() {
        let moveAction = SKAction.moveTo(y: -100, duration: 5)
        let deleteAction = SKAction.removeFromParent()
        dougPower = .init(imageNamed: "dougPower")
        dougPower.position = CGPoint(x: randomPoint() / 2, y: 1200)
        dougPower.zPosition = 11
        dougPower.setScale(0.20)
        addChild(dougPower)
        dougPower.run(moveAction)
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
        //player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.position = CGPoint(x: size.width / 2, y: 120)
        player.zPosition = 10
        player.setScale(1.1)
        addChild(player)
        
    }
    
    func toggleTimers(isPaused: Bool) {
        if isPaused {
            fireTimer.invalidate()
            dougTimer.invalidate()
            enemyTimer.invalidate()
            enemyFireTimer.invalidate()
        } else {
            enemyTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
            enemyFireTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(enimyFireFunc), userInfo: nil, repeats: true)
            fireTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireFunc), userInfo: nil, repeats: true)
            
        }
    }
    func didBeginContact(with contact: SKPhysicsContact) {
        // Verifica se os objetos que entraram em contato são o jogador e o inimigo
        if contact.bodyA.node == player && contact.bodyB.node == enemy {
            // Faz com que os objetos sumirem
            player.removeFromParent()
            enemy.removeFromParent()
        }
    }
    
    
    func randomPoint() -> Int {
        return Int.random(in: 50...1350)
    }
    
    
    func enemyColision() {
        playerFire.removeFromParent()
    }
}
extension GameScene {
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == playerFire && contact.bodyB.node == enemy {
            enemyColision()
        }
    }
}

//        let video = SKVideoNode(fileNamed: "video")
//        video.size = CGSize(width: 750, height: 1335)
//        addChild(video)
//        videoNode.position = CGPoint(x: frame.midX, y: frame.midY)
//        videoNode.play()
