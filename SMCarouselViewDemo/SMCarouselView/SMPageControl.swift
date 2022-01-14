//
//  SMPageControl.swift
//  Keyboard
//
//  Created by a on 2021/4/23.
//

import UIKit

class SMPageControl: UIView {
    private let scrollView = UIScrollView()
    private let space: CGFloat = 8

    /// numberOfPages--数量尽量小
    open var numberOfPages: Int = 0 {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    open var currentPage: Int = 0 {
        didSet {
            guard self.numberOfPages > 0 else {
                return
            }
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    open var currentPageImage = UIImage.imageWithColor(UIColor(hex: "1F59EE")!,size: CGSize(width: 14, height: 4))
    open var pageImage = UIImage.imageWithColor(UIColor.white.withAlphaComponent(0.5),size: CGSize(width: 4, height: 4))

    override init(frame: CGRect) {
        super.init(frame: frame)
        let button = createButton()
        self.addSubview(scrollView)
        scrollView.addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        //old 
        var subviews = getButtons(scrollView)
        guard numberOfPages > 0 else {
            self.deleteButtons(subviews)
            return
        }
        //add
        let count = numberOfPages - subviews.count
        if count > 0 {
            for _ in 0..<count {
                scrollView.addSubview(createButton())
            }
        }
        //total
        subviews = getButtons(scrollView)
        var maxCount = subviews.count
        if maxCount - numberOfPages > 0 {
            for i in numberOfPages..<maxCount {
                subviews[i].removeFromSuperview()
            }
            maxCount = numberOfPages
        }
        
        let size = pageImage.size
        let selectedSize = currentPageImage.size
        let margin = space
        let contentWidth = CGFloat(maxCount - 1)*(size.width + margin) + selectedSize.width
        var originX: CGFloat = self.bounds.size.width - contentWidth
        if originX < 0 {
            originX = 0
        }
        for i in 0..<maxCount {
            if let item = subviews[i] as? UIButton {
                item.isSelected = false
                if i == currentPage {
                    item.isSelected = true
                    item.frame = CGRect(origin: CGPoint(x: originX, y: 0), size: selectedSize)
                }else {
                    item.frame = CGRect(origin: CGPoint(x: originX, y: 0), size: size)
                }
                updateButton(item)
                originX += margin + (i == currentPage ? selectedSize.width : size.width)
            }
        }
    }
    
    private func deleteButtons(_ views: [UIView]) {
        if views.count - 5 > 0 {
            for i in 5..<views.count {
                views[i].removeFromSuperview()
            }
        }
        for view in views {
            view.isHidden = true
        }
        currentPage = 0
    }
    
    private func getButtons(_ subSuper: UIView) -> [UIView] {
       return subSuper.subviews.filter({ (view) -> Bool in
            return (view as? UIButton != nil)
        })
    }
    
    private func updateButton(_ btn: UIButton) {
        if ((btn.image(for: .selected) != currentPageImage) || btn.image(for: .normal) != pageImage) {
            btn.setImage(currentPageImage, for: .selected)
            btn.setImage(pageImage, for: .normal)
        }
        if btn.isHidden == true {
            btn.isHidden = false
        }
    }
    
    private func createButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(pageImage, for: .normal)
        button.setImage(currentPageImage, for: .selected)
        button.layer.cornerRadius = 2
        button.layer.masksToBounds = true
        return button
    }
}

extension UIImage {
    
    class func imageWithColor(_ color: UIColor ,size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size:size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    convenience init?(hex: String, alpha: CGFloat = 1.0) {
        guard hex.count >= 6 else {
            return nil
        }
        var hexString = hex.uppercased()
        if (hexString.hasPrefix("##") || hexString.hasPrefix("0x")) {
            hexString = (hexString as NSString).substring(from: 2)
        }
        if (hexString.hasPrefix("#")) {
            hexString = (hexString as NSString).substring(from: 1)
        }
        var range = NSRange(location: 0, length: 2)
        let rStr = (hexString as NSString).substring(with: range)
        range.location = 2
        let gStr = (hexString as NSString).substring(with: range)
        range.location = 4
        let bStr = (hexString as NSString).substring(with: range)
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
        
    }
}
