import Foundation
import SpriteKit

class CollisionViewModel: ObservableObject {
    @ObservedObject var update = UpdateViewModel()
    struct CBitmask {
        static let playerBody: UInt32 = 0b1
        static let playerAttack: UInt32 = 0b10
        static let enemyBody: UInt32 = 0b100
        static let enemyAttack: UInt32 = 0b1000
        static let bossBody: UInt32 = 0b10000
        static let bossAttack: UInt32 = 0b100000
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
            playerBodyCollision(enemy: contact2.node as! SKSpriteNode, self: contact1.node as! SKSpriteNode )
            updateLives()
            
        }
        if contact1.categoryBitMask == CBitmask.playerBody && contact2.categoryBitMask == CBitmask.bossAttack {
            playerBodyCollision(enemy: contact2.node as! SKSpriteNode, self: contact1.node as! SKSpriteNode)
            updateLives()
        }
        if contact1.categoryBitMask == CBitmask.playerAttack && contact2.categoryBitMask == CBitmask.bossBody {
            contact1.node?.removeFromParent()
            bossDamaged()
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
    
    func playerBodyCollision(enemy: SKSpriteNode, self: SKSpriteNode) {
        enemy.removeFromParent()
        let explosion = SKEmitterNode(fileNamed: "EnemyExplosion ")
        explosion?.position = enemy.position
        explosion?.zPosition = 5
        explosion?.setScale(1)
        addChild(explosion!)
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
    
}
