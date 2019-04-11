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
    @IBOutlet weak var minesLeftTV: UITextView!
    @IBOutlet weak var gameGridView: UICollectionView!
    
    var recievedUserName : String = "INITIAL TEXT"
    var recievedDifficulty : DifficultyType = DifficultyType.EASY
    
    var score = 0
    var isGameOver = false
    var gameBoard : Board?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(userNameText.text)
        print(recievedDifficulty)
        
        initUI()
        initialize()
        setGameBoard()
        playMineSweeper()
    }
    
    func initUI() -> Void {
        userNameText.text = recievedUserName
        self.gameGridView.delegate = self
        self.gameGridView.dataSource = self
    }
    
    func initialize() -> Void {
        initGameBoard()
        if let board = gameBoard {
            minesLeftTV.text = String(board.minesAmount)
        }
    }
    
    func setGameBoard() -> Void {
        self.gameGridView.register(UINib(nibName: "CellItem", bundle: nil), forCellWithReuseIdentifier: "CellItem")
        
        
        let layout = self.gameGridView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(
            width: (self.gameGridView.frame.size.width)/5,
            height: (self.gameGridView.frame.size.height)/5)
 
    }
    
    func initGameBoard() -> Void {
        switch (recievedDifficulty) {
        case DifficultyType.EASY:
            gameBoard = Board(rows: 5, cols: 5, minesAmount: 5)
        case DifficultyType.MEDIUM:
            gameBoard = Board(rows: 10, cols: 10, minesAmount: 20)
        case DifficultyType.HARD:
            gameBoard = Board(rows: 10, cols: 10, minesAmount: 30)
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
    

    
}

extension GameScreenViewController : UICollectionViewDelegate {
    
}

extension GameScreenViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let board = gameBoard {
            return board.rows * board.cols
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gameGridView.dequeueReusableCell(withReuseIdentifier: "CellItem", for: indexPath) as! CellItem
        cell.setData(imageName: "facingDown")
        
        return cell
    }
    
    
}
