//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
extension SelectBackgroundViewController:GridDelegate{
    func cellFor(r: Int, c: Int) -> UIView {
        let view = UIView()
        //view.backgroundColor = .white
        let images = GameModel.ballImages
        let idx = c + r * 2
        let box = SkinView(imageName: images[idx])
        box.tag = idx
        view.addSubview(box)
        let padding:CGFloat = 0
        box.snp.makeConstraints { (make) in
            make.edges.equalTo(view).inset(UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding))
        }
        
        box.button.rx.tap.subscribe(onNext: { _ in
            self.gridTapped(box.button)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: bag)
        
        return view
    }
    
    @objc func gridTapped(_ button:UIButton){
        let skin = button.superview as! SkinView
        let image = String(skin.tag)
        
        UserDefaults.standard.set(image, forKey: "soccer")
        
        self.setupGrid()
    }
}

class SelectBackgroundViewController: BaseViewController {
    
    let bag = DisposeBag()
    @IBOutlet weak var starLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let score1 = UserDefaults.standard.integer(forKey: GameLevel.simple.rawValue) + 1
        let score2 = UserDefaults.standard.integer(forKey: GameLevel.general.rawValue) + 1
        
        //testdata
        //let maxScore = 60
        let maxScore = max(score1,score2)
        starLabel.text = "Max level: \(maxScore)"
        starLabel.textColor = Utils.colorFromRGB(colors: [254, 204, 47])
        
    }
    
    private var gridView:GridView!
    private func setupGrid(){
        if gridView != nil{
            gridView.removeFromSuperview()
        }
        gridView = GridView(row: 1, column: 3, delegate:self , padding:20, rowPadding: 20, aspectRatio: 0)
        self.view.addSubview(gridView)
        var margin:CGFloat = 40
        if UIScreen.main.bounds.size.width == 320{
            margin = 0
        }
        
        var height:CGFloat = 280
        if UIScreen.main.bounds.size.width == 320{
            height = 280
        }
        gridView.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self.view)
            make.left.equalTo(margin)
            make.right.equalTo(-margin)
            make.height.equalTo(height)
            
        }
        
        self.setAppFontToAll()
        
    }
    @IBOutlet weak var stackView: UIStackView!
    private func setupButtons(){
        if gridView != nil{
            for v in gridView.subviews{
                v.removeFromSuperview()
            }
        }
        
        setupGrid()
        
    }
    override func setupUI() {
        super.setupUI()
        self.setupButtons()
        
    }
}
