import SpriteKit
import SwiftUI

class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    private var videoNode: SKVideoNode!
    let background = SKSpriteNode(imageNamed: "nebula")
    var player = SKSpriteNode()
    var enemy = SKSpriteNode()
    var boss = SKSpriteNode()
    var powerUp = SKSpriteNode()
    var playerFire = SKSpriteNode()
    var enemyFire = SKSpriteNode()
    var bossFire = SKSpriteNode()
    var fireTimer = Timer()
    var powerUpTimer = Timer()
    var enemyTimer = Timer()
    var enemyFireTimer = Timer()
    var bossFireTimer = Timer()
    var currentScore = 0
    var currentScoreLabel = SKLabelNode()
    var currentLives = 3
    var bossLife = 15
    var bossMark = [15, 30, 50, 100]
    var bossCount = 0
    @Published var isRunning = true
    
    struct CBitmask {
        static let playerBody: UInt32 = 0b1
        static let playerAttack: UInt32 = 0b10
        static let enemyBody: UInt32 = 0b100
        static let enemyAttack: UInt32 = 0b1000
        static let bossBody: UInt32 = 0b10000
        static let bossAttack: UInt32 = 0b100000
        static let powerBody: UInt32 = 0b1000000
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
        displayLives(lives: currentLives)
        addChild(currentScoreLabel)
        currentScoreLabel.position = CGPoint(x: size.width / 2, y: 1200)
        fireTimer = .scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireFunc), userInfo: nil, repeats: true)
        enemiesTimers(isValid: true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPaused {
            for touch in touches {
                let location = touch.location(in: self)
                player.position.x = location.x
            }
        }
    }
    
    @objc func bossFireFunc() {
        let moveAction = SKAction.moveTo(y: -100, duration: 2.0)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        
        bossFire = .init(imageNamed: "bossShot")
        bossFire.physicsBody = SKPhysicsBody(circleOfRadius: bossFire.size.width / 7)
        bossFire.zPosition = 3
        bossFire.setScale(4.5)
        bossFire.position = CGPoint(x: boss.position.x - 30, y: boss.position.y - 100)
        bossFire.physicsBody?.affectedByGravity = false
        bossFire.physicsBody?.categoryBitMask = CBitmask.bossAttack
        bossFire.physicsBody?.contactTestBitMask = CBitmask.playerBody | CBitmask.playerAttack
        bossFire.physicsBody?.collisionBitMask = CBitmask.playerAttack
        addChild(bossFire)
        bossFire.run(combine)
        
    }
    
    @objc func playerFireFunc() {
        let moveAction = SKAction.moveTo(y: 1400, duration: 1)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        playerFire = .init(imageNamed: "playerShot")
        playerFire.position = CGPoint(x: player.position.x, y: player.position.y + 30)
        playerFire.zPosition = 3
        playerFire.setScale(5.0)
        playerFire.physicsBody = SKPhysicsBody(circleOfRadius: playerFire.size.width / 6)
        playerFire.physicsBody?.affectedByGravity = false
        playerFire.physicsBody?.categoryBitMask = CBitmask.playerAttack
        playerFire.physicsBody?.contactTestBitMask = CBitmask.enemyBody | CBitmask.bossBody
        playerFire.physicsBody?.collisionBitMask = CBitmask.enemyBody | CBitmask.bossBody
        addChild(playerFire)
        playerFire.run(combine)
    }
    
    @objc func enimyFireFunc() {
        let moveAction = SKAction.moveTo(y: -100, duration: 2.0)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        enemyFire = .init(imageNamed: "enimyShot")
        enemyFire.physicsBody = SKPhysicsBody(circleOfRadius: enemyFire.size.width / 6)
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
    
    @objc func makeBoss(score: Int) {
        if isRunning == true {
            for mark in bossMark {
                 if mark == score {
                    enemiesTimers(isValid: false)
                    
                    
                    boss = .init(imageNamed: "bossShip")
                    boss.position = CGPoint(x: size.width / 2, y: size.height + boss.size.height)
                    boss.zPosition = 10
                    boss.setScale(2.5)
                    boss.physicsBody = SKPhysicsBody(circleOfRadius: boss.size.width / 5)
                    boss.physicsBody?.affectedByGravity = false
                    boss.physicsBody?.categoryBitMask = CBitmask.bossBody
                    boss.physicsBody?.contactTestBitMask = CBitmask.playerBody | CBitmask.playerAttack
                    boss.physicsBody?.collisionBitMask = CBitmask.playerBody | CBitmask.playerAttack
                    addChild(boss)
                    
                    
                    let smokeMove = SKAction.moveTo(y: 1080, duration: 5)
                    let deleteAction = SKAction.removeFromParent()
                    let combine = SKAction.sequence([smokeMove,deleteAction])
                    let smoke = SKEmitterNode(fileNamed: "BossAppears")
                    smoke?.position = CGPoint(x: boss.position.x, y: boss.position.y + 80)
                    smoke?.zPosition = 5
                    smoke?.setScale(1)
                    addChild(smoke!)
                    smoke?.run(combine)
                    
                    boss.run(bossMove(bossCount: bossCount))
                    bossCount += 1
                    
                  }  
                }
            }

    }
    
    @objc func makeEnemy() {
        let moveAction = SKAction.moveTo(y: -100, duration: 3)
        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction,deleteAction])
        enemy = .init(imageNamed: "enemyShip1")
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 6)
        enemy.position = CGPoint(x: randomPoint(), y: 1200)
        enemy.zPosition = 5
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = CBitmask.enemyBody
        enemy.physicsBody?.contactTestBitMask = CBitmask.playerBody | CBitmask.playerAttack
        enemy.physicsBody?.collisionBitMask = CBitmask.playerAttack | CBitmask.playerAttack
        addChild(enemy)
        enemy.run(combine)
    }
    
    @objc func PowerSpawn() {
        if currentScore == 3 {
            let moveAction = SKAction.moveTo(y: -100, duration: 5)
            let deleteAction = SKAction.removeFromParent()
            let combine = SKAction.sequence([moveAction,deleteAction])
            var currentPowerUp = 1 //Int.random(in: 1...4)
            var powerType = ""
            switch currentPowerUp {
            case 1:
                powerType = "life"
                
            case 2:
                powerType = "powerUP1"
                
            case 3:
                powerType = "powerUp2"
                
            default:
                powerType = "powerUp3"
            }
            
            powerUp = .init(imageNamed: powerType)
            powerUp.physicsBody = SKPhysicsBody(circleOfRadius: powerUp.size.width / 6)
            powerUp.physicsBody?.categoryBitMask = CBitmask.powerBody
            powerUp.physicsBody?.contactTestBitMask = CBitmask.playerBody
            powerUp.physicsBody?.collisionBitMask = CBitmask.playerBody
            powerUp.position = CGPoint(x: randomPoint() / 2, y: 1200)
            powerUp.zPosition = 11
            powerUp.setScale(0.30)
            addChild(powerUp)
            powerUp.run(combine)
        }
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
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 6)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = CBitmask.playerBody
        player.physicsBody?.contactTestBitMask = CBitmask.enemyBody
        player.physicsBody?.collisionBitMask = CBitmask.enemyBody
        addChild(player)
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
        if contact1.categoryBitMask == CBitmask.playerAttack && contact2.categoryBitMask == CBitmask.bossAttack {
             attackCollision(enemy: contact2.node as! SKSpriteNode, self: contact1.node as! SKSpriteNode)
        }
        if contact1.categoryBitMask == CBitmask.playerBody && contact2.categoryBitMask == CBitmask.enemyAttack {
          playerBodyCollision(enemy: contact2.node as! SKSpriteNode, self: contact1.node as! SKSpriteNode)
          decreaseLives()
            
        }
        if contact1.categoryBitMask == CBitmask.playerBody && contact2.categoryBitMask == CBitmask.bossAttack {
            playerBodyCollision(enemy: contact2.node as! SKSpriteNode, self: contact1.node as! SKSpriteNode)
            decreaseLives()
        }
        if contact1.categoryBitMask == CBitmask.playerBody && contact2.categoryBitMask == CBitmask.powerBody {
            powerBodyCollision(power: contact2.node as! SKSpriteNode, self: contact1.node as! SKSpriteNode)
        
        }
        if contact1.categoryBitMask == CBitmask.playerAttack && contact2.categoryBitMask == CBitmask.bossBody {
            contact1.node?.removeFromParent()
            bossDamaged()
        }
    }
    
    func enemyDestroied(fire: SKSpriteNode, enemy: SKSpriteNode) {
        fire.removeFromParent()
        enemy.removeFromParent()
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion ")
        explosion?.position = enemy.position
        explosion?.zPosition = 5
        explosion?.setScale(1)
        addChild(explosion!)
        
    }
    
    func attackCollision(enemy: SKSpriteNode, self: SKSpriteNode) {
        enemy.removeFromParent()
        self.removeFromParent()
        
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion ")
        explosion?.position = enemy.position
        explosion?.zPosition = 5
        explosion?.setScale(1)
        addChild(explosion!)
    }
    
    func playerBodyCollision(enemy: SKSpriteNode, self: SKSpriteNode) {
        enemy.removeFromParent()
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion ")
        explosion?.position = enemy.position
        explosion?.zPosition = 5
        explosion?.setScale(1)
        addChild(explosion!)
    }
    
    
    func togglePauseTimers() {
        if isPaused {
            fireTimer.invalidate()
            powerUpTimer.invalidate()
            enemiesTimers(isValid: false)
        } else {
            enemiesTimers(isValid: true)
            fireTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(playerFireFunc), userInfo: nil, repeats: true)
        }
    }
    
    func randomPoint() -> Int {
        return Int.random(in: 35...1250)
    }
    
    func updateScore() {
        currentScore += 1
        currentScoreLabel.text = "Score: \(currentScore)"
        makeBoss(score: currentScore)
        PowerSpawn()
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
    
    func decreaseLives() {
            currentLives -= 1
            displayLives(lives: currentLives)
    }
    
    
    func bossDamaged() {
        bossLife -= 1
        
        if bossLife == 0 {
            let explosion1 = SKEmitterNode(fileNamed: "EnemyExplosion ")
            explosion1?.position = CGPoint(x: boss.position.x + 80, y: boss.position.y)
            explosion1?.zPosition = 5
            explosion1?.setScale(1)
            addChild(explosion1!)
            let explosion2 = SKEmitterNode(fileNamed: "EnemyExplosion ")
            explosion2?.position = CGPoint(x: boss.position.x - 80, y: boss.position.y)
            explosion2?.zPosition = 5
            explosion2?.setScale(1)
            addChild(explosion2!)
            let moveAction = SKAction.moveTo(y: -100, duration: 3)
            let deleteAction = SKAction.removeFromParent()
            let combine = SKAction.sequence([moveAction,deleteAction])
            boss.run(combine)
            updateScore()
            enemiesTimers(isValid: true)
            bossLife = 15
        }
    }
    
    func enemiesTimers(isValid: Bool) {
        if isValid == true {
            enemyTimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(makeEnemy), userInfo: nil, repeats: true)
            enemyFireTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(enimyFireFunc), userInfo: nil, repeats: true)
            bossFireTimer.invalidate()
        }
        else {
            enemyTimer.invalidate()
            enemyFireTimer.invalidate()
            bossFireTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(bossFireFunc), userInfo: nil, repeats: true)

        }
    }
    

    func bossMove(bossCount: Int) -> SKAction {
        var bossMove = SKAction.moveTo(y: 1000, duration: 5)
        let moveRight = SKAction.moveTo(x: size.width - boss.size.width / 2,  duration: 2)
        let moveLeft = SKAction.moveTo(x: 0 + boss.size.width / 2, duration: 2)
        let moveCenter = SKAction.moveTo(x: size.width / 2, duration: 1.5)
        let repeatForever = SKAction.repeatForever(SKAction.sequence([moveLeft,moveRight,moveCenter]))
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let bossTackle = SKAction.moveTo(y: 0 + boss.size.height / 2, duration: 1.5)
        let bossReturn = SKAction.moveTo(y: 1000, duration: 2)
        let fading = SKAction.sequence([fadeOut,fadeIn])
        let sequence = SKAction.repeatForever(SKAction.sequence([moveLeft,moveRight,moveCenter,fading,bossTackle,bossReturn]))
        
        if bossCount == 1 {
            bossMove = SKAction.sequence([bossMove,repeatForever])
            
        }
        if bossCount == 2 {
            bossMove = SKAction.sequence([bossMove,sequence])
        }
      
        if bossCount > 2 {
            bossMove = SKAction.sequence([bossMove,sequence])
            bossLife = 25
        }
        
       return bossMove
    }
    
    func GameOver() {
        removeAllChildren()
        enemiesTimers(isValid: false)
        fireTimer.invalidate()
        isRunning = false
        
        let gameOverLabel = SKLabelNode()
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 90
        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        gameOverLabel.fontColor = UIColor.orange
        
        addChild(gameOverLabel)
    }

    
    func powerBodyCollision(power: SKSpriteNode, self: SKSpriteNode) {
        powerUp.removeFromParent()
        powerON(currentPower: 1)
    }
    
    func powerON(currentPower: Int) {
        if currentPower == 1 {
            increaseLives()
        }
    }
    func increaseLives() {
        currentLives += 1
        displayLives(lives: currentLives)
    }
}
