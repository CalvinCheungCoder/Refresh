//
//  RefreshingTableViewController.swift
//  RefreshSwift
//
//  Created by Calvin on 2017/8/10.
//  Copyright © 2017年 Calvin. All rights reserved.
//

import UIKit

private let kRefreshViewHeight: CGFloat = 200

class RefreshingTableViewController: UITableViewController ,RefreshViewDelegate{

    private var refreshView: RefreshView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshView = RefreshView(frame: CGRect(x:0,y: -kRefreshViewHeight,width: view.bounds.width,height:kRefreshViewHeight ), scrollView: tableView)
        refreshView.delegate = self
        view.insertSubview(refreshView, at: 0)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView: scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    func refreshViewDidRefresh(refreshView: RefreshView) {
        
        sleep(3)
        refreshView.endRefreshing()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.text = "第 \(indexPath.row+1) 行"
        return cell
    }
}
