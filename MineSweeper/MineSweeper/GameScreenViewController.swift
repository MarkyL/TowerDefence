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
    
    let defaults = UserDefaults.standard
    
    let created = Date()
    let formatter = DateFormatter()
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
        
        formatter.dateFormat = "dd.MM.yyyy"
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
        self.gameGridView.register(UINib(nibName: "CollectionCellItem", bundle: nil), forCellWithReuseIdentifier: "CollectionCellItem")
        
        let layout = self.gameGridView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        
        if let board = gameBoard {
            let boardSize = board.rows
            print("boardSize = " + String(boardSize))
            if (boardSize == 5) {
            layout.itemSize = CGSize(
                width: (self.gameGridView.frame.size.width)/5,
                height: (self.gameGridView.frame.size.height)/5)
            } else if (boardSize == 10) {
                layout.itemSize = CGSize(
                    width: (self.gameGridView.frame.size.width)/10,
                    height: (self.gameGridView.frame.size.height)/10)
            }
        }
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
        gameBoard?.initBoard()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item) // the cell that was clicked!!!
        let cell = gameGridView.cellForItem(at: indexPath) as! CollectionCellItem
        cell.setData(imageName: "bomb")
        //let logicCell = gameBoard?.cellsGrid[indexPath.item/10][indexPath.item%10]
    }
    
    
}

extension GameScreenViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let board = gameBoard {
            return board.rows * board.cols
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = gameGridView.dequeueReusableCell(withReuseIdentifier: "CollectionCellItem", for: indexPath) as! CollectionCellItem
        
        cell.setData(imageName: "facingDown")
        
        
        return cell
    }
    
    @IBAction func endGameSimulation(_ sender: UIButton) {
        
        
        let score = Double(Date().timeIntervalSince(created).rounded())
        
        let date = formatter.string(from: created)
        
        
        let name = defaults.string(forKey: "username")
        
        var str = name!+"_"
        str+=String(score)+"_"
        str+=String(date)
        
        guard let arr = defaults.array(forKey: "scoreData") as? [String] else {
            
            defaults.set([str], forKey: "scoreData")
            return
        }
        
        var scoreData = arr
    
        scoreData.append(str)

        defaults.set(scoreData, forKey: "scoreData")
        
    }
    
    
}
