//
//  TextureManager.swift
//  plane
//
//  Created by wenyu zhao on 2018/8/31.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import SpriteKit

enum SKTextureType: Int {
    case unknow
    case bullet
    case hero
    case heroToken
    case smallEnemy
    case midEnemy
    case bigEnemy
    case boss
    case supply
}
class TextureManager: NSObject {
    static let shared = TextureManager.init()
    func assetName(_ withType: SKTextureType) -> String {
        var name = ""
        switch withType {
        case .bullet:
            name = "bullet"
            break
        case .hero:
            name = "hero"
            break
        case .heroToken:
            name = "heroToken"
            break
        case .smallEnemy:
            name = "smallEnemy"
            break
        case .midEnemy:
            name = "midEnemy"
            break
        case .bigEnemy:
            name = "bigEnemy"
            break
        case .supply:
            name = "supply"
            break
        case .boss:
            name = "bigEnemy"
            break
        default:
            name = ""
            break
        }
        return name
    }
    func node(_ withType:SKTextureType) -> SKSpriteNode {
        let assetName = self.assetName(withType)
        let n = SKSpriteNode.init(imageNamed: assetName)
        return n
    }
}
