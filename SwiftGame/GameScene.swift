//
//  GameScene.swift
//  SwiftGame
//
//  Created by Shahir Abdul-Satar on 8/17/16.
//  Copyright (c) 2016 Shahir Abdul-Satar. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var movingGround: ASASMovingGround!
    var hero: ASASHero!
    var wallGenerator: ASASWallGenerator!
    var isStarted = false
    var isGameOver = false
    
    
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 159.0/255.0, green: 201.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
        addMovingGround()
        addHero()
        addWallGenerator()
        addTapToStartLabel()
        addPointsLabel()
        addPhysicsWorld()
        
        loadHighscore()
        
        
               
    }
    func addMovingGround() {
        movingGround = ASASMovingGround(texture: nil, color: UIColor.brown,size: CGSize(width: view!.frame.width, height: 20))
        movingGround.position = CGPoint(x: 0, y: view!.frame.size.height/2)
        addChild(movingGround)
        
    }
    func addHero() {
        hero = ASASHero()
        hero.position = CGPoint(x: 70, y: movingGround.position.y + movingGround.frame.size.height/2 + hero.frame.size.height/2)
        addChild(hero)
        hero.breathe()
        
    }
    func addWallGenerator() {
        wallGenerator = ASASWallGenerator(color: UIColor.clear, size: view!.frame.size)
        wallGenerator.position = view!.center
        addChild(wallGenerator)

        
    }
    func addTapToStartLabel(){
        let tapToStartLabel = SKLabelNode(text: "Tap to start!")
        tapToStartLabel.name = "tapToStartLabel"
        
        tapToStartLabel.position.x = view!.center.x
        tapToStartLabel.position.y = view!.center.y + 40
        tapToStartLabel.fontName = "Helvetica"
        tapToStartLabel.fontColor = UIColor.black
        tapToStartLabel.fontSize = 22.0
        addChild(tapToStartLabel)
        tapToStartLabel.run(blinkAnimation())

    }
    func addPointsLabel() {
        let pointsLabel = ASASPointsLabel(num: 0)
        
        pointsLabel.position = CGPoint(x: 20.0, y: view!.frame.size.height - 35)
        pointsLabel.name = "pointsLabel"
        addChild(pointsLabel)
        let highscoreLabel = ASASPointsLabel(num: 0)
        highscoreLabel.name = "highscoreLabel"
        highscoreLabel.position = CGPoint(x: view!.frame.size.width - 20, y: view!.frame.size.height - 35)
        addChild(highscoreLabel)
        
        let highscoreTextLabel = SKLabelNode(text: "High")
        highscoreTextLabel.fontColor = UIColor.black
        highscoreTextLabel.fontSize = 14.0
        highscoreTextLabel.fontName = "Helvetica"
        highscoreTextLabel.position = CGPoint(x: 0, y: -20)
        highscoreLabel.addChild(highscoreTextLabel)
    }
    func addPhysicsWorld(){
        physicsWorld.contactDelegate = self

        
    }
    
    func loadHighscore() {
        let defaults = UserDefaults.standard
        
        let highscoreLabel = childNode(withName: "highscoreLabel") as! ASASPointsLabel
        highscoreLabel.setTo(defaults.integer(forKey: "highscore"))
    }
    
    func start() {
        isStarted = true
        
        let tapToStartLabel = childNode(withName: "tapToStartLabel")
        tapToStartLabel?.removeFromParent()
        hero.stop()
        hero.startRunning()
        movingGround.start()
        wallGenerator.startGeneratingWallsEvery(1)
    }
    
    func gameOver() {
        isGameOver = true
        
        //stop everything
        hero.fall()
        wallGenerator.stopWalls()
        movingGround.stop()
        hero.stop()
        
        let gameOverLabel = SKLabelNode(text: "Game Over!")
        gameOverLabel.fontColor = UIColor.black
        gameOverLabel.fontName = "Helvetica"
        gameOverLabel.position.x = view!.center.x
        gameOverLabel.position.y = view!.center.y + 40
        gameOverLabel.fontSize = 22.0
        addChild(gameOverLabel)
        gameOverLabel.run(blinkAnimation())
        
        
        
        // save current points label value
        let pointsLabel = childNode(withName: "pointsLabel") as! ASASPointsLabel
        let highscoreLabel = childNode(withName: "highscoreLabel") as! ASASPointsLabel
        
        if highscoreLabel.number < pointsLabel.number {
            highscoreLabel.setTo(pointsLabel.number)
            let defaults = UserDefaults.standard
            defaults.set(highscoreLabel.number, forKey: "highscore")
        }
        
        
    }
    func restart() {
        let newScene = GameScene(size: view!.bounds.size)
        newScene.scaleMode = .aspectFill
        view!.presentScene(newScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isGameOver {
            restart()
        }
           else if !isStarted {
            start()
        }else {
            hero.flip()
        }
        
           }
   
    override func update(_ currentTime: TimeInterval) {
        if wallGenerator.wallTrackers.count > 0 {
        let wall = wallGenerator.wallTrackers[0] as ASASWall
        let wallLocation = wallGenerator.convert(wall.position, to: self)
        if wallLocation.x < hero.position.x {
            wallGenerator.wallTrackers.remove(at: 0)
            
            let pointsLabel = childNode(withName: "pointsLabel") as! ASASPointsLabel
            pointsLabel.increment()
            
            if pointsLabel.number % kNumberOfPointsPerLevel == 0 {
                var currentLevel: Int = 0
                currentLevel += 1
                wallGenerator.stopGenerating()
                wallGenerator.startGeneratingWallsEvery(kLevelGenerationTimes[currentLevel])
            }
            }
        }
    
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        if !isGameOver {
            gameOver()
        }
        gameOver()
        print("didBeginContact called")
    }
    
    func blinkAnimation() -> SKAction {
        let duration = 0.4
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: duration)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: duration)
        let blink = SKAction.sequence([fadeOut, fadeIn])
        return SKAction.repeatForever(blink)
        
    }
    
    
    
    
    
}



