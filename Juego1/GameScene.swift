//
//  GameScene.swift
//  Juego1
//
//  Created by xavi B on 20/4/17.
//  Copyright © 2017 xavi B. All rights reserved.
//

import SpriteKit
import GameplayKit

extension SKSpriteNode { //add glow
    
    func addGlow(radius: Float = 30) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var bg = SKSpriteNode() //background
    var shotgun = SKSpriteNode()
    var machinegun = SKSpriteNode()
    var swap = SKSpriteNode()
    var rounds = SKSpriteNode()
    var ammo = SKSpriteNode()
    var medikit = SKSpriteNode()
    var life = SKSpriteNode()
    var scope = SKSpriteNode()
    var gunShot = SKSpriteNode()
    var zombie = SKSpriteNode()
    var claw = SKSpriteNode()
    var grenades = 0;
    var level = 1;
    var score = 0;
    var lives = 3;
    var danger = 0;
    var currentWeapon = 1;      //1 para shotgun 2 para machine gun
    var removeNode = false;
    var damage = 10;
    public var bullets = 15;
    public var bullets2 = 35;
    var roundsLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var levelLabel = SKLabelNode()
    var backgroundMusic = SKAction.playSoundFileNamed("ZombieMusic2.mp3", waitForCompletion: false)
    var shotgunSound = SKAction.playSoundFileNamed("Shotgun.mp3", waitForCompletion: false)
    var machinegunSound = SKAction.playSoundFileNamed("machinegun.mp3", waitForCompletion: false)
    var zombieSound = SKAction.playSoundFileNamed("ZombieAttack.mp3", waitForCompletion: false)
    var noAmmo = SKAction.playSoundFileNamed("noammo.wav", waitForCompletion: false)
    var reload = SKAction.playSoundFileNamed("reload.mp3", waitForCompletion: false)
    var lose = SKAction.playSoundFileNamed("ZombieWins.mp3", waitForCompletion: false)
    var health = SKAction.playSoundFileNamed("medikit.wav", waitForCompletion: false)
    var rafata = SKAction.playSoundFileNamed("machinegun.mp3", waitForCompletion: false)
    var timer = Timer()
    var clawTexture = SKTexture(imageNamed: "claw.png")
    var zombie1Texture = SKTexture(imageNamed: "zombie1.png")
    var zombie2Texture = SKTexture(imageNamed: "zombie2.png")
    var zombie3Texture = SKTexture(imageNamed: "zombie3.png")
    var zombiebossTexture = SKTexture(imageNamed: "zombieboss.png")
    var medikitTexture = SKTexture(imageNamed: "medkit.png")
    var bgTexture = SKTexture(imageNamed: "zombie_background.jpg")
    var lifeGroup = SKNode()
    var itemsGroup = SKNode()
    var ammoPresent = false
    var medpackPresent = false
    var machinegunPresent = false
    var shotgunPresent = true
    var gameOver = false
    var item = false
    var hit = false
   

    
    override func didMove(to view: SKView) {
        
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
//        
//        // Create shape node to use during mouse interaction
//        let w = (self.size.width + self.size.height) * 0.05
//        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
//        
//        if let spinnyNode = self.spinnyNode {
//            spinnyNode.lineWidth = 2.5
//            
//            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
//            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
//                                              SKAction.fadeOut(withDuration: 0.5),
//                                              SKAction.removeFromParent()]))
//        }

        shotgun.isHidden = false;
        machinegun.isHidden = true;
        print ("machinegun present?", !machinegun.isHidden)
        self.isUserInteractionEnabled = true
        self.addChild(itemsGroup)
        self.addChild(lifeGroup)    //afegim el grup de vides
        self.setBackground()
        self.showAmmo()
        playSound(sound: backgroundMusic)
        scheduledTimerWithTimeInterval()
        
        //nodes inicials
        // SHOTGUN
        let shotgunTexture = SKTexture(imageNamed: "shotgun.png")
        shotgun = SKSpriteNode(texture: shotgunTexture)
        shotgun.size.height = self.frame.height/6
        shotgun.size.width = self.frame.width/3
        shotgun.position = CGPoint(x: (self.frame.midX - self.frame.width*0.3), y: (self.frame.midY - self.frame.height*0.4))
        shotgun.zPosition = 5
        self.addChild(shotgun)
        shotgun.isHidden = false
        
        // MACHINE GUN
        let machinegunTexture = SKTexture(imageNamed: "machinegun.png")
        machinegun = SKSpriteNode(texture: machinegunTexture)
        machinegun.size.height = self.frame.height/2
        machinegun.size.width = self.frame.width/2
        machinegun.position = CGPoint(x: (self.frame.midX - self.frame.width*0.3), y: (self.frame.midY - self.frame.height*0.4))
        machinegun.zPosition = 5
        self.addChild(machinegun)
        machinegun.isHidden = true
        
        //SWAP BUTTON
        let swapTexture = SKTexture(imageNamed: "swap.png")
        swap = SKSpriteNode(texture: swapTexture)
        swap.size.height = self.frame.height/4
        swap.size.width = self.frame.width/4.5
        swap.position = CGPoint(x: (self.frame.midX + self.frame.width*0.38), y: (self.frame.midY - self.frame.height*0.37))
        swap.zPosition = 5
        swap.name = "swap"
        self.addChild(swap)
        
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.isUserInteractionEnabled = false
        let touch = touches.first!
        let touchedPosition = touch.location(in: self)
        let touchedNode = self.atPoint(touchedPosition)
        if let name = touchedNode.name{
            
            item = false
            
            if ((name == "zombie") && (bullets > 0 ) && (currentWeapon == 1 )) || ((name == "zombie") && (bullets2 > 0 ) && (currentWeapon == 2 )) {
                let hp:Int = touchedNode.userData!.value(forKey: "hp") as! Int
                let points:Int = touchedNode.userData!.value(forKey: "points") as! Int
                let dangermod:Int = touchedNode.userData!.value(forKey: "danger") as! Int
                touchedNode.userData?.setValue( hp-damage, forKey: "hp")
                if (hp-damage <= 0) {
                    score = score + points
                    danger = danger - dangermod
                    updateScore()
                    removeNode = true
                }
            }
            
            if (name == "ammo1") {
                danger = danger - 5
                let rand = randomNumber(MIN: 5, MAX: 10)
                bullets = bullets + rand
                showAmmo()
                playSound(sound: reload)
                ammoPresent = false
                removeNode = true
                item = true
            }
            
            if (name == "ammo2") {
                danger = danger - 3
                let rand = randomNumber(MIN: 5, MAX: 25)
                bullets2 = bullets2 + rand
                showAmmo()
                playSound(sound: reload)
                ammoPresent = false
                removeNode = true
                item = true
            }

            
            if (name == "medikit") {
                danger = danger - 10
                lives = lives + 1
                updateLives()
                playSound(sound: health)
                medpackPresent = false
                removeNode = true
                item = true
            }
            
            if (name == "swap") {
                if (currentWeapon == 1)     {     currentWeapon = 2; damage = 3       }     else {    currentWeapon = 1; damage = 10      }      //canvi d'arma
                showAmmo()
                playSound(sound: reload)
                item = true
            }
            
            if (name == "machinegun") {
                print("PLACING MACHINE GUN-----")
                item = true
                placeMachineGun()
            }
            
                showAmmo()
            
            
            if (removeNode) {   //eliminem
                touchedNode.removeFromParent()
                removeNode = false
            }
            
            
        }
        
        if (item == false){
            print ("item false")
            //SHOTGUN SHOT
            if (currentWeapon == 1){
                if (bullets > 0) {
                    bullets -= 1
                    playSound(sound: shotgunSound)
                    showGunshot(x: Int(touchedPosition.x), y: Int(touchedPosition.y))
                    print ("gunshot!")
                }   else {
                    playSound(sound: noAmmo)
                    showScope(x: Int(touchedPosition.x), y: Int(touchedPosition.y))
                }
            }
            
            //MACHINE GUN SHOT
            if (currentWeapon == 2){
                if (bullets2 > 0) {
                    bullets2 -= 1
                    playSound(sound: machinegunSound)
                    showGunshot(x: Int(touchedPosition.x), y: Int(touchedPosition.y))
                    print ("gunshot!")
                }   else {
                    playSound(sound: noAmmo)
                    showScope(x: Int(touchedPosition.x), y: Int(touchedPosition.y))
                }
            }
        }
        
            //DELAYS
        
        if (currentWeapon == 1){
            let delay = SKAction.wait(forDuration: 1)
            self.run(delay){
                self.isUserInteractionEnabled = true        //reactivem al cap d'un segon (si hi ha escopeta)
            }
        }
        
        if (currentWeapon == 2)  {
            let delay = SKAction.wait(forDuration: 0.2)
            self.run(delay){
                self.isUserInteractionEnabled = true        //reactivem al cap de 0.2 segons (si hi ha metralleta)
            }
        }
        
        hit = false
        item = false
        //print(touchedPosition.x)
        //print(touchedPosition.y)
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func setBackground() {
        
        bg.removeFromParent()
        
        switch (level){     //fons segons el nivell
            case 1:      bgTexture = SKTexture(imageNamed: "zombie_background.jpg")
            case 2:      bgTexture = SKTexture(imageNamed: "zombie_background2.jpg")
            case 3:      bgTexture = SKTexture(imageNamed: "zombie_background3.jpg")
            case 4:      bgTexture = SKTexture(imageNamed: "zombie_background4.jpg")
            case 5:      bgTexture = SKTexture(imageNamed: "zombie_background5.jpg")
            case 6:      bgTexture = SKTexture(imageNamed: "zombie_background6.jpg")
            case 0:      bgTexture = SKTexture(imageNamed: "zombie_victory.jpg")
            default:     bgTexture = SKTexture(imageNamed: "zombie_victory.jpg")
        }
        
        bg = SKSpriteNode(texture: bgTexture)
        bg.size.height = self.frame.height  //ajustem el tamany
        bg.size.width = self.frame.width
        bg.position = CGPoint(x: self.frame.midX, y: self.frame.midY)   //col.loquem al centre
        bg.zPosition = 0   //posició en profunditat
        self.addChild(bg)   //afegim el element a la escena
        
        updateLives()
        updateLevel()
        updateScore()
        
    }
    
    func updateLives(){
        //------------------------- LIVES -------------------------
        lifeGroup.removeAllChildren()
        let livesTexture = SKTexture(imageNamed: "lives.png")
        var xCord = self.frame.width * 0.0035
        
        if lives <= 0 { return       }
        
        for _ in 0 ..< lives {
            life = SKSpriteNode(texture: livesTexture)
            life.size.height = self.frame.height/10
            life.size.width = self.frame.width/15
            
            life.zPosition = 2
            life.position = CGPoint(x: (self.frame.midX - xCord), y: (self.frame.midY - self.frame.height*0.4))
            xCord = xCord - self.frame.width * 0.05
            self.lifeGroup.addChild(life)
        }
        
        if (lives == 0){
            
        }
        
    }
    
    func updateLevel(){
        //------------------------- LEVEL -------------------------
        levelLabel.removeFromParent()
        self.levelLabel.fontName = "SnellRoundhand-Black"
        self.levelLabel.fontSize = 45
        self.levelLabel.text = "Level: \(level)"
        self.levelLabel.position = CGPoint(x:  (self.frame.midX + self.frame.width*0.37), y: (self.frame.midY + self.frame.height*0.38))
        self.levelLabel.zPosition = 3  //posicio dintre de l'escena (capes)
        
        self.addChild(self.levelLabel)  //s'afegeig a l'escena
        
    }
    
    func updateScore(){
        //------------------------- SCORE -------------------------
        scoreLabel.removeFromParent()
        self.scoreLabel.fontName = "SnellRoundhand-Black"
        self.scoreLabel.fontSize = 45
        self.scoreLabel.text = "Score: \(score)"
        self.scoreLabel.position = CGPoint(x:  (self.frame.midX - self.frame.width*0.37), y: (self.frame.midY + self.frame.height*0.38))
        self.scoreLabel.zPosition = 3  //posicio dintre de l'escena (capes)
        
        self.addChild(self.scoreLabel)  //s'afegeig a l'escena
    }
    
    func playSound(sound : SKAction)    {        run(sound)    }
    
    func showScope(x: Int, y: Int){
        //------------------------- SCOPE -------------------------
        let scopeTexture = SKTexture(imageNamed: "mirilla")
        
            scope = SKSpriteNode(texture: scopeTexture)
            scope.size.height = self.frame.height/10
            scope.size.width = self.frame.width/15
            
            scope.zPosition = 2
            scope.position = CGPoint(x: x, y: y)
            self.addChild(scope)
            let delay = SKAction.wait(forDuration: 0.1)
            scope.run(delay){
                self.scope.removeFromParent()
            }
    }
    
    func showGunshot(x: Int, y: Int){
        let shot = arc4random_uniform(4)
        var gunShotTexture = SKTexture(imageNamed: "gunshot1.png")
        //print ("gunshot method")
        
        switch shot        {
        case 1:              gunShotTexture = SKTexture(imageNamed: "gunshot1.png")
        case 2:              gunShotTexture = SKTexture(imageNamed: "gunshot2.png")
        case 3:              gunShotTexture = SKTexture(imageNamed: "gunshot3.png")
        case 4:              gunShotTexture = SKTexture(imageNamed: "gunshot4.png")
        default:             gunShotTexture = SKTexture(imageNamed: "gunshot1.png")
        }
        
        gunShot = SKSpriteNode(texture: gunShotTexture)
        gunShot.size.height = self.frame.height/5
        gunShot.size.width = self.frame.width/8
        
        gunShot.zPosition = 4
        gunShot.position = CGPoint(x: x, y: y)
        self.addChild(gunShot)
        if (currentWeapon==1){
            let delay = SKAction.wait(forDuration: 1.0)
            gunShot.run(delay){
                self.gunShot.removeFromParent()
            }
        }
        if (currentWeapon==2) {
            let delay = SKAction.wait(forDuration: 0.1)
            gunShot.run(delay){
                self.gunShot.removeFromParent()
            }
        }
        
        showAmmo()
        
        
    }
    
    func showAmmo(){
        
        if (currentWeapon == 1){
        //------------------------- SHOTGUN -------------------------
        machinegun.isHidden = true
        shotgun.isHidden = false
        }
        
        if (currentWeapon == 2){
        //------------------------- MACHINE GUN -------------------------
        machinegun.isHidden = false
        shotgun.isHidden = true
        }
        
        //------------------------- ROUNDS -------------------------
        rounds.removeFromParent()
        roundsLabel.removeFromParent()
        
        var roundsTexture = SKTexture(imageNamed: "rounds.png")
        
        if (currentWeapon == 1){     roundsTexture = SKTexture(imageNamed: "rounds.png")       }
        if (currentWeapon == 2){     roundsTexture = SKTexture(imageNamed: "magazine.png")        }
        
        rounds = SKSpriteNode(texture: roundsTexture)
        rounds.size.height = self.frame.height/10
        rounds.size.width = self.frame.width/6
        rounds.position = CGPoint(x: (self.frame.midX - self.frame.width*0.3), y: (self.frame.midY - self.frame.height*0.4))
        
        rounds.zPosition = 8
        self.addChild(rounds)
        
        self.roundsLabel.fontName = "Noteworthy-Bold"
        self.roundsLabel.fontSize = 45
        
        if (currentWeapon == 1){     self.roundsLabel.text = "\(bullets)"        }
        if (currentWeapon == 2){     self.roundsLabel.text = "\(bullets2)"        }
        
        self.roundsLabel.position = CGPoint(x:  (self.frame.midX - self.frame.width*0.20), y: (self.frame.midY - self.frame.height*0.45))
        self.roundsLabel.zPosition = 8  //posicio dintre de l'escena (capes)
        
        self.addChild(self.roundsLabel)  //s'afegeig a l'escena

    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function **Countdown** with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    func updateCounting(){      //funció que controla el pas del temps
        score = score + level * 5
        updateScore()
        level = (score/1000) + 1
        updateLevel()
        spawnZombie()
        spawnItems()
        checkDamage()
        //print("machinegun is present=?" , !machinegun.isHidden, "shotgun is present?", !shotgun.isHidden)
        print ("danger: ", danger)
        setBackground()
        
    }
    
    func spawnZombie(){
        let spawn = randomNumber(MIN: 1, MAX: 80) + level*5 + danger/4
        print ("zombie roll: " , spawn)
        
        //------------------------- Zombie lvl 1 -------------------------
        if (spawn > 50) && (spawn < 75){
            zombie = SKSpriteNode(texture: zombie1Texture)
            let randX = CGFloat(randomNumber(MIN: 5, MAX: 35))/100
            let randY = CGFloat(randomNumber(MIN: 0, MAX: 80)-40)/100
            zombie.position = CGPoint(x:  (self.frame.midX - self.frame.width*randY), y: (self.frame.midY - self.frame.height*randX))
            zombie.zPosition = 1
            zombie.name = "zombie"
            zombie.userData = NSMutableDictionary()
            zombie.userData?.setValue(2, forKeyPath: "hp")
            zombie.userData?.setValue(10, forKeyPath: "points")
            zombie.userData?.setValue(1, forKeyPath: "danger")
            //zombie.userData = ["points" :5]
            //zombie.userData = ["danger" :1]
            danger = danger + 2
            self.addChild(zombie)
            print("Spawn zombie1:" , spawn, "on:", randX, randY, "danger: ", danger, " hp: ", zombie.userData?.value(forKey: "hp"), userData)
            //print(zombie.userData!)
        }
        
        //------------------------- Zombie lvl 2 -------------------------
        if (spawn > 75) && (spawn < 90){
            zombie = SKSpriteNode(texture: zombie2Texture)
            let randX = CGFloat(randomNumber(MIN: 5, MAX: 35))/100
            let randY = CGFloat(randomNumber(MIN: 0, MAX: 80)-40)/100
            zombie.position = CGPoint(x:  (self.frame.midX - self.frame.width*randY), y: (self.frame.midY - self.frame.height*randX))
            zombie.zPosition = 1
            zombie.name = "zombie"
            zombie.userData = NSMutableDictionary()
            zombie.userData?.setValue(5, forKeyPath: "hp")
            zombie.userData?.setValue(25, forKeyPath: "points")
            zombie.userData?.setValue(4, forKeyPath: "danger")
            danger = danger + 5
            self.addChild(zombie)
            print("Spawn zombie2:" , spawn, "on:", randX, randY, "danger: ", danger, " hp: ", zombie.userData?.value(forKey: "hp"), userData)
        }
        
        //------------------------- Zombie lvl 3 -------------------------
        if (spawn > 90) && (spawn < 115){
            zombie = SKSpriteNode(texture: zombie3Texture)
            let randX = CGFloat(randomNumber(MIN: 5, MAX: 35))/100
            let randY = CGFloat(randomNumber(MIN: 0, MAX: 80)-40)/100
            zombie.position = CGPoint(x:  (self.frame.midX - self.frame.width*randY), y: (self.frame.midY - self.frame.height*randX))
            zombie.zPosition = 1
            zombie.name = "zombie"
            zombie.userData = NSMutableDictionary()
            zombie.userData?.setValue(10, forKeyPath: "hp")
            zombie.userData?.setValue(50, forKeyPath: "points")
            zombie.userData?.setValue(9, forKeyPath: "danger")
            danger = danger + 10
            self.addChild(zombie)
            print("Spawn zombie3:" , spawn, "on:", randX, randY, "danger: ", danger, " hp: ", zombie.userData?.value(forKey: "hp"), userData)
        }
        
        //------------------------- Zombie boss -------------------------
        if (spawn > 115) && (spawn < 150){
            zombie = SKSpriteNode(texture: zombiebossTexture)
            let randX = CGFloat(randomNumber(MIN: 5, MAX: 35))/100
            let randY = CGFloat(randomNumber(MIN: 0, MAX: 80)-40)/100
            zombie.position = CGPoint(x:  (self.frame.midX - self.frame.width*randY), y: (self.frame.midY - self.frame.height*randX))
            zombie.zPosition = 4
            zombie.name = "zombie"
            zombie.userData = NSMutableDictionary()
            zombie.userData?.setValue(25, forKeyPath: "hp")
            zombie.userData?.setValue(100, forKeyPath: "points")
            zombie.userData?.setValue(20, forKeyPath: "danger")
            danger = danger + 25
            self.addChild(zombie)
            print("Spawn zombie3:" , spawn, "on:", randX, randY, "danger: ", danger, " hp: ", zombie.userData?.value(forKey: "hp"), userData)
        }
        
        //------------------------- Double Spawn -------------------------
        if (spawn > 150) {
            print("double!")
            
        }
    }
    
    func spawnItems(){
        
        var spawn = randomNumber(MIN: 1, MAX: 100) - (level * 5) + (danger) - bullets - bullets2/2
        //------------------------- Ammo -------------------------
        if (spawn > 75) && (!ammoPresent) {
            
            let ammoType = randomNumber(MIN: 1, MAX: 2)
            
            if (ammoType == 1) {
                var ammoTexture = SKTexture(imageNamed: "rounds.png")
                ammo = SKSpriteNode(texture: ammoTexture)
                ammo.size.height = self.frame.height/10
                ammo.size.width = self.frame.width/6
                let randX = CGFloat(randomNumber(MIN: 5, MAX: 50)-40)/100
                let randY = CGFloat(randomNumber(MIN: 0, MAX: 50)-10)/100
                ammo.position = CGPoint(x:  (self.frame.midX - self.frame.width*randY), y: (self.frame.midY - self.frame.height*randX))
                ammo.zPosition = 6
                ammo.name = "ammo1"
                print("Spawn ammo:" , spawn, "on:", randX, randY)
            }
            
            if (ammoType == 2) {
                var ammoTexture = SKTexture(imageNamed: "magazine")
                ammo = SKSpriteNode(texture: ammoTexture)
                ammo.size.height = self.frame.height/10
                ammo.size.width = self.frame.width/6
                let randX = CGFloat(randomNumber(MIN: 5, MAX: 50)-40)/100
                let randY = CGFloat(randomNumber(MIN: 0, MAX: 50)-10)/100
                ammo.position = CGPoint(x:  (self.frame.midX - self.frame.width*randY), y: (self.frame.midY - self.frame.height*randX))
                ammo.zPosition = 6
                ammo.name = "ammo2"
                print("Spawn ammo:" , spawn, "on:", randX, randY)
            }
            
        
            
            self.itemsGroup.addChild(ammo)
            
            ammoPresent = true
        }
        
        spawn = randomNumber(MIN: 1, MAX: 100) - (level * 5) + (danger) + (20 - lives*5)
        //------------------------- MedPacks -------------------------
        if (spawn > 95) && (!medpackPresent) {
            medikit = SKSpriteNode(texture: medikitTexture)
            medikit.size.height = self.frame.height/5
            medikit.size.width = self.frame.width/6
            let randX = CGFloat(randomNumber(MIN: 5, MAX: 50)-40)/100
            let randY = CGFloat(randomNumber(MIN: 0, MAX: 50)-20)/100
            medikit.position = CGPoint(x:  (self.frame.midX - self.frame.width*randY), y: (self.frame.midY - self.frame.height*randX))
            medikit.zPosition = 6
            medikit.name = "medikit"
            self.itemsGroup.addChild(medikit)
            print("Spawn medikit:" , spawn, "on:", randX, randY)
            medpackPresent = true
        }
        
        spawn = randomNumber(MIN: 1, MAX: 60) + (level * 5) + (danger*2) + (20 - lives*5) + (20 - bullets - bullets2/2)
        //------------------------- Machine Gun -------------------------
//        if (spawn > 5) && (!machinegunPresent) {
//            let machinegunTexture = SKTexture(imageNamed: "machinegun.png")
//            machinegun = SKSpriteNode(texture: machinegunTexture)
//            machinegun.size.height = self.frame.height/2.5
//            machinegun.size.width = self.frame.width/3.4
//            let randX = CGFloat(randomNumber(MIN: 5, MAX: 50)-40)/100
//            let randY = CGFloat(randomNumber(MIN: 0, MAX: 50)-20)/100
//            machinegun.position = CGPoint(x:  (self.frame.midX - self.frame.width*randY), y: (self.frame.midY - self.frame.height*randX))
//            machinegun.zPosition = 6
//            machinegun.name = "machinegun"
//            self.itemsGroup.addChild(machinegun)
//            print("Spawn machinegun:" , spawn, "on:", randX, randY)
//            machinegunPresent = true
//        }
        
        
    }
    
    func randomNumber(MIN: Int, MAX: Int)-> Int {
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }
    
    func checkDamage(){
        let dangerCheck = randomNumber(MIN: 0, MAX: 1000) + danger + level*5
        print ("damage rolls:", dangerCheck)
        if (dangerCheck > 1000){
        
            
        
            lives = lives - 1
            updateLives()
            danger = danger/2
            playSound(sound: zombieSound)
            claw = SKSpriteNode(texture: clawTexture)
            claw.zPosition = 10
            
            claw.size.height = self.frame.height/2
            claw.size.height = self.frame.width/3
            claw.position = CGPoint(x:  (self.frame.midX), y: (self.frame.midY))
            self.addChild(claw)
            
            let delay = SKAction.wait(forDuration: 0.2)
            claw.run(delay){
                self.claw.removeFromParent()
                self.isUserInteractionEnabled = true            }
            
            print("Lost 1 life!:" , lives)
            if lives == 0 {    GameOver()         }
        }
        
    }
    
    func GameOver(){
        
        self.removeAllChildren()
        
        level = 0
        setBackground()
        
        let delay = SKAction.wait(forDuration: 2)
        self.run(delay){
            self.playSound(sound: self.lose)
        }
        timer.invalidate()
        gameOver = true
        self.removeAllActions()
    }
    
    func placeMachineGun(){
        shotgun.isHidden = true;
        machinegun.isHidden = false;
        playSound(sound: shotgunSound)
        damage = 2
        showAmmo()
    }
    
 
    
 
    
}
