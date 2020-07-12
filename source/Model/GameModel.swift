//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//

import UIKit

enum GameLevel: String, CaseIterable {
    case simple,general,difficult
}

class GameModel {
    
    var isRestarting = false
    var isNexting = false
    var scores:Int = 0
    var countdownSeconds:Int {
        let dict:[GameLevel:Int] = [
            GameLevel.simple:30,
            GameLevel.general:30,
            GameLevel.difficult:30
        ]
        return dict[level]!
    }
    
    //game difficulty
    var level:GameLevel = .simple
    
    //level number in each difficulty
    var number:Int = 0
    
    init(level:GameLevel,number:Int,isRestarting:Bool=false){
        self.level = level
        self.number = number
        self.isRestarting = isRestarting
    }
    
    class func setupCurrentGameModel(level:GameLevel,number:Int,isRestarting:Bool=false) -> GameModel{
        let gameModel = GameModel(level: level, number: 0)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.currentGameModel = gameModel
        return gameModel
    }
    
    static let ballImages = ["ball1","ball2","ball3"]
}
