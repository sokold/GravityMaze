//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var buttonInfo: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    override func viewDidLoad() {
        //bgName = "background2"
        super.viewDidLoad()
        
        let firstTime = UserDefaults.standard.string(forKey: "firstTime")
        if firstTime == nil{
            UserDefaults.standard.set("0", forKey: "firstTime")
            UserDefaults.standard.set("0", forKey: "soccer")
        }
        self.refreshMusic()
        SoundService.shared.playBGSound()
        
    }
    override  func setupUI() {
        super.setupUI()
        leftNav.isHidden = true
        setupButtons()
        soundOn = UserDefaults.standard.bool(forKey: "soundOn")
        self.refreshMusic()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let model = appDelegate.currentGameModel else {
            return
        }
        if model.isRestarting {
            self.changeGamePage()
            model.isRestarting = false
            
        }
        
        if model.isNexting {
            self.changeGamePage()
            model.isNexting = false
        }
        else{
            appDelegate.totalLives = 5
        }
        
    }
    
    func changeGamePage(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let gameModel = appDelegate.currentGameModel
        guard let model = gameModel else {
            return
        }
        
        let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        
        if model.isNexting{
            model.number += 1
        }
        vc.viewModel = GameViewModel(gameModel: model)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    @IBAction func toggleMusic(){
        SoundService.shared.soundOn = !SoundService.shared.soundOn
        self.refreshMusic()
        SoundService.shared.playBGSound()
    }
    
    func refreshMusic(){
        if SoundService.shared.soundOn{
            musicButton.setImage(UIImage(named: "open"), for: .normal)
        }
        else{
            musicButton.setImage(UIImage(named: "turn_off"), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupButtons(){
        let images = ["creator_mode","stage_mode","ball","？","open",]
        let buttons = Utils.getButtonsIn(view: self.view)
        for button in buttons{
            
            button.removeTarget(nil, action: nil, for: .allEvents)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
            
            let image = UIImage(named:images[button.tag])!
            button.setImage(image, for: .normal)
            button.widthConstaint?.constant = max(image.size.width,44)
            button.heightConstaint?.constant = max(image.size.height,44)
        }
        
        self.setAppFontToAll()
        
    }
    
    @objc @IBAction override func buttonTapped(_ sender:Any?){
        let button = sender as! UIButton
        if button.tag < 2{
            let storyboard = UIStoryboard(name: "GameViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            
            let gameModel = GameModel.setupCurrentGameModel(level: GameLevel.allCases[button.tag], number: 0)
            vc.viewModel = GameViewModel(gameModel: gameModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if button.tag == 2{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SelectBackgroundViewController") as! SelectBackgroundViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if button.tag == 3{
            let storyboard = UIStoryboard(name: "InformationViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InformationViewController") as! InformationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if button.tag == 4{
            self.toggleMusic()
        }
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {}
    
}

