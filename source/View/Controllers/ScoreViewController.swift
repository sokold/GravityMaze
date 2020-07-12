//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit

class ScoreViewController: BaseViewController {
    var level:GameLevel = .simple
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    //  @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView1: UIImageView!
    //@IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreHintLabel: UILabel!
    
    // @IBOutlet weak var stackView: UIStackView!
    var isSucceeded = false
    var score:Int!
    var number:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isSucceeded{
            scoreHintLabel.textColor = Utils.colorFromRGB(colors: [254, 191, 45]) 
        }
        
        scoreLabel.text =  "Stage " + String(score+1)
        //scoreLabel.textColor = Utils.colorFromRGB(colors: [36, 194, 213])
        
        leftButton.titleLabel!.font = Utils.appFont(size: 21)
        rightButton.titleLabel!.font = Utils.appFont(size: 21)
        
    }
    
    @IBAction private func leftButtonTapped(_ sender: Any) {
        if isSucceeded{
            self.next(sender)
        }
        else{
            self.restartGame(sender)
        }
    }
    
    override  func setupUI() {
        super.setupUI()
        leftNav.isHidden = true
        
        if isSucceeded{
            scoreHintLabel.text = "Well Done"
            leftButton.setTitle("Next", for: .normal)
        }
        
        self.setAppFontToAll()
        
    }
    
    @IBAction private func restartGame(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentGameModel?.isRestarting = true
        
        let vcs = self.navigationController?.viewControllers
        self.navigationController?.popToViewController(vcs![vcs!.count - 3], animated: false)
        
    }
    
    @IBAction private func next(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentGameModel?.isNexting = true
        
        let vcs = self.navigationController?.viewControllers
        self.navigationController?.popToViewController(vcs![vcs!.count - 3], animated: false)
        
    }
}
