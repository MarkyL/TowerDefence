//
//  Board.swift
//  MineSweeper
//
//  Created by Omri Ohayon on 09/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import Foundation

class Board{
    
    var rows : Int
    var cols : Int
    var cellsRevealed : Int
    var cellsGrid : [[Cell]]
    var minesAmount : Int
    
    init(rows : Int , cols : Int , minesAmount : Int) {
        self.rows = rows
        self.cols = cols
        self.minesAmount = minesAmount
        self.cellsRevealed = 0
        self.cellsGrid = [[Cell]]()
    }
    
    
    func resetBoard(){
        var minesCounter = 0
        for i in 0...self.rows {
            for j in 0...self.cols {
                if minesCounter < self.minesAmount && randomBool() {
                    self.cellsGrid[i][j] = Cell(row: i, col: j, hasMine: true)
                    minesCounter+=1
                } else {
                    self.cellsGrid[i][j] = Cell(row: i, col: j, hasMine: false)
                }
            }
        }
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    
    
}
