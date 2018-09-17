import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var mosca = SKSpriteNode()
    var fondo = SKSpriteNode()
    var widthDevice: CGFloat!
    var heightDevice: CGFloat!
    var timerMosca = Timer()
    var timerTimeGame = Timer()
    var moscasMaximas: Int = 0
    var moscasMuertas: Int = 0
    var totTime: Int = 0
    var sonidoMuerteMosca: SKAction!
    var sangre = SKSpriteNode()
    var labelTime = SKLabelNode()
    var labelTotalTimeGame = SKLabelNode()
    var labelTotalGame = SKLabelNode()
    var timeTotalGame: Int = 30
    var play: Bool!
    var btnPlay = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.widthDevice = UIScreen.main.fixedCoordinateSpace.bounds.height
        self.heightDevice = UIScreen.main.fixedCoordinateSpace.bounds.width
        self.play = false
        playGame()
        
        //agregamos el fondo
        let texturaFondo = SKTexture(imageNamed: "fondo.png")
        self.fondo = SKSpriteNode(texture: texturaFondo)
        self.fondo.size.height = self.frame.height
        self.fondo.zPosition = -1
        self.addChild(self.fondo)
        
        // agregamos las moscas y las animamos
        let textura1Mosca = SKTexture(imageNamed: "mFool.png")
        let textura2Mosca = SKTexture(imageNamed: "mFool-2.png")
        self.mosca = SKSpriteNode(texture: textura1Mosca)
        self.mosca.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        self.mosca.name = "mosca"
        self.addChild(self.mosca)
        let animarMosca = SKAction.repeatForever(SKAction.animate(with: [textura1Mosca, textura2Mosca], timePerFrame: 0.1))
        self.mosca.run(animarMosca)
        
        let posicion = getPos(widthDevice: self.widthDevice, heightDevice: self.heightDevice)
        let animacionMosca = SKAction.move(to: posicion, duration: 2)
        let nuevaPosicon = getPos(widthDevice: self.widthDevice, heightDevice: self.heightDevice)
        let animacionMosca2 = SKAction.move(to: nuevaPosicon, duration: 2)
        let animarForever = SKAction.repeatForever(SKAction.sequence([animacionMosca, animacionMosca2]))
        self.mosca.run(animarForever)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let locationTouch = touch.location(in: self)
        let hit = nodes(at: locationTouch)
        if let sprite = hit.first {
            if sprite.name == "play" {
                play = true
                playGame()
            } else {
                if sprite.name == "mosca" {
                    self.sonidoMuerteMosca = SKAction.playSoundFileNamed("slap.mp3", waitForCompletion: true)
                    sprite.run(self.sonidoMuerteMosca)
                    let muerteMosca = SKAction.removeFromParent()
                    sprite.run(muerteMosca)
                    mostrarSangre(posicion: CGPoint(x: sprite.position.x, y: sprite.position.y))
                    //mostrarSangreParticula(pos: CGPoint(x: sprite.position.x, y: sprite.position.y))
                    self.moscasMuertas += 1
                    self.moscasMaximas = moscasMaximas - 1
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // Mis funciones
    @objc func crearMoscas() {
        var duracion:Float = 0.0
        if self.moscasMaximas < 10 {
            var nameTexture1: String = ""
            var nameTexture2: String = ""
            let nTexture = genRamdom( min: 10, max: 100 )
            
            if nTexture < 30 {
                nameTexture1 = "m1.png"
                nameTexture2 = "m1-2.png"
                duracion = 1.5
            }
            else if nTexture < 60 {
                nameTexture1 = "m2.png"
                nameTexture2 = "m2-2.png"
                duracion = 2
            }
            else if nTexture >= 60 {
                nameTexture1 = "mFool.png"
                nameTexture2 = "mFool-2.png"
                duracion = 2.5
            }
        
            let textura1Mosca = SKTexture(imageNamed: nameTexture1)
            let textura2Mosca = SKTexture(imageNamed: nameTexture2)
            self.mosca = SKSpriteNode(texture: textura1Mosca)
            self.mosca.position = getPos( widthDevice: widthDevice, heightDevice: heightDevice )
            self.mosca.name = "mosca"
            self.addChild(self.mosca)
            let animarMosca = SKAction.repeatForever(SKAction.animate(with: [textura1Mosca, textura2Mosca], timePerFrame: 0.1))
            self.mosca.run(animarMosca)
            
            let posicion = getPos(widthDevice: self.widthDevice, heightDevice: self.heightDevice)
            let animacionMosca = SKAction.move(to: posicion, duration: TimeInterval(duracion))
            let nuevaPosicon = getPos(widthDevice: self.widthDevice, heightDevice: self.heightDevice)
            let animacionMosca2 = SKAction.move(to: nuevaPosicon, duration: TimeInterval(duracion))
            let animarForever = SKAction.repeatForever(SKAction.sequence([animacionMosca, animacionMosca2]))
            self.mosca.run(animarForever)
            self.moscasMaximas += 1
        }
    }
    
    @objc func game() {
        if totTime < timeTotalGame {
            totTime += 1
            labelTime.text = "\(totTime)"
        }
        else {
            play = false
            playGame()
        }
    }
    
    func mostrarSangre(posicion: CGPoint) {
        let texturaSangre = SKTexture(imageNamed: "blood.png")
        self.sangre = SKSpriteNode(texture: texturaSangre)
        self.sangre.position = posicion
        self.sangre.size = CGSize(width: widthDevice * 0.05, height: heightDevice * 0.10)
        let escala = SKAction.scale(to: 3.0, duration: 0.3)
        let esperar = SKAction.wait(forDuration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.4)
        let animacion = SKAction.sequence([escala, esperar, fadeOut])
        self.sangre.run(animacion)
        self.addChild(self.sangre)
    }
    
    func mostrarSangreParticula(pos: CGPoint){
        let emitterNode = SKEmitterNode(fileNamed: "sangre.sks")
        emitterNode?.particlePosition = pos
        self.addChild(emitterNode!)
        self.run(SKAction.wait(forDuration: 1), completion: { emitterNode?.removeFromParent() })
    }
    
    //Mis funciones
    func playGame() {
        if !play {
            timerMosca.invalidate()
            timerTimeGame.invalidate()
            
            for mosca in self.children {
                //Determine Details
                if mosca.name == "mosca" {
                    mosca.removeFromParent()
                }
            }
            
            let textureBtn = SKTexture(imageNamed: "botonPlay.png")
            btnPlay = SKSpriteNode( texture: textureBtn )
            btnPlay.position = CGPoint( x: 0, y: 0 )
            btnPlay.name = "play"
            
            let up = SKAction.scale( to: 1.5, duration: 0.2 )
            let down = SKAction.scale( to: 1, duration: 0.2 )
            self.addChild( btnPlay )
            
            let animacion = SKAction.sequence( [ up, down ] )
            btnPlay.run( animacion )
            
            labelTime.text = "0"
            
            //Etiquetas de fin de juego
            labelTotalGame = SKLabelNode( fontNamed: "Noteworthy-Bold" )
            labelTotalGame.text = "Moscas Eliminadas: \(moscasMuertas)"
            labelTotalGame.fontSize = 40
            labelTotalGame.fontColor = UIColor.red
            labelTotalGame.position = CGPoint( x: -widthDevice, y: 75 )
            
            labelTotalTimeGame = SKLabelNode( fontNamed: "Noteworthy-Bold" )
            labelTotalTimeGame.text = "Tiempo Total: \(totTime) segundos"
            labelTotalTimeGame.fontSize = 40
            labelTotalTimeGame.fontColor = UIColor.red
            labelTotalTimeGame.position = CGPoint( x: widthDevice + 30, y: 125 )
            
            let moveLabel = SKAction.moveTo( x: 0, duration: 0.7 )
            labelTotalTimeGame.run( moveLabel )
            labelTotalGame.run( moveLabel )
            
            self.addChild( labelTotalTimeGame )
            self.addChild( labelTotalGame )
            
        } else {
            totTime = 0
            moscasMaximas = 0
            moscasMuertas = 0
            btnPlay.run(SKAction.removeFromParent())
            labelTotalTimeGame.run(SKAction.removeFromParent())
            labelTotalGame.run(SKAction.removeFromParent())
            labelTime.run(SKAction.removeFromParent())
            
            btnPlay.run( SKAction.removeFromParent() )
            labelTotalTimeGame.run( SKAction.removeFromParent() )
            labelTotalGame.run( SKAction.removeFromParent() )
            labelTime.run( SKAction.removeFromParent() )
            
            self.timerMosca = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.crearMoscas), userInfo: nil, repeats: true)
            self.timerTimeGame = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.game), userInfo: nil, repeats: true)
            labelTime = SKLabelNode(fontNamed: "Noteworthy-Bold")
            labelTime.text = "\(totTime)"
            labelTime.fontSize = 30
            labelTime.fontColor = UIColor.black
            labelTime.position = CGPoint(x: -340, y: 140)
            self.addChild(labelTime)
        }
    }
}
