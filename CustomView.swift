//
//  CustomView.swift
//  ChatApp
//
//  Created by user on 2023/12/07.
//

import Foundation
import UIKit

class InsetLabel: UILabel {
    var contentInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        return addInsets(to: super.intrinsicContentSize)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return addInsets(to: super.sizeThatFits(size))
    }
    
    private func addInsets(to size: CGSize) -> CGSize {
        let width = size.width + contentInsets.left + contentInsets.right
        let height = size.height + contentInsets.top + contentInsets.bottom
        return CGSize(width: width, height: height)
    }
}
//-----------------------------------------------------
class InputView: UIView {
    
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    
    var delegate:InputViewDelegate!
    // コードから生成した時の初期化処理
    override init(frame: CGRect){
        super.init(frame: frame)
        self.setFromXib()
        autoresizingMask = .flexibleHeight
    }
//エラーでてしまう
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setFromXib()
    }
    
    
    @IBAction func onSend(_ sender: Any) {
        delegate.sendTapped(text: chatTextField.text!)
        chatTextField.text = ""
    }
    
    func setFromXib(){
        let nib = UINib.init(nibName: "InputView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        self.addSubview(view)
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
}

//protocol InputViewDelegate:class {
//    func sendTapped(text:String)
//}
protocol InputViewDelegate:AnyObject {
    func sendTapped(text:String)
}

extension UIImage {
    func resize(toWidth width: CGFloat) -> UIImage? {
        let resizedSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
