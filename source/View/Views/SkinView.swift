//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit

class SkinView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    private  var imageName:String!
    required init(imageName:String){
        super.init(frame: .zero)
        self.imageName = imageName
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    var button:UIButton!
    var label:UILabel!
    private func setupView() {
        
        let margin:CGFloat = 0
        let _:UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "setting")
            self.addSubview(imageView)
            imageView.contentMode = .scaleAspectFit
            imageView.snp.makeConstraints { (make) in
                make.center.equalTo(self)
                make.width.equalTo(178)
                make.height.equalTo(200)
            }
            return imageView
        }()
        button = UIButton()
        button.setImage(UIImage(named: imageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        //button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
        self.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: margin+20, left: margin, bottom: 55, right: margin))
        }
        
        let scores = [0,10,20]
        
        let score1 = UserDefaults.standard.integer(forKey: GameLevel.simple.rawValue) + 1
        let score2 = UserDefaults.standard.integer(forKey: GameLevel.general.rawValue) + 1
        
        //testdata
        //let maxScore = 60
        let maxScore = max(score1,score2)
        let images = GameModel.ballImages
        
        let idx = images.firstIndex(of: imageName)!
        let bg = Int(UserDefaults.standard.string(forKey: "soccer") ?? "0" )
        let isUsing = idx == bg
        
        label = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = Utils.colorFromRGB(colors: [48, 79, 89])
            label.text = "Stage \(maxScore)/\(scores[idx])"
            if isUsing{
                label.text = "Selected"
                label.textColor = Utils.colorFromRGB(colors: [254, 204, 47])
            }
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
            label.font = UIFont.boldSystemFont(ofSize: 20)
            self.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.top.equalTo(button.snp.bottom).offset(0)
                make.left.right.equalTo(0)
                make.height.equalTo(40)
            }
            return label
        }()
        
        button.isEnabled = maxScore >= scores[idx]
        if !button.isEnabled{
            label.textColor = .lightGray
        }
    }
    
}
