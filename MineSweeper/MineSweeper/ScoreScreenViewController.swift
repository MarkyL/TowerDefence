//
//  ScoreScreenViewController.swift
//  MineSweeper
//
//  Created by Omri Ohayon on 11/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit

class ScoreScreenViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{


    // Don't forget to enter this in IB also
    let cellReuseIdentifier = "cell"
    
    let defaults = UserDefaults.standard
    //var rowCount : Int = 0
    var scoreData : [String] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //self.rowCount = defaults.integer(forKey: "rowCount")
        
        let arr = defaults.array(forKey: "scoreData") as? [String]
        if arr != nil{
            self.scoreData = arr!
        }
        
    
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scoreData.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyTableCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! MyTableCell
        
        let scoreStr = self.scoreData[indexPath.row]
        let scoreArr = scoreStr.components(separatedBy: "_")
        if scoreArr.count == 3 {
            cell.userNamelbl.text = scoreArr[0]
            cell.scorelbl.text = scoreArr[1]
            cell.datelbl.text = scoreArr[2]
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }
}




