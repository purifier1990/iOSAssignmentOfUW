//
//  GameScene.swift
//  planeFight
//
//  Created by wenyu zhao on 2018/8/3.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {
    private var player:AVAudioPlayer?
    private var heroHPCount = 3
    private var heroHPTokens = [SKElementNode]()
    private let tokenSpan = 30
    private var hero = SKElementNode.init(type: .hero)
    private var heroBlowAction:SKAction?
    private var heroRecoverAction:SKAction?
    private var monsters = [SKElementNode]()
    private var smallEnemyBlowAction:SKAction?
    private var midEnemyBlowAction:SKAction?
    private var bigEnemyBlowAction:SKAction?
    private var boss = SKElementNode.init(type: .boss)
    private var arms = [SKElementNode]()
    private var monsterBullets = [SKSpriteNode]()
    lazy private var armSoundAction = { () -> SKAction in
        let action = SKAction.playSoundFileNamed("shoot.mp3", waitForCompletion: false)
        return action
    }()
    private var shouldMove = false
    private var supply = TextureManager.shared.node(.supply)
    private var totalGeneratedMonsterCount = 0
    private var score = 0
    private var scorLb:SKLabelNode?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(size: CGSize) {
        super.init(size: size)
        setup()
        addNodes()
        addMonsters()
        setupAnimation()
    }
    
    private func setup() {
        backgroundColor = .white
        let bgNode = SKSpriteNode.init(imageNamed: "bg")
        bgNode.position = .zero
        bgNode.zPosition = 0
        bgNode.anchorPoint = .zero
        bgNode.size = size
        addChild(bgNode)
        
        guard let path = Bundle.main.path(forResource: "bgm", ofType: "mp3") else {
            return
        }
        let url = URL.init(fileURLWithPath: path)
        do{
            try player = AVAudioPlayer.init(contentsOf: url)
        }catch let e {
            print(e.localizedDescription)
            return
        }
        player?.numberOfLoops = -1
        player?.volume = 0.8
        player?.prepareToPlay()
        player?.play()
    }
    
    func setupAnimation() {
        var texturesOfSmall:[SKTexture] = []
        for i in 1...2 {
            texturesOfSmall.append(SKTexture(imageNamed: "smallEnemyBlow\(i)"))
        }
        smallEnemyBlowAction = SKAction.animate(with: texturesOfSmall,
                                                timePerFrame: 0.1)
        var texturesOfMid:[SKTexture] = []
        for i in 1...3 {
            texturesOfMid.append(SKTexture(imageNamed: "midEnemyBlow\(i)"))
        }
        midEnemyBlowAction = SKAction.animate(with: texturesOfMid,
                                                timePerFrame: 0.1)
        var texturesOfBig:[SKTexture] = []
        for i in 1...5 {
            texturesOfBig.append(SKTexture(imageNamed: "bigEnemyBlow\(i)"))
        }
        bigEnemyBlowAction = SKAction.animate(with: texturesOfBig,
                                              timePerFrame: 0.1)
        var texturesOfHero:[SKTexture] = []
        for i in 1...3 {
            texturesOfHero.append(SKTexture(imageNamed: "heroBlow\(i)"))
        }
        heroBlowAction = SKAction.animate(with: texturesOfHero,
                                          timePerFrame: 0.1)
        
        var texturesOfHeroRecover:[SKTexture] = []
        texturesOfHeroRecover.append(SKTexture(imageNamed: "hero"))
        heroRecoverAction = SKAction.animate(with: texturesOfHeroRecover,
                                             timePerFrame: 0.1)
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    private func score(_ withType:SKTextureType) -> Int {
        if withType == .smallEnemy {
            return 1
        }else if withType == .midEnemy {
            return 2
        }else if withType == .bigEnemy {
            return 3
        }else if withType == .boss {
            return 5
        }else {
            return 0
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if hero.parent == nil {
            hero.run(heroRecoverAction!)
            addHero()
            hero.shouldShoot = true
        }
        for monsterBullet in monsterBullets {
            if monsterBullet.frame.intersects(hero.frame) {
                monsterBullet.removeFromParent()
                hero.shouldShoot = false
                hero.run(heroBlowAction!) {
                    self.hero.removeAllActions()
                    self.hero.removeFromParent()
                }
                let monsterBulletIndex = monsterBullets.index(of: monsterBullet)
                if monsterBulletIndex != nil {
                    monsterBullets.remove(at: monsterBulletIndex!)
                }
                heroHPCount -= 1
                heroHPTokens.last?.removeFromParent()
                heroHPTokens.removeLast()
                if heroHPCount == 0 {
                    gameOver()
                    return
                }
            }
        }
        for monster in monsters {
            if monster.frame.intersects(hero.frame) {
                if monster.type == .smallEnemy {
                    monster.run(SKAction.sequence([
                        smallEnemyBlowAction!,
                        SKAction.removeFromParent()
                    ]))
                } else if monster.type == .midEnemy {
                    monster.run(SKAction.sequence([
                        midEnemyBlowAction!,
                        SKAction.removeFromParent()
                    ]))
                } else if monster.type == .bigEnemy {
                    monster.run(SKAction.sequence([
                        bigEnemyBlowAction!,
                        SKAction.removeFromParent()
                    ]))
                }
                hero.shouldShoot = false
                hero.run(heroBlowAction!) {
                    self.hero.removeAllActions()
                    self.hero.removeFromParent()
                }
                let monsterindex = monsters.index(of: monster)
                if monsterindex != nil {
                    monsters.remove(at: monsterindex!)
                }
                heroHPCount -= 1
                heroHPTokens.last?.removeFromParent()
                heroHPTokens.removeLast()
                if heroHPCount == 0 {
                    gameOver()
                    return
                }
            }
            for arm in arms {
                if arm.frame.intersects(monster.frame) {
                    //remove bullet
                    arm.removeFromParent()
                    let armindex = arms.index(of: arm)
                    if armindex != nil {
                        arms.remove(at: armindex!)
                    }
                    //refresh hp
                    if(monster.alive()) {
                        monster.hp -= 1
                        if monster.alive() {
                            continue
                        }
                    }
                    //if not alive, remove mosnter
                    if monster.type == .smallEnemy {
                        monster.run(SKAction.sequence([
                            smallEnemyBlowAction!,
                            SKAction.removeFromParent()
                        ]))
                    } else if monster.type == .midEnemy {
                        monster.run(SKAction.sequence([
                            midEnemyBlowAction!,
                            SKAction.removeFromParent()
                        ]))
                    } else if monster.type == .bigEnemy {
                        monster.run(SKAction.sequence([
                            bigEnemyBlowAction!,
                            SKAction.removeFromParent()
                        ]))
                    } else {
                        boss.removeAllActions()
                        boss.run(SKAction.sequence([
                            bigEnemyBlowAction!,
                            SKAction.removeFromParent()
                        ]))
                    }
                    let monsterindex = monsters.index(of: monster)
                    if monsterindex != nil {
                        monsters.remove(at: monsterindex!)
                    }
                    //refresh score
                    score += score(monster.type)
                    scorLb?.text = String(score)
                }
            }
        }
        if supply.parent != nil {
            if supply.frame.intersects(hero.frame) {
                supply.removeFromParent()
                removeAction(forKey: "supply_key")
                hero.buff = .doubleBullet
                let last = SKAction.wait(forDuration: 15)
                let reset = SKAction.run {
                    self.hero.buff = .none
                }
                let sequnce = SKAction.sequence([last,reset])
                run(sequnce, withKey: "supply_key")
            }
        }
    }
}

extension GameScene {
    private func addNodes() {
        addHero()
        weak var wkself = self
        let shootAction = SKAction.run {
            wkself?.shoot()
        }
        let wait = SKAction.wait(forDuration: 0.2)
        let sequenceAction = SKAction.sequence([shootAction,wait])
        let repeatShootAction = SKAction.repeatForever(sequenceAction)
        run(repeatShootAction)
        addScoreLb()
        addHeroHPToken()
    }
    private func addScoreLb() {
        scorLb = SKLabelNode.init(fontNamed: "Chalkduster")
        scorLb?.text = "0"
        scorLb?.fontSize = 20
        scorLb?.fontColor = .black
        scorLb?.position = .init(x: 50, y: size.height - 40)
        scorLb?.zPosition = 30
        addChild(scorLb!)
    }
    private func addHeroHPToken() {
        for i in 1...heroHPCount {
            let token = SKElementNode.init(type: .heroToken)
            token.setScale(0.5)
            token.position = CGPoint(x: (scorLb?.position.x)! + CGFloat(tokenSpan * i), y: size.height - 30)
            token.zPosition = 30
            addChild(token)
            heroHPTokens.append(token)
        }
    }
    private func addHero() {
        hero.position = CGPoint(x: size.width/2, y: hero.size.height/2)
        hero.setScale(0.5)
        hero.name = "hero"
        hero.zPosition = 30
        addChild(hero)
    }
    private func shoot() {
        guard hero.shouldShoot else {
            return
        }
        if hero.buff == .none {
            let armsNode = SKElementNode.init(type: .bullet)
            armsNode.setScale(0.5)
            armsNode.position = hero.position
            armsNode.zPosition = 30
            addChild(armsNode)
            arms.append(armsNode)
            let distance = size.height - armsNode.position.y
            let speed = size.height
            let duration = distance/speed
            let moveAction = SKAction.moveTo(y: size.height, duration: TimeInterval(duration))
            weak var wkarms = armsNode
            weak var wkself = self
            let group = SKAction.group([moveAction,armSoundAction])
            armsNode.run(group, completion: {
                wkarms?.removeFromParent()
                let index = wkself?.arms.index(of: wkarms!)
                if index != nil {
                    wkself?.arms.remove(at: index!)
                }
            })
        } else if hero.buff == .doubleBullet {
            let bullet1 = SKElementNode.init(type: .bullet)
            bullet1.setScale(0.5)
            bullet1.position = .init(x: hero.position.x - hero.size.width/4, y: hero.position.y)
            bullet1.zPosition = 30
            addChild(bullet1)
            let bullet2 = SKElementNode.init(type: .bullet)
            bullet2.setScale(0.5)
            bullet2.position = .init(x: hero.position.x + hero.size.width/4, y: hero.position.y)
            bullet2.zPosition = 30
            addChild(bullet2)
            arms.append(bullet1)
            arms.append(bullet2)
            
            let distance = size.height - bullet1.position.y
            let speed = size.height
            
            let duration = distance/speed
            let moveAction = SKAction.moveTo(y: size.height, duration: TimeInterval(duration))
            weak var wkbullet1 = bullet1
            weak var wkbullet2 = bullet2
            weak var wkself = self
            
            let group = SKAction.group([moveAction,armSoundAction])
            bullet1.run(group, completion: {
                wkbullet1?.removeFromParent()
                let index = wkself?.arms.index(of: wkbullet1!)
                if index != nil {
                    wkself?.arms.remove(at: index!)
                }
            })
            bullet2.run(moveAction, completion: {
                wkbullet2?.removeFromParent()
                let index = wkself?.arms.index(of: wkbullet2!)
                if index != nil {
                    wkself?.arms.remove(at: index!)
                }
            })
        }
    }
    private func addMonsters() {
        weak var wkself = self
        let addMonsterAction = SKAction.run {
            wkself?.generateMonster()
        }
        let waitAction = SKAction.wait(forDuration: 0.8)
        let bgSequence = SKAction.sequence([addMonsterAction,waitAction])
        let repeatAction = SKAction.repeatForever(bgSequence)
        run(repeatAction)
    }
    private func generateMonster() {
        showSupplyeIfNeed()
        if boss.parent != nil {
            return
        }
        if totalGeneratedMonsterCount % 80 == 0 && totalGeneratedMonsterCount > 0 {
            bossShow()
            return
        }
        weak var wkself = self
        let minduration:Int = 4
        let maxduration:Int = 5
        var duration = Int(arc4random_uniform((UInt32(maxduration - minduration)))) + minduration
        var bulletCount = 0
        var enemyType:SKTextureType = .smallEnemy
        if totalGeneratedMonsterCount == 0 {
            enemyType = .smallEnemy
        }else if totalGeneratedMonsterCount % 10 == 0 && totalGeneratedMonsterCount % 20 != 0 {
            enemyType = .midEnemy
            duration = maxduration
            bulletCount = 2
        }else if totalGeneratedMonsterCount % 20 == 0 {
            enemyType = .bigEnemy
            duration = maxduration
            bulletCount = 4
        }else{
            enemyType = .smallEnemy
        }
        let monster = SKElementNode.init(type: enemyType)
        let minx:Int = Int(monster.size.width / 2)
        let maxx:Int = Int(size.width - monster.size.width / 2)
        let gapx:Int = maxx - minx
        let xpos:Int = Int(arc4random_uniform(UInt32(gapx))) + minx
        monster.position = .init(x: CGFloat(xpos), y: (size.height + monster.size.height/2))
        monster.setScale(0.5)
        monster.zPosition = 30
        addChild(monster)
        totalGeneratedMonsterCount += 1
        monsters.append(monster)
        
        if bulletCount > 0 {
            monsterShoot(monster: monster, bulletCount: bulletCount, shootDuration: 0.5, dismisDuration: duration)
        }

        let moveAction = SKAction.moveTo(y: -monster.size.height/2, duration: TimeInterval(duration))

        let removeAction = SKAction.run {
            monster.removeFromParent()
            let index = wkself?.monsters.index(of: monster)
            if index != nil {
                wkself?.monsters.remove(at: index!)
            }
        }
        
        monster.run(SKAction.sequence([moveAction,removeAction]))
    }
    private func showSupplyeIfNeed() {
        if arc4random_uniform(100) < 96 {
            return
        }
        if supply.parent != nil {
            return
        }
        let supplyx = CGFloat(arc4random_uniform(UInt32(size.width - supply.size.width))) + supply.size.width/2
        supply.removeAllActions()
        supply.position = .init(x: supplyx, y: size.height + size.height + supply.size.height/2)
        supply.zPosition = 30
        supply.setScale(0.5)
        addChild(supply)
        let move = SKAction.moveTo(y: -supply.size.height/2, duration: TimeInterval(5))
        supply.run(move, completion: {
            self.supply.removeFromParent()
        })
    }
    private func bossShow() {
        let reference = score/100
        if monsters.count > 0 {
            monsters.forEach{
                $0.removeFromParent()
            }
            monsters.removeAll()
        }
        boss.removeAllActions()
        hero.shouldShoot = false
        boss.position = .init(x: size.width/2, y: size.height + boss.size.height/2)
        boss.setScale(0.5)
        boss.zPosition = 30
        addChild(boss)
        monsters.append(boss)
        let hp = 80+reference * 10
        boss.hp = UInt(hp)
        let monsterShootDuration = 0.5 - 0.01 * CGFloat(reference)
        totalGeneratedMonsterCount += 1
        let bossAppearWait = SKAction.wait(forDuration: 3)
        let appear = SKAction.moveTo(y: size.height-boss.size.height/2, duration: 3)
        SKAction.sequence([bossAppearWait, appear])
        let center2Left = SKAction.moveTo(x: boss.size.width/2, duration: 3)
        weak var wkself = self
        let heroOn = SKAction.run {
            wkself?.hero.shouldShoot = true
        }
        let move2Right = SKAction.moveTo(x: size.width - boss.size.width/2, duration: 6)
        let move2Left = SKAction.moveTo(x: boss.size.width/2, duration: 6)
        let moveRepeat = SKAction.repeatForever(SKAction.sequence([move2Right,move2Left]))
        let move = SKAction.sequence([center2Left,moveRepeat])
        let group1 = SKAction.group([move, heroOn])

        let bossShoot = SKAction.run({
            wkself?.monsterShoot(monster: wkself!.boss, bulletCount: 6, shootDuration: TimeInterval(monsterShootDuration), dismisDuration: 3)
        })
        let boosShootWait = SKAction.wait(forDuration: 4)
        let repeatShoot = SKAction.repeatForever(SKAction.sequence([bossShoot, boosShootWait]))
        let group2 = SKAction.group([group1,repeatShoot])
        boss.run(SKAction.sequence([appear, group2]))
    }
    private func monsterShoot(monster:SKSpriteNode, bulletCount:Int, shootDuration:TimeInterval,dismisDuration:Int) {
        weak var wkself = self
        let wait = SKAction.wait(forDuration: shootDuration)
        let shoot = SKAction.run {
            if monster.parent == nil {
                return
            }
            let bullet = SKSpriteNode.init(imageNamed: "monster_bullet")
            bullet.zPosition = 30
            wkself?.addChild(bullet)
            wkself?.monsterBullets.append(bullet)
            bullet.position = monster.position
            bullet.zPosition = monster.zPosition
            bullet.setScale(0.5)
            let endPos = CGPoint.init(x: (wkself!.hero.position.x), y: -bullet.size.height/2)
            let move = SKAction.move(to: endPos , duration: TimeInterval(dismisDuration))
            weak var wkbullet = bullet
            bullet.run(move, completion: {
                wkbullet?.removeFromParent()
                let index = wkself?.monsterBullets.index(of: wkbullet!)
                if index != nil {
                    wkself?.monsterBullets.remove(at: index!)
                }
            })
        }
        let sequence = SKAction.sequence([wait,shoot])
        let `repeat` = SKAction.repeat(sequence, count: bulletCount)
        run(`repeat`)
    }
}

extension GameScene {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        var frm = hero.frame
        frm = .init(x: frm.origin.x, y: frm.origin.y, width: frm.size.width + 100, height: frm.size.height + 100)
        if !frm.contains(location) {
            shouldMove = false
        }else{
            shouldMove = true
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard  shouldMove else {
            return
        }
        let touch = touches.first!
        let previousPosition = touch.previousLocation(in: view)
        let currentPosition = touch.location(in: view)
        let offsetx = currentPosition.x - previousPosition.x
        let offsety = currentPosition.y - previousPosition.y
        let x = hero.position.x + offsetx
        guard  x>=hero.size.width/2, x <= size.width-hero.size.width/2 else {
            return
        }
        let y = hero.position.y - offsety
        guard y>=hero.size.height/2, y <= size.height-hero.size.height/2 else {
            return
        }
        hero.position = .init(x: x , y: y)
    }
}

extension GameScene {
    private func gameOver() {
        player?.stop()
        let lose = LoseScene.init(size: size)
        lose.score = score
        refreshRecordIfNeed()
        let transation = SKTransition.moveIn(with: .up, duration: 0.5)
        view?.presentScene(lose, transition: transation)
    }
    
    private func refreshRecordIfNeed() {
        let history = UserDefaults.standard.integer(forKey: "score")
        if score > history {
            UserDefaults.standard.set(score, forKey: "score")
            UserDefaults.standard.synchronize()
        }
    }
}
