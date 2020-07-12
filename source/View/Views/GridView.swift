//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit

protocol GridDelegate:class {
    func cellFor(r:Int,c:Int) -> UIView
}

class GridView: UIView {
    weak var delegate:GridDelegate?
    
    var row:Int!
    var column:Int!
    private var padding:CGFloat!
    private var width:CGFloat = 0
    
    private var rowPadding:CGFloat!
    private var aspectRatio:Int!
    func allCells() -> [UIView]{
        var all = [UIView]()
        for view in self.subviews{
            if view.subviews.count == 1{
                all.append(view.subviews.first!)
            }
        }
        return all
        
    }
    required init(row:Int, column:Int, delegate:GridDelegate, padding:CGFloat=20,rowPadding:CGFloat=20,aspectRatio:Int=1){
        super.init(frame: .zero)
        self.row = row
        self.column = column
        self.aspectRatio = aspectRatio
        self.padding = padding
        self.rowPadding = rowPadding
        self.delegate = delegate
        setupView()
        
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func reloadData(){
        self.superview!.layoutIfNeeded()
        self.setupView()
        if aspectRatio == 1{
            self.refreshFrame()
        }
    }
    
    func refreshFrame(){
        let height = self.frame.size.width + CGFloat(row - column) * (self.padding + self.width) + (self.rowPadding - self.padding) * CGFloat(row-1)
        self.snp.updateConstraints { (make) in
            make.height.equalTo(height)
            
        }
    }
    
    func viewAt(r:Int,c:Int) -> UIView?{
        let tag = c + r * column
        for v in self.subviews{
            if v.tag == tag{
                return v
            }
        }
        return nil
    }
    private func setupView() {
        for r in 0..<row{
            for c in 0..<column{
                let view = delegate!.cellFor(r: r, c: c)
                view.tag = c + r * column
                self.addSubview(view)
            }
        }
    }
    override func layoutSubviews() {
        
        let f = self.frame
        let w = f.size.width
        let h = f.size.height
        let width = (w - CGFloat(column + 1) * padding)/CGFloat(column)
        var height = (h - CGFloat(row + 1) * padding)/CGFloat(row)
        if aspectRatio == 1{
            height = width
        }
        self.width = width
        
        for r in 0..<row{
            for c in 0..<column{
                let view = self.viewAt(r: r, c: c)!
                view.snp.makeConstraints { (make) in
                    make.left.equalTo(padding + CGFloat(c)*(padding+width))
                    make.top.equalTo(padding + CGFloat(r)*(rowPadding+height))
                    make.width.equalTo(width)
                    make.height.equalTo(height)
                }
            }
        }
    }
    
}
