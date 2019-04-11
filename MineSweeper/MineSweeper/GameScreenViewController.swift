//
//  GameScreenViewController.swift
//  MineSweeper
//
//  Created by Mark Lurie on 09/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit

class GameScreenViewController: UIViewController {

    @IBOutlet weak var userNameText: UITextView!
    @IBOutlet weak var someBtn: UIButton!
    
    var recievedUserName : String = "INITIAL TEXT"
    var recievedDifficulty : DifficultyType = DifficultyType.EASY
    
    var score = 0
    var isGameOver = false
    var gameBoard : Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userNameText.text = recievedUserName
        print(userNameText.text)
        print(recievedDifficulty)
        
        initialize()
        playMineSweeper()
    }
    
    func initialize() -> Void {
        initGameBoard()
    }
    
    func initGameBoard() -> Void {
        switch (recievedDifficulty) {
        case DifficultyType.EASY:
            gameBoard = Board.init(rows: 5, cols: 5, minesAmount: 5)
        case DifficultyType.MEDIUM:
            gameBoard = Board.init(rows: 10, cols: 10, minesAmount: 20)
        case DifficultyType.HARD:
            gameBoard = Board.init(rows: 10, cols: 10, minesAmount: 30)
        }
        // gameBoard.initBoard()
    }
    
    func drawBoard() -> Void {
        
    }
    
    func playMineSweeper() -> Void {
        	
    }
    
    func cheatMineSweeper() -> Void {
        
    }
    
    func onCellShortClick() -> Void {
        // need row/col values
        //gameBoard.cellClicked(row,col)
    }
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
