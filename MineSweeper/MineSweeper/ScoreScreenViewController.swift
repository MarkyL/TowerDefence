//
//  ScoreScreenViewController.swift
//  MineSweeper
//
//  Created by Omri Ohayon on 11/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit

class ScoreScreenViewController: UIViewController, UITableViewDataSource{


    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    
    var scoreData : [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        guard let arr = UserDefaults.standard.array(forKey: "scoreData") as? [String] else { return }
        self.scoreData = arr
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoreData.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyTableCell
        
        let scoreStr = self.scoreData[self.scoreData.count-1-indexPath.row]
        let scoreArr = scoreStr.components(separatedBy: "_")
        if scoreArr.count == 3 {
            cell.userNamelbl.text = scoreArr[0]
            cell.scorelbl.text = scoreArr[1]
            cell.datelbl.text = scoreArr[2]
        }
        
        return cell
    }
}
