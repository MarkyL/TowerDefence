//
//  GameScreenViewController.swift
//  MineSweeper
//
//  Created by Mark Lurie on 09/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit

class GameScreenViewController: UIViewController {



    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var minesLeftTV: UITextView!
    @IBOutlet weak var gameGridView: UICollectionView!
    @IBOutlet weak var scoreTV: UILabel!
    
    @IBOutlet weak var restartBtn: UIButton!
    
    var recievedUserName : String = "INITIAL TEXT"
    var recievedDifficulty : DifficultyType = DifficultyType.EASY
    
    let defaults = UserDefaults.standard
    
    var created = Date()
    let formatter = DateFormatter()
    var score = 0
    var isGameOver = false
    var gameBoard : Board?
    var isFirstMove = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(userNameText.text)
        print(recievedDifficulty)
        
        initUI()
        initialize()
        setGameBoard()
        
        formatter.dateFormat = "dd.MM.yyyy"
    }
    
    func initUI() -> Void {
        userNameText.text = recievedUserName
        self.gameGridView.delegate = self
        self.gameGridView.dataSource = self
    }
    
    func initialize() -> Void {
        isFirstMove = true
        isGameOver = false
        
        initGameBoard()
        if let board = gameBoard {
            minesLeftTV.text = String(board.minesAmount)
        }
        score = 0
        self.scoreTV.text = String(score)
    }
    
    func setScore() -> Void {
        DispatchQueue.global(qos: .background).async {
            self.created = Date()
            var currentTime : Double = 0
            while (!self.isGameOver && !self.isFirstMove) {
                let timePassed = Double(Date().timeIntervalSince(self.created).rounded())
                if (currentTime + 1 < timePassed) {
                    currentTime += 1 // = timePassed - timePassed % 1
                    
                    DispatchQueue.main.async {
                        self.scoreTV.text = String(timePassed)
                        }
                }
            }
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
        //gameBoard?.showBombs()
    }
    
    @IBAction func onRestartClicked(_ sender: Any) {
        print("restart clicked")
        initialize()
        setGameBoard()
        gameGridView.reloadData()
    }
    
}

extension GameScreenViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        
        // cell Gestures & Taps
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        cell.addGestureRecognizer(lpgr)
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(handleShortPress))
        cell.addGestureRecognizer(tgr)
        //
        
        guard let board = gameBoard else { return cell }
        
        // set cell data (image source)
        let logicCell = board.cellsGrid[indexPath.item / board.rows][indexPath.item % board.cols]
        
        if (logicCell.isOpened == true) {
            if (logicCell.hasMine == true) {
                cell.setData(imageName: "boom")
            } else {
                cell.setData(imageName: String(logicCell.neighborMineCount))
            }
        } else if (logicCell.hasFlag) {
            cell.setData(imageName: "flagged")
        } else if (logicCell.hasMine && isGameOver) {
            cell.setData(imageName: "bomb")
        } else {
            cell.setData(imageName: "facingDown")
        }
        
        // reload cell item
        gameGridView.reloadItems(at: [indexPath])
        return cell
}
    
    func gameOver(isWinner : Bool) {
        isGameOver = true
        var gameOverMsg : String
        if isWinner {
            gameOverMsg = "Congratz You Won The Game!"
        } else {
            gameOverMsg = "You Lost , try again!"
        }
        
        // create the alert
        let alert = UIAlertController(title: "Game Over", message: gameOverMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        if isWinner{
            saveEndGameData()
        }
        

    }
    
    func saveEndGameData(){
        // Rounded time as score
        let score = Int(Date().timeIntervalSince(created).rounded())
        
        // Current date
        let date = formatter.string(from: created)
        
        // User's name
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

    func handleShortPress(gesture : UITapGestureRecognizer) {
        if (isFirstMove) {
            isFirstMove = false
            setScore()
        }
        
        print("inside handleShortPress()")
        guard let board = gameBoard else { return }
        let p = gesture.location(in: self.gameGridView)
        
        if let indexPath = self.gameGridView.indexPathForItem(at: p) {
            print(indexPath.item) // the cell that was clicked!!!
            
            let logicCell = board.cellsGrid[indexPath.item/board.rows][indexPath.item%board.cols]
            
            if (logicCell.hasFlag) { return }
            
            if (board.reveal(cell: logicCell)) {
                print("Game is over - you hit mine")
                gameOver(isWinner: false)
            }else{
                let totalCells = board.rows*board.cols
                if totalCells-board.minesAmount == board.cellsRevealed {
                    print("Game is over - you win")
                    gameOver(isWinner: true)
                }
            }
            
            DispatchQueue.main.async {
                self.gameGridView.reloadData()
            }
            
        }

    }
    
    func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        guard let board = gameBoard else { return }
        
        print("inside handleLongPress()")
        let p = gesture.location(in: self.gameGridView)
        
        if let indexPath = self.gameGridView.indexPathForItem(at: p) {
            print(indexPath.item) // the cell that was clicked!!!
            
            let logicCell = board.cellsGrid[indexPath.item / board.rows][indexPath.item % gameBoard!.cols]
            board.setFlag(cell: logicCell)
            minesLeftTV.text = String(board.minesAmount - board.flagsAmount)
            
            DispatchQueue.main.async {
                self.gameGridView.reloadItems(at: [indexPath])
            }
        } else {
            print("couldn't find index path")
        }
        
        
        
    }
    
}
