//
//  RefreshView.swift
//  RefreshSwift
//
//  Created by Calvin on 2017/8/10.
//  Copyright © 2017年 Calvin. All rights reserved.
//

import UIKit

protocol RefreshViewDelegate: class {
    func refreshViewDidRefresh(refreshView: RefreshView)
}

private let kScreenHeight:CGFloat = 120

class RefreshView: UIView,UIScrollViewDelegate{

    private unowned var scrollView : UIScrollView
    private var progress: CGFloat = 0.0
    
    var refreshItems = [RefreshItem]()
    weak var delegate: RefreshViewDelegate?
    
    var isRefreshing = false
    
    init(frame:CGRect,scrollView: UIScrollView) {
        
        self.scrollView = scrollView
        super.init(frame: frame)
        updateBackgroundColor()
        setUpRefreshItems()
    }
    
    func setUpRefreshItems() {
        let groundImg = UIImageView(image: #imageLiteral(resourceName: "ground.png"))
        let buildingsImageView = UIImageView(image: #imageLiteral(resourceName: "buildings.png"))
        let sunImageView = UIImageView(image: #imageLiteral(resourceName: "sun.png"))
        let catImageView = UIImageView(image: #imageLiteral(resourceName: "cat.png"))
        let capeBackImageView = UIImageView(image: #imageLiteral(resourceName: "cape_back.png"))
        let capeFrontImageView = UIImageView(image: #imageLiteral(resourceName: "cape_front.png"))
        
        refreshItems = [RefreshItem(view: buildingsImageView, centerEnd: CGPoint(x: bounds.width/2,y:bounds.height - groundImg.bounds.height - buildingsImageView.bounds.height / 2), parallaxRatio: 1.5, sceneHeight: kScreenHeight),
                       
            RefreshItem(view: sunImageView,centerEnd: CGPoint(x: bounds.width * 0.1,y: bounds.height - groundImg.bounds.height - sunImageView.bounds.height),parallaxRatio: 3, sceneHeight: kScreenHeight),
            
            RefreshItem(view: groundImg,centerEnd: CGPoint(x: bounds.width/2,y: bounds.height - groundImg.bounds.height/2),parallaxRatio: 0.5, sceneHeight: kScreenHeight),
            
            RefreshItem(view: capeBackImageView, centerEnd: CGPoint(x: bounds.width/2, y: bounds.height - groundImg.bounds.height/2 - capeBackImageView.bounds.height/2), parallaxRatio: -1, sceneHeight: kScreenHeight),
            
            RefreshItem(view: catImageView, centerEnd: CGPoint(x: bounds.width/2, y: bounds.height - groundImg.bounds.height/2 - catImageView.bounds.height/2), parallaxRatio: 1, sceneHeight: kScreenHeight),
            
            RefreshItem(view: capeFrontImageView, centerEnd: CGPoint(x: bounds.width/2, y: bounds.height - groundImg.bounds.height/2 - capeFrontImageView.bounds.height/2), parallaxRatio: -1, sceneHeight: kScreenHeight),
        ]
        
        for RefreshItem in refreshItems {
            addSubview(RefreshItem.view)
        }
    }
    
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { 
            self.scrollView.contentInset.top += kScreenHeight
        }, completion: nil)
    }
    
    
    func endRefreshing() {

        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { 
            self.scrollView.contentInset.top -= kScreenHeight
        }) { (_) in
            self.isRefreshing = false
        }
    }
    
    func updateRefreshItemPosition() {
        
        for RefreshItem in refreshItems {
            RefreshItem.updateViewPositionForPercentage(percentage: progress)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(code:) has not been implemented")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isRefreshing {
            return
        }
        
        let refreshViewVisibleHeight = max(0, -scrollView.contentOffset.y-scrollView.contentInset.top)
        progress = min(1, refreshViewVisibleHeight / kScreenHeight)
        updateBackgroundColor()
        updateRefreshItemPosition()
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if !isRefreshing && progress == 1 {
            
            beginRefreshing()
//            targetContentOffset.memory.y = -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(refreshView: self)
        }
    }
    
    func updateBackgroundColor() {
        
        backgroundColor = UIColor(white: 0.7 * progress + 0.2, alpha: 1.0)
    }

}
