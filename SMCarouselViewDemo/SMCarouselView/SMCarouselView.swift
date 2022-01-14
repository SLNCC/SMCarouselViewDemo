//
//  SMCarouselView.swift
//  Keyboard
//
//  Created by a on 2021/4/22.
//

import UIKit

protocol SMCarouselViewDelegate: NSObjectProtocol {
   func mCarouselView(_ carouselView: SMCarouselView, didSelectItemAt index: Int);
}

class SMCarouselView: UIView {
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 0)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collection.backgroundColor = UIColor.white
        collection.delegate = self
        collection.dataSource = self
        collection.isPagingEnabled = true
        collection.bounces = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(SMCarouselCell.self, forCellWithReuseIdentifier: "SMCarouselCell")
        return collection
    }()
    
    private lazy var pageControl: SMPageControl = {
        let pageControl = SMPageControl()
        return pageControl
    }()
    
    private var timer: Timer? = nil
    private let autoTimeInterval: TimeInterval = 2
    private var isAutoScroll: Bool = false
    private var dataArray = [String]()
    private var maxCount = 0
    
    weak var mCarouselViewDelegate: SMCarouselViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.collectionView)
        self.addSubview(self.pageControl)

        setTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
        self.pageControl.frame = CGRect(x: 0, y:  self.bounds.size.height - 15, width:  self.bounds.size.width - 8, height: 10)
    }
    
    func setDataArray(dataArray: [String]) {
        guard dataArray.count > 0 else {
            return
        }
        if self.dataArray.count == dataArray.count,
             let oldSet = NSSet.init(array: self.dataArray) as? Set<String>,
             let newSet = NSSet.init(array: dataArray) as? Set<String> {
              let symmetricSet = oldSet.symmetricDifference(newSet)
              if symmetricSet.count == 0 {
                  return
              }
        }
        self.dataArray = dataArray
        maxCount = self.dataArray.count
        isAutoScroll = self.dataArray.count == 1 ? false : true
        if isAutoScroll {
            self.pageControl.numberOfPages = maxCount
            setTimer()
        }else {
            removeTimer()
            self.pageControl.numberOfPages = 0
        }
        self.collectionView.reloadData()
    }
    
    private func setTimer() {
        if self.timer == nil {
            let timer = Timer(timeInterval: autoTimeInterval, repeats: true, block: { [weak self] (_) in
                self?.nextPage()
            })
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
            self.timer = timer
        }
    }
    
    private func nextPage() {
        if let currentIndexPath = collectionView.indexPathsForVisibleItems.last {
            lastVisibleItemHandle(currentIndexPath: currentIndexPath)
            var nextItem = currentIndexPath.item + 1
            var section = 0
            if (nextItem == maxCount) {
                nextItem = 0
                section = 1
            }
            let nextIndexPath = IndexPath(item: nextItem, section: section)
            scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
    }
    
    private func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
    }
    
    private func lastVisibleItemHandle(currentIndexPath: IndexPath) {
        scrollToItem(at: IndexPath(item: currentIndexPath.item, section: 0), at: .left, animated: false)
    }
    
    private func removeTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    private func resumeTimer() {
        setTimer()
    }
     
    private func getCurrentIndex(scrollView: UIScrollView) -> Int {
        let currentIndex = Int((scrollView.contentOffset.x/scrollView.frame.size.width + 0.5)) % maxCount
        return currentIndex
    }
    
}

extension SMCarouselView: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isAutoScroll ? 2 : 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SMCarouselCell", for: indexPath)
        if let cell1 = cell as? SMCarouselCell {
//            if let str = self.dataArray[safe: indexPath.item] {
////                cell1.imageView.sd_setImage(with: URL(string: str), placeholderImage: nil)
//            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.mCarouselViewDelegate?.mCarouselView(self, didSelectItemAt: indexPath.item)
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if isAutoScroll {
            removeTimer()
            if (maxCount - 1 == getCurrentIndex(scrollView: scrollView)) {
                if let currentIndexPath = collectionView.indexPathsForVisibleItems.last {
                    lastVisibleItemHandle(currentIndexPath: currentIndexPath)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if isAutoScroll {
            resumeTimer()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isAutoScroll {
            let currentIndex = getCurrentIndex(scrollView: scrollView)
            self.pageControl.currentPage = currentIndex
        }
    }

}
