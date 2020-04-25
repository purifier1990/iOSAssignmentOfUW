//
//  HomeScene.swift
//  plane
//
//  Created by wenyu zhao on 2018/9/2.
//  Copyright © 2018 Ryan zhao. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    var startNode:SKLabelNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        setup()
        addNotes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
    }
    
    private func addNotes() {
        
        let score = UserDefaults.standard.integer(forKey: "score")
        let resultlb = SKLabelNode.init(fontNamed: "Chalkduster")
        resultlb.text = "Best " + String(score)
        resultlb.fontSize = 40;
        resultlb.fontColor = .black
        resultlb.position = .init(x: size.width/2, y: size.height/2  + 50)
        addChild(resultlb)
        
        startNode = SKLabelNode.init(fontNamed: "Chalkduster")
        startNode?.text = "GO!"
        startNode?.fontSize = 40
        startNode?.fontColor = .blue
        startNode?.position = .init(x: resultlb.position.x, y: resultlb.position.y * 0.8);
        
        startNode?.name = "go"
        addChild(startNode!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let frm = startNode!.frame
            if frm.contains(location) {
                go()
            }
        }
    }
    
    private func go(){
        let sence = GameScene.init(size: size)
        let t = SKTransition.moveIn(with: .up, duration: 0.3);
        view?.presentScene(sence, transition: t)
    }
}
