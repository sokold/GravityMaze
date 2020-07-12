//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit
import AVFoundation

class SoundService {
    static let shared = SoundService()
    private init() {
        let firstTime = UserDefaults.standard.string(forKey: "firstTime")
        if firstTime == nil{
            UserDefaults.standard.set("0", forKey: "firstTime")
            soundOn = true
        }
        else{
            soundOn =  UserDefaults.standard.bool(forKey: "soundOn")
        }
    }
    
    var soundOn = false{
        didSet{
            UserDefaults.standard.set(soundOn, forKey: "soundOn")
        }
    }
    
    private var player: AVAudioPlayer?
    private var player2: AVAudioPlayer?
    
    func playBGSound() {
        if let url = Bundle.main.url(forResource: "bg", withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            
            if soundOn {
                player?.play()
            }
            else{
                player?.stop()
            }
        }
    }
    
    func playSoundEffectBingo() {
        self.playSoundEffect(name:"bingo")
    }
    
    func playSoundEffectPass() {
        self.playSoundEffect(name:"pass")
    }
    
    func playSoundEffectFail() {
        self.playSoundEffect(name:"fail")
    }
    
    func playSoundEffect(name:String) {
        
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            player2 = try? AVAudioPlayer(contentsOf: url)
            if soundOn {
                player2?.play()
            }
            
        }
    }
    
}
