import SpriteKit



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
    var currentLives = [SKSpriteNode]()
    
    
    struct CBitmask {
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
        makePlayer(playerCh: 3)
        currentScoreLabel.text = "Score: \(currentScore)"
        currentScoreLabel.fontName = "Chalkduster"
        currentScoreLabel.fontSize = 40
        currentScoreLabel.fontColor = .orange
        currentScoreLabel.zPosition = 10
        addChild(currentScoreLabel)
        currentScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.3)
        enemyTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
        fireTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(playerFireFunc), userInfo: nil, repeats: true)
        enemyFireTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(enimyFireFunc), userInfo: nil, repeats: true)
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
        
        // Ataque do player atinge inimigo
        if contact1.categoryBitMask == CBitmask.playerAttack && contact2.categoryBitMask == CBitmask.enemyBody {
            enemyDestroied(fire: contact1.node as! SKSpriteNode, enemy: contact2.node as! SKSpriteNode)
            updateScore()
        }
        // Ataques colidem
        if contact1.categoryBitMask == CBitmask.playerAttack && contact2.categoryBitMask == CBitmask.enemyAttack {
            attackCollision(enemy: contact2.node as! SKSpriteNode, self: contact1.node as! SKSpriteNode)
        }
    }
    
    func enemyDestroied(fire: SKSpriteNode, enemy: SKSpriteNode){
        fire.removeFromParent()
        enemy.removeFromParent()
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion ")
        explosion?.position = enemy.position
        explosion?.zPosition = 5
        explosion?.setScale(1)
        addChild(explosion!)
        
    }
    
    func attackCollision(enemy: SKSpriteNode, self: SKSpriteNode){
        enemy.removeFromParent()
        self.removeFromParent()
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion ")
        explosion?.position = enemy.position
        explosion?.zPosition = 5
        explosion?.setScale(1)
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
        playerFire.position = CGPoint(x: player.position.x, y: player.position.y + 30)
        playerFire.zPosition = 3
        playerFire.setScale(5.0)
        playerFire.physicsBody = SKPhysicsBody(circleOfRadius: playerFire.size.width / 5)
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
        enemyFire = .init(imageNamed: "enimyShot")
        enemyFire.physicsBody = SKPhysicsBody(circleOfRadius: enemyFire.size.width / 5)
        enemyFire.zPosition = 3
        enemyFire.setScale(4.5)
        enemyFire.position = CGPoint(x: enemy.position.x, y: enemy.position.y - 30)
        enemyFire.physicsBody?.affectedByGravity = false
        enemyFire.physicsBody?.categoryBitMask = CBitmask.enemyAttack
        enemyFire.physicsBody?.contactTestBitMask = CBitmask.playerBody | CBitmask.playerAttack
        enemyFire.physicsBody?.collisionBitMask = CBitmask.playerBody | CBitmask.playerAttack
        addChild(enemyFire)
        enemyFire.run(combine)
    }
    
    @objc func makeEnemy() {
        let moveAction = SKAction.moveTo(y: -100, duration: 3)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        enemy = .init(imageNamed: "enemyShip1")
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 5)
        enemy.position = CGPoint(x: randomPoint(), y: 1200)
        enemy.zPosition = 5
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = CBitmask.enemyBody
        enemy.physicsBody?.contactTestBitMask = CBitmask.playerBody | CBitmask.playerAttack
        enemy.physicsBody?.collisionBitMask = CBitmask.playerBody | CBitmask.playerAttack
        addChild(enemy)
        enemy.run(combine)
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
        dougPower.run(combine)
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
        player.setScale(1.3)
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 5)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = CBitmask.playerBody
        player.physicsBody?.contactTestBitMask = CBitmask.enemyBody
        player.physicsBody?.collisionBitMask = CBitmask.enemyBody
        addChild(player)
        
        displayLives(lives: 3, shipName: shipName)
    }
    
    func togglePauseTimers() {
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
        return Int.random(in: 35...1265)
    }
    
    func updateScore() {
        currentScore += 1
        currentScoreLabel.text = "Score: \(currentScore)"
    }
    
    func displayLives(lives: Int, shipName: String) {
        for i in 1...lives {
            let live = SKSpriteNode(imageNamed: shipName)
            live.setScale(0.5)
            live.position = CGPoint(x: CGFloat(i) * live.size.width * 0.75, y: size.height - live.size.height - 10)
            live.zPosition = 10
            live.name = "Live\(live)"
            currentLives.append(live)
            addChild(live)
        }
    }
}
