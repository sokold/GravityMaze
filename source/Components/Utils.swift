//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit

class Utils: NSObject {
    static func randomInRange(range: Range<Int>) -> Int {
        let count = UInt32(range.endIndex - range.startIndex)
        return  Int(arc4random_uniform(count)) + range.startIndex
    }
    
    static func colorFromRGB(colors:[CGFloat]) -> UIColor{
        return UIColor(red: colors[0]/255.0, green: colors[1]/255.0, blue: colors[2]/255.0, alpha: 1)
        
    }
    static func getLabelsIn(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsIn(view: subview)
            }
        }
        return results
    }
    
    static func getButtonsIn(view: UIView) -> [UIButton] {
        var results = [UIButton]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UIButton {
                results += [labelView]
            } else {
                results += getButtonsIn(view: subview)
            }
        }
        return results
    }
    
    static func appFont(size:CGFloat) -> UIFont?{
        return UIFont(name: "MarkerFelt-Thin", size: size)
    }
    
    static func readTxt(name:String) -> String{
        var contents = ""
        if let filepath = Bundle.main.path(forResource: name, ofType: "txt") {
            do {
                contents = try String(contentsOfFile: filepath)
            } catch {
            }
        } else {
        }
        
        return contents
    }
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
    
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}
extension UIView{
    
    func fadeOut(){
        self.alpha = 1
        self.isHidden = false
        UIView.animate(withDuration: 2, animations: {
            self.alpha = 0
        }) { (Bool) in
            self.isHidden = true
        }
        
    }
    
    func removeSubviews(){
        for v in self.subviews{
            v.removeFromSuperview()
        }
    }
    
    func setAnchorPoint(anchorPoint: CGPoint) {
        
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position : CGPoint = self.layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x;
        
        position.y -= oldPoint.y;
        position.y += newPoint.y;
        
        self.layer.position = position;
        self.layer.anchorPoint = anchorPoint;
    }
    var heightConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    var widthConstaint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
}

extension Int {
    var boolValue: Bool { return self != 0 }
    init(_ bool:Bool) {
        self = bool ? 1 : 0
    }
}

