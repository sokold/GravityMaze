//  Created by Ross Chen on 2020/6/11.
//  Copyright © 2020 Ross Chen. All rights reserved.
//
import UIKit

class InformationViewController: BaseViewController {
    var isDescribe = false
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        contentView.layer.cornerRadius = 15
        
        super.viewDidLoad()
        
        textView.font = Utils.appFont(size: 19)
        textView.textColor = Utils.colorFromRGB(colors: [254, 204, 47])
        
    }
    
    override func setupUI() {
        super.setupUI()
        
    }
    
}
