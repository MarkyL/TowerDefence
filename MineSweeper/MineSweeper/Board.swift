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
    
    
    func initBoard(){
        
        for i in 0...self.rows - 1 {
            for j in 0...self.cols - 1 {
                self.cellsGrid[i][j] = Cell(row: i, col: j, hasMine: false)
            }
        }
        placeMines()
        addNeighbors()
        
    }
    

    func placeMines(){
        var minesCounter = 0
        var row = 0
        var col = 0
        while minesCounter < self.minesAmount {
            row = Int(arc4random_uniform(UInt32(self.rows)))
            col = Int(arc4random_uniform(UInt32(self.cols)))
            let c = self.cellsGrid[row][col]
            if !c.hasMine{
               c.toggleMine()
               minesCounter+=1
            }
        }
    }
    
    
    func addNeighbors(){
        for x in 0...self.rows {
            for y in 0...self.cols {
                let cell = self.cellsGrid[x][y]
                let cellX = cell.row
                let cellY = cell.col
                for i in cellX-1...cellX+1 {
                    for j in cellY-1...cellY+1 {
                        if i >= 0 && i < self.rows && j >= 0 && j < self.cols {
                            cell.addNeighbor(neighbor: self.cellsGrid[i][j])
                        }
                    }
                }
            }
        }
    }
    
    func setFlag(cell : Cell) {
        
        if !cell.isOpened{
            cell.toggleFlag()
        }
    }
    
    func reveal(cell : Cell) -> Bool {
        cell.reveal()
        if !cell.hasMine {
            self.cellsRevealed+=1
            if cell.neighborMineCount == 0 {
                let neighbors = cell.neighbors
                for neighbor in neighbors {
                    if !neighbor.isOpened {
                        _ = reveal(cell: neighbor)
                    }
                }
            }
        }
        
        return cell.hasMine
    }
    
    func showBombs(){
        for i in 0...self.rows {
            for j in 0...self.cols {
                let cell = self.cellsGrid[i][j]
                if cell.hasMine && !cell.isOpened {
                    cell.reveal()
                }
            }
        }
    }
    
    

}
