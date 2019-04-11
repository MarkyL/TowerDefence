//
//  Cell.swift
//  MineSweeper
//
//  Created by Omri Ohayon on 09/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import Foundation


// Represents a MineSweeper cell.
class Cell{
    
    var col : Int
    var row : Int
    var isOpened : Bool
    var hasFlag : Bool
    var hasMine : Bool
    var neighborMineCount : Int
    var neighbors : [Cell]
    
    init(row : Int,col:Int,hasMine : Bool) {
        self.col = col
        self.row = row
        self.isOpened = false
        self.hasFlag = false
        self.hasMine = hasMine
        self.neighborMineCount = 0
        self.neighbors = [Cell]();
    }
    
    // Add a neighbor and increment neighborMineCount if needed.
    func addNeighbor(neighbor : Cell){
        self.neighbors.append(neighbor)
        if neighbor.hasMine {
            neighborMineCount+=1
        }
    }
    
    
    // Reveal this cell
    func reveal() {
        self.isOpened = true
    }
    
    // Toggle flag
    func toggleFlag() {
        self.hasFlag = !self.hasFlag
    }
    
    func toggleMine(){
        self.hasMine = !self.hasMine
    }
    
    func getIsOpened() -> Bool {
        return isOpened
    }
    
}


