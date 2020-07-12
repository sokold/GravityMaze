//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit
import RxRelay

class GameViewModel {
    let gameModel:BehaviorRelay<GameModel>
    init(gameModel:GameModel){
        self.gameModel = BehaviorRelay<GameModel>(value: gameModel)
        self.seconds.accept(gameModel.countdownSeconds)
    }
    
    var seconds:BehaviorRelay<Int> =  BehaviorRelay<Int>(value: 0)
    private var countdownTimer:Timer?
    func createCountdownTimer(){
        
        let frequency:TimeInterval = 1
        countdownTimer = Timer.scheduledTimer(withTimeInterval: frequency, repeats: true, block: { [weak self] t in
            self?.checkCountdown()
        })
    }
    
    @objc private func checkCountdown(){
        var sec = seconds.value
        sec -= 1
        if sec <= 0{
            sec = 0
        }
        seconds.accept(sec)
    }
    
    deinit {
        countdownTimer?.invalidate()
    }
    
}
