//
//  ViewController.swift
//  RedditTest
//
//  Created by Fabio Bermudez on 29/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    //MARK: - Outlets

    @IBOutlet weak var table: UITableView!
    
    //MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.rowHeight = UITableViewAutomaticDimension;
        self.table.estimatedRowHeight = 80;
        self.table.addSubview(self.refreshControl)
    }
    
    override func reloadView() {
        DispatchQueue.main.async(execute: {
            super.reloadView()
            self.table.reloadData()
        })
    }
    
    // MARK: - Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feedModelView.getElementsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let object = self.feedModelView.getElementForRow(row: indexPath.row)
        cell.setModel(object,delegate:self)
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - self.table.frame.size.height
        if actualPosition > contentHeight && self.refreshControl.isRefreshing == false {
            self.feedModelView.requestData(reload: false, callBack: { 
                self.reloadView()
            })
        }
    }

}

