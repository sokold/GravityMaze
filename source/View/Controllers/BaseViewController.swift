//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//

import UIKit
import SnapKit
class BaseViewController: UIViewController {
    var bgName = "background"
    var leftNav:UIButton!
    var titleLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: bgName))
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        self.view.insertSubview(imageView, at: 0)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets.zero)
        }
        
    }
    var soundOn = false
    var loaded = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !loaded{
            self.setupUI()
            loaded = true
        }
        
    }
    
    func setupUI() {
        
        titleLabel = UILabel()
        self.view.addSubview(titleLabel)
        titleLabel.font =  UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = Utils.colorFromRGB(colors: [69, 144, 83])
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(44)
        }
        titleLabel.text = ""
        titleLabel.isHidden = true
        
        leftNav = UIButton()
        leftNav.setImage(UIImage(named: "return"), for: .normal)
        leftNav.addTarget(self, action: #selector(back(_:)), for: .touchDown)
        self.view.addSubview(leftNav)
        
        leftNav.snp.makeConstraints { (make) in
            make.top.equalTo(self.topLayoutGuide.snp.bottom)
            make.left.equalTo(view).offset(10)
            make.width.height.equalTo(44)
        }
        leftNav.isHidden = false
        
    }
    
    func setupButtonsFor(stackView:UIStackView){
        for (index,view) in stackView.subviews.enumerated(){
            let button = view as! UIButton
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchDown)
        }
    }
    
    @objc func buttonTapped(_ sender:Any?){
        
    }
    
    @objc func back(_ sender:Any?){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setAppFontToAll(){
        let labels = Utils.getLabelsIn(view: self.view)
        for label in labels{
            self.setAppFontTo(label: label)
        }
        
    }
    
    func setAppFontTo(label:UILabel){
        let size = label.font.pointSize
        label.font = Utils.appFont(size: size)
    }
}
