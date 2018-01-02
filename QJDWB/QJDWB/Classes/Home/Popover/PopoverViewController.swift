//
//  PopoverViewController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/7.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
    }
}

extension PopoverViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "Popver"
        
        var cell = tableview.dequeueReusableCell(withIdentifier: cellID)
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellID)
        }
        
        cell?.textLabel?.text = "想要做的第 \(indexPath.row + 1) 件事"
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.textLabel?.textColor = UIColor.orange
        return cell!
    }
}
