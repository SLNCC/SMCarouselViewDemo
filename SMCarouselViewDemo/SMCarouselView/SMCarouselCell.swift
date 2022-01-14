//
//  SMCarouselCell.swift
//  Keyboard
//
//  Created by a on 2021/4/22.
//

import UIKit

class SMCarouselCell: UICollectionViewCell {
    let imageView = UIImageView()
    private let tagLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
        
        tagLabel.text = "广告"
        tagLabel.font = UIFont.systemFont(ofSize: 9)
        tagLabel.textAlignment = .center
        tagLabel.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        tagLabel.textColor = .white
        self.contentView.addSubview(tagLabel)
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0 , width: 28, height: 13), byRoundingCorners: UIRectCorner.topRight, cornerRadii: CGSize(width: 4, height: 4))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        tagLabel.layer.mask = shapeLayer
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        tagLabel.frame = CGRect(x: 0, y: self.bounds.size.height - 13, width: 28, height: 13)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
