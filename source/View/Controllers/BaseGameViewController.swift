//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class BaseGameViewController: BaseViewController {
    var level:GameLevel = .simple
    
    var scores:Int = 0{
        didSet{
            if scoreLabel == nil {return}
            scoreLabel.text = String(scores)
        }
    }
    var number:Int = 0{
        didSet{
            if numberLabel == nil {return}
            numberLabel.text =  "Stage \(number+1)"
        }
    }
    var isSucceeded = false
    let bag = DisposeBag()
    var isGaming = false
    
    var viewModel:GameViewModel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBinding()
    }
    
    func setupBinding(){
        
        viewModel.gameModel.subscribe(onNext: { [weak self] gameModel in
            self?.level = gameModel.level
            self?.number = gameModel.number
            self?.scores = gameModel.scores
            
        }).disposed(by: bag)
        
    }
    func gameFailed(){
        self.showScore()
        isGaming = false
    }
    
    func showScore(){
        if !isGaming{
            return
        }
        
        var scoreList = UserDefaults.standard.array(forKey: self.level.rawValue) ?? [Int]()
        scoreList.append(scores)
        let sortListInt = scoreList as! [Int]
        let sorted = sortListInt.sorted(by: {$0 > $1})
        UserDefaults.standard.set(sorted, forKey: self.level.rawValue)
        
        let storyboard = UIStoryboard(name: "ScoreViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ScoreViewController") as! ScoreViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
