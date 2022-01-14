//
//  ViewController.swift
//  SMCarouselViewDemo
//
//  Created by a on 2022/1/14.
//

import UIKit


class ViewController: UIViewController, SMCarouselViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let mCarouselView = SMCarouselView()
        mCarouselView.frame = CGRect(x: 16, y: 88, width: self.view.frame.size.width - 32, height: 108)
        mCarouselView.mCarouselViewDelegate = self
        self.view.addSubview(mCarouselView)
        
        mCarouselView.setDataArray(dataArray: ["https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2Ftp08%2F01042323313046.jpg","https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2Ftp01%2F1ZZQ233331308-0-lp.jpg","https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.jj20.com%2Fup%2Fallimg%2Ftp05%2F1910020Z64a922-0-lp.jpg&refer=http%3A%2F%2Fimg.jj20.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg"])
    }

    func mCarouselView(_ carouselView: SMCarouselView, didSelectItemAt index: Int) {
        
    }
}


