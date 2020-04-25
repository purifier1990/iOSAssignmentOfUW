//
//  SKElementNode.swift
//  plane
//
//  Created by wenyu zhao on 2018/8/31.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import SpriteKit

enum SKElementNodeBuff: Int {
    case none
    case doubleBullet
}

class SKElementNode: SKSpriteNode {
    var hp: UInt = 1
    var type:SKTextureType = .unknow
    var buff:SKElementNodeBuff = .none
    var shouldShoot = true
    
    convenience init(type:SKTextureType) {
        let assetName = TextureManager.shared.assetName(type)
        self.init(imageNamed: assetName)
        self.hp = hp(type)
        self.type = type
    }
    
    func alive() -> Bool {
        return hp > 0
    }
    
    private func hp(_ withType:SKTextureType) -> UInt {
        var value:UInt = 1
        switch withType {
        case .bullet:
            value = 1
            break
        case .hero:
            value = 1
            break
        case .smallEnemy:
            value = 1
            break
        case .midEnemy:
            value = 5
            break
        case .bigEnemy:
            value = 7
            break
        case .boss:
            value = 80
            break
        default:
            value = 1
            break
        }
        return value
    }
}
