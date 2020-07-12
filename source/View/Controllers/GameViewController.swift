//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit
import AVFoundation
import SpriteKit

class GameViewController: BaseGameViewController {
    override func gameFailed() {
        if isSucceeded{
            SoundService.shared.playSoundEffectPass()
        }
        else{
            SoundService.shared.playSoundEffectFail()
        }
        super.gameFailed()
    }
    
    private func stopAllTimers(){
        
        boundsTimer?.invalidate()
        currentGame.motion?.stopDeviceMotionUpdates()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAllTimers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    var column = 4
    @IBOutlet weak var bouncingView: SKView!
    var currentGame:GameScene!
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bouncingView.allowsTransparency = true
        if let view = self.bouncingView {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = (scene as! GameScene)
                currentGame.changeGravity(isLevelMode:level == .general)
            }
            
            view.ignoresSiblingOrder = true
            
            // view.showsFPS = true
            // view.showsNodeCount = true
        }
    }
    
    @IBOutlet weak var indexLabel: UILabel!
    var currentIndex:Int = 0
    private func setupBottomButtons(){
        if toolBackView != nil{
            toolBackView.removeFromSuperview()
        }
        toolBackView = {
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            bouncingView.addSubview(imageView)
            // imageView.image = UIImage(named: "4_score_icon")
            imageView.contentMode = .scaleAspectFit
            imageView.frame.size = CGSize(width: bouncingView.frame.size.width-140, height: 80)
            imageView.frame.origin = CGPoint(x: 60, y: bouncingView.frame.size.height-80)
            
            return imageView
        }()
        
        toolBackView.layer.cornerRadius = 20
        toolBackView.layer.borderColor = UIColor.black.cgColor
        toolBackView.layer.borderWidth = 2
        
        stackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 20
            toolBackView.addSubview(stackView)
            stackView.snp.makeConstraints { (make) in
                make.edges.equalTo(toolBackView).inset(UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20))
                
            }
            return stackView
        }()
        
        for i in 1...7{
            let _:UIImageView = {
                let imageView = UIImageView()
                imageView.tag = i
                let panRecognizer = UIPanGestureRecognizer(target:self, action:#selector(panned(_:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(panRecognizer)
                stackView.addArrangedSubview(imageView)
                imageView.image = UIImage(named: "shape\(i)")
                imageView.contentMode = .scaleAspectFit
                imageView.snp.makeConstraints { (make) in
                    make.width.equalTo(40)
                    //make.height.equalTo(40)
                }
                return imageView
            }()
        }
        
    }
    
    private var currentPannedView:UIImageView!
    @objc private func panned(_ recognizer:UIPanGestureRecognizer){
        currentPannedView = (recognizer.view! as! UIImageView)
        switch recognizer.state {
        case .changed:
            let translation = recognizer.translation(in: self.view)
            currentPannedView.center = CGPoint(x: currentPannedView.center.x + translation.x, y: currentPannedView.center.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        case .ended:
            let newCenter = currentPannedView.superview!.convert(currentPannedView.center, to: self.view)
            if toolBackView.frame.contains(newCenter){
                self.adjustToolPosition(pannedView: currentPannedView)
                return
            }
            
            //let skview = self.view as! SKView
            let center0 = currentPannedView.superview!.convert(currentPannedView.center, to: self.bouncingView)
            let center = self.bouncingView.convert(center0, to: currentGame)
            let _ = currentGame.createShape(point: center,shapeID:currentPannedView.tag)
            
            currentIndex += 1
            indexLabel.text = "\(currentIndex)/5"
            if currentIndex == 5{
                self.startGame()
            }
            
            self.adjustToolPosition(pannedView: currentPannedView)
        default:
            return
        }
    }
    
    private func adjustToolPosition(pannedView:UIImageView){
        pannedView.removeFromSuperview()
        currentPannedView = nil
        self.setupBottomButtons()
        
    }
    
    @IBOutlet weak var startButton: UIButton!
    private var checkTimer:Timer!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction private func startGame(){
        
        if level == .simple{
            toolsOn = true
            self.toggleTools()
        }
        
        if level == .general{
            startCountDown()
            
        }
        
        startButton.isEnabled = false
        bottomButton.isEnabled = false
        
        currentGame.startDrop()
        self.checkOutOfBounds()
        
    }
    private var boundsTimer:Timer?
    private func checkOutOfBounds(){
        boundsTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(_checkOutOfBounds), userInfo: nil, repeats: true)
        boundsTimer?.fire()
        
    }
    
    @objc private func _checkOutOfBounds(){
        if currentGame .ballOutBound(){
            self.gameFailed()
        }
        
    }
    
    private var toolsOn = true
    private var initToolY:CGFloat = 0
    @IBAction private func toggleTools(){
        if level == .general{
            currentGame.setupObstacles()
            return
        }
        toolsOn = !toolsOn
        
        UIView.animate(withDuration: 1) {
            if !self.toolsOn{
                self.toolBackView.center.y = self.view.bounds.size.height + 90
            }
            else{
                self.toolBackView.center.y = self.initToolY
                
            }
            
        }
    }
    override func showScore(){
        if !isGaming{
            return
        }
        if isSucceeded{
            let toSave = number
            UserDefaults.standard.set(toSave, forKey: self.level.rawValue)
        }
        let storyboard = UIStoryboard(name: "ScoreViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
        
        vc.score = number
        vc.isSucceeded = isSucceeded
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBOutlet weak var toolBackView: UIView!
    @IBOutlet weak var bottomButton: UIButton!
    override  func setupUI() {
        
        super.setupUI()
        
        setupBottomButtons()
        if level == .general{
            toolBackView.isHidden = true
            indexLabel.isHidden = true
            // timeLabel.isHidden = true
            
            bottomButton.setImage(UIImage(named: "refresh"), for: .normal)
            
            currentGame.setupObstacles()
        }
        
        self.setupBinding()
        
        self.showStartInfo()
        
    }
    
    private var startView:NewAlertView!
    
    private func showStartInfo(){
        startView = NewAlertView()
        // startView.contentView.backgroundColor = .white
        self.view.addSubview(startView)
        startView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        }
        let imageView1:UIImageView = {
            let imageView = UIImageView()
            imageView.isUserInteractionEnabled = true
            startView.insertSubview(imageView, belowSubview: startView.button)
            imageView.image = UIImage(named: "")
            imageView.contentMode = .scaleAspectFit
            imageView.snp.makeConstraints { (make) in
                make.centerY.equalTo(startView).offset(-30)
                make.centerX.equalTo(startView)
                make.width.equalTo(360)
                make.height.equalTo(287)
            }
            return imageView
        }()
        
        let _:UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = Utils.colorFromRGB(colors: [254, 191, 45]) //.white
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont.systemFont(ofSize: 22)
            label.text = "Drag up to 5 geometries from the toolbar below and drop them on the screen. Tap the start button to let the ball fall and let the ball successfully reach the exit (vortex) after colliding with these geometries."
            
            if level == .general{
                label.text = "Tap the start button to let the ball fall, tilt the phone left and right to give the ball a thrust, and let the ball successfully reach the exit (vortex) after colliding with these geometry. You can tap the refresh button to change the position of these geometry."
            }
            
            imageView1.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.edges.equalTo(imageView1).inset(UIEdgeInsets(top: 60, left: 10, bottom: 10, right: 10))
                
            }
            return label
        }()
        startView.button.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismissAndStart()
            
            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        
    }
    
    @objc private func dismissAndStart(){
        isGaming = true
        
        if level == .simple{
            timeLabel.textColor = Utils.colorFromRGB(colors: [254, 204, 47])
            startCountDown()
        }
        
        startView.removeFromSuperview()
        
    }
    
    private func startCountDown(){
        timeLabel.isHidden = false
        viewModel.createCountdownTimer()
        
    }
    
    override func setupBinding(){
        super.setupBinding()
        
        viewModel.seconds.map({"\($0)s"}).bind(to: timeLabel.rx.text).disposed(by: bag)
        viewModel.seconds.subscribe(onNext: { [weak self] seconds in
            if seconds == 0{
                self?.isSucceeded = false
                self?.gameFailed()
            }
            
        }).disposed(by: bag)
        
        if currentGame == nil {return}
        
        currentGame.hitTarget.subscribe(onNext: { [weak self] hitTarget in
            if hitTarget{
                SoundService.shared.playSoundEffectBingo()
                self?.isSucceeded = true
                self?.gameFailed()
            }
            
        }).disposed(by: bag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toolBackView.frame.size = CGSize(width: bouncingView.frame.size.width-140, height: 80)
        toolBackView.frame.origin = CGPoint(x: 60, y: bouncingView.frame.size.height-80)
        
        initToolY = toolBackView.center.y
        
    }
    
}
