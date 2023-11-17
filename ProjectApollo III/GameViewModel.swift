import SpriteKit



// class GameState: ObservableObject {
//     @Published var isPaused: Bool = false
//
//     init() {
//             self.isPaused = false
//         }
// }

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var videoNode: SKVideoNode!
    let background = SKSpriteNode(imageNamed: "nebula")
    var player = SKSpriteNode()
    var enemy = SKSpriteNode()
    var dougPower = SKSpriteNode()
    var playerFire = SKSpriteNode()
    var enemyFire = SKSpriteNode()
    var fireTimer = Timer()
    var dougTimer = Timer()
    var enemyTimer = Timer()
    var enemyFireTimer = Timer()
    var currentScore = 0
    var currentScoreLabel = SKLabelNode()
    
    
    struct CBitmask{
        static let playerBody: UInt32 = 0b1
        static let playerAttack: UInt32 = 0b10
        static let enemyBody: UInt32 = 0b100
        static let enemyAttack: UInt32 = 0b1000
        
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        scene?.size = CGSize(width: 750, height: 1335)
        background.position = CGPoint(x: size.width / 2, y:  size.height / 2)
        background.setScale(1.5)
        background.zPosition = 1
        addChild(background)
        makePlayer(playerCh: 1)
        currentScoreLabel.text = "Score: \(currentScore)"
        currentScoreLabel.fontName = "Chalkduster"
        currentScoreLabel.fontSize = 40
        currentScoreLabel.fontColor = .orange
        currentScoreLabel.zPosition = 10
        addChild(currentScoreLabel)
        currentScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.3)
        enemyTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
        fireTimer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireFunc), userInfo: nil, repeats: true)
        enemyFireTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(enimyFireFunc), userInfo: nil, repeats: true)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contact1 : SKPhysicsBody
        let contact2 : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            contact1 = contact.bodyA
            contact2 = contact.bodyB
        } else {
            contact1 = contact.bodyB
            contact2 = contact.bodyA
        }
        if contact1.categoryBitMask == CBitmask.playerAttack && contact2.categoryBitMask == CBitmask.enemyBody {
            enemyDestroied(fire: contact1.node as! SKSpriteNode, enemy: contact2.node as! SKSpriteNode)
        }
    }
    
    func enemyDestroied(fire: SKSpriteNode, enemy: SKSpriteNode){
        fire.removeFromParent()
        enemy.removeFromParent()
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion ")
        explosion?.position = enemy.position
        explosion?.zPosition = 5
        addChild(explosion!)
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPaused {
            for touch in touches {
                let location = touch.location(in: self)
                player.position.x = location.x
            }
        }
    }
    
    
    @objc func playerFireFunc() {
        let moveAction = SKAction.moveTo(y: 1400, duration: 1)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        playerFire = .init(imageNamed: "playerShot")
        playerFire.position = player.position
        playerFire.zPosition = 3
        playerFire.setScale(5.0)
        playerFire.physicsBody = SKPhysicsBody(rectangleOf: playerFire.size)
        playerFire.physicsBody?.affectedByGravity = false
        playerFire.physicsBody?.categoryBitMask = CBitmask.playerAttack
        playerFire.physicsBody?.contactTestBitMask = CBitmask.enemyBody
        playerFire.physicsBody?.collisionBitMask = CBitmask.enemyBody
        addChild(playerFire)
        playerFire.run(combine)
    }
    
    @objc func enimyFireFunc() {
        let moveAction = SKAction.moveTo(y: -100, duration: 2.0)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        enemyFire = .init(imageNamed: "playerShot")
        enemyFire.physicsBody = SKPhysicsBody(texture: enemyFire.texture!, size: enemyFire.texture!.size())
        enemyFire.position = enemy.position
        enemyFire.zPosition = 3
        enemyFire.setScale(4.5)
        enemyFire.physicsBody = SKPhysicsBody(rectangleOf: playerFire.size)
        enemyFire.physicsBody?.affectedByGravity = false
        enemyFire.physicsBody?.categoryBitMask = CBitmask.enemyAttack
        enemyFire.physicsBody?.contactTestBitMask = CBitmask.playerBody
        enemyFire.physicsBody?.collisionBitMask = CBitmask.playerBody
        addChild(enemyFire)
        enemyFire.run(combine)
    }
    
    @objc func makeEnemy() {
        if isPaused {
            return
        }
        let moveAction = SKAction.moveTo(y: -100, duration: 3)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        enemy = .init(imageNamed: "enemyShip1")
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: enemy.texture!.size())
        enemy.position = CGPoint(x: randomPoint(), y: 1200)
        enemy.zPosition = 5
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = CBitmask.enemyBody
        enemy.physicsBody?.contactTestBitMask = CBitmask.playerBody | CBitmask.playerAttack
        enemy.physicsBody?.collisionBitMask = CBitmask.playerAttack | CBitmask.playerAttack
        addChild(enemy)
        enemy.run(combine)
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
        player.position = CGPoint(x: size.width / 2, y: 120)
        player.zPosition = 10
        player.setScale(1.5)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = CBitmask.playerBody
        player.physicsBody?.contactTestBitMask = CBitmask.enemyBody
        player.physicsBody?.collisionBitMask = CBitmask.enemyBody
        addChild(player)
    }
    
    func toggleTimers() {
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
    
    func randomPoint() -> Int {
        return Int.random(in: 50...1350)
    }
}
