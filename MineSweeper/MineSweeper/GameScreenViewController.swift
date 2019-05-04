//
//  GameScreenViewController.swift
//  MineSweeper
//
//  Created by Mark Lurie on 09/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit
import CoreLocation

class GameScreenViewController: UIViewController {

    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var minesLeftText: UILabel!
    @IBOutlet weak var scoreText: UILabel!
    
    @IBOutlet weak var gameGridView: UICollectionView!
    @IBOutlet weak var restartBtn: UIButton!
    
    var recievedUserName : String = ""
    var recievedDifficulty : DifficultyType = DifficultyType.EASY
    
    var created = Date()
    var score = 0
    var isGameOver = false, isFirstMove = true
    var gameBoard : Board?
    
    let locationManager = CLLocationManager()
    var userLocation : CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(recievedDifficulty)
        
        userNameText.text = recievedUserName
        self.gameGridView.dataSource = self
        
        initialize()
    }
    
    // Initialazation of viewController attributes and game board logic.
    func initialize() -> Void {
        restartBtn.setImage(UIImage(named: "sun-smile"), for: [])
        isFirstMove = true
        isGameOver = false
        score = 0
        self.scoreText.text = String(score)
        
        initGameBoard()
        if let board = gameBoard {
            minesLeftText.text = String(board.minesAmount)
        }
        setGameBoard()
    }
    
    // Initialazation of game board size and mines.
    func initGameBoard() -> Void {
        switch recievedDifficulty {
            case DifficultyType.EASY:
                gameBoard = Board(rows: 5, cols: 5, minesAmount: 5)
            case DifficultyType.MEDIUM:
                gameBoard = Board(rows: 10, cols: 10, minesAmount: 20)
            case DifficultyType.HARD:
                gameBoard = Board(rows: 10, cols: 10, minesAmount: 30)
        }
        gameBoard?.initBoard()
        // use show bombs for QA testing
        gameBoard?.showBombs()
    }
    
    // UI of Collection and Cell view adjustments to the game difficulty.
    func setGameBoard() -> Void {
        self.gameGridView.register(UINib(nibName: "CollectionCellItem", bundle: nil), forCellWithReuseIdentifier: "CollectionCellItem")
        
        let layout = self.gameGridView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0
        
        if let board = gameBoard {
            let boardSize = board.rows
            print("boardSize = " + String(boardSize))
            if boardSize == 5 {
                layout.itemSize = CGSize(
                    width: self.gameGridView.frame.size.width / 5,
                    height: self.gameGridView.frame.size.height / 5)
            } else if boardSize == 10 {
                layout.itemSize = CGSize(
                    width: self.gameGridView.frame.size.width / 10,
                    height: self.gameGridView.frame.size.height / 10)
            }
        }
    }
    
    // Updating the score data in an Async task while drawing it on Main thread.
    func startScoreTracking() -> Void {
        DispatchQueue.global(qos: .background).async {
            self.created = Date()
            var currentTime : Double = 0
            
            while !self.isGameOver && !self.isFirstMove {
                let timePassed = Double(Date().timeIntervalSince(self.created).rounded())
                
                if currentTime + 1 < timePassed {
                    currentTime += 1
                    
                    DispatchQueue.main.async {
                        self.scoreText.text = String(timePassed)
                    }
                }
            }
        }
    }
    
    @IBAction func onRestartClicked(_ sender: Any) {
        initialize()
        setGameBoard()
        gameGridView.reloadData()
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
        setCellClickListeners(cell: cell)
        
        // set cell data (image source)
        guard let board = gameBoard else { print("gameBoard is nil"); return cell }
        let logicCell = board.cellsGrid[indexPath.item / board.rows][indexPath.item % board.cols]
        setCellData(uiCell : cell, logicCell : logicCell)
        
        // reload cell item
        gameGridView.reloadItems(at: [indexPath])
        return cell
}
    
    func setCellClickListeners(cell : CollectionCellItem) -> Void {
        // long press gesture
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        cell.addGestureRecognizer(lpgr)
        
        // short press gesture
        let tgr = UITapGestureRecognizer(target: self, action: #selector(handleShortPress))
        cell.addGestureRecognizer(tgr)
    }
    
    /// Sets the correct data (image source) to the UI cell according to the data of the
    /// Logic cell that is retrieved.
    /// - Parameters:
    ///   - uiCell: the UI cell of the gameBoard that is handled
    ///   - logicCell: the Logic cell of the gameGridView that is handled
    func setCellData(uiCell : CollectionCellItem, logicCell : Cell) -> Void {
        if logicCell.isOpened == true {
            if logicCell.hasMine == true {
                uiCell.setData(imageName: "boom")
            } else {
                uiCell.setData(imageName: String(logicCell.neighborMineCount))
            }
        } else if logicCell.hasFlag {
            uiCell.setData(imageName: "flagged")
        } else if logicCell.hasMine && isGameOver {
            uiCell.setData(imageName: "bomb")
        } else {
            uiCell.setData(imageName: "facingDown")
        }
    }
    
    // handle end game logic and show alert.
    func gameOver(isWinner : Bool) {
        isGameOver = true
        var gameOverMsg : String , gameOverTitle : String
        if isWinner {
            gameOverTitle = "Good game"
            gameOverMsg = "Congratz you won the game!"
            restartBtn.setImage(UIImage(named: "sun-smile"), for: [])
            saveEndGameData()
        } else {
            gameOverTitle = "Game over"
            gameOverMsg = "You lost, try again!"
            restartBtn.setImage(UIImage(named: "sun-sad"), for: [])
        }
        
        // create the alert
        let alert = UIAlertController(title: gameOverTitle, message: gameOverMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveEndGameData(){
        let defaults = UserDefaults.standard
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        // Rounded time as score
        let score = Int(Date().timeIntervalSince(created).rounded())
        
        // Current date
        let date = formatter.string(from: created)
        
        // User's name
        let name = defaults.string(forKey: "username")
        
        // User's location
        updateUserLocation()
        
        var str = name!+"_"
        str+=String(score)+"_"
        str+=String(date)+"_"
        str+=String(self.userLocation.longitude)+"_"
        str+=String(self.userLocation.latitude)
        
        guard let arr = defaults.array(forKey: "scoreData") as? [String] else {
            defaults.set([str], forKey: "scoreData")
            return
        }
        
        var scoreData = arr
        scoreData.append(str)
        defaults.set(scoreData, forKey: "scoreData")
    }
    
    func updateUserLocation() {
        // For use in foreground
//        self.locationManager.requestWhenInUseAuthorization()
        checkLocationAuthorization()
//
//        if CLLocationManager.locationServicesEnabled() {
//            self.locationManager.delegate = self
//            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            self.locationManager.startUpdatingLocation()
//        }
        
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            break
        case .denied:
            // Show alert instructing them how to turn on permissions
            handleDeniedLocationAuthorizationState()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        }
    }
    
    func handleDeniedLocationAuthorizationState() {
        let alertController = UIAlertController(title: NSLocalizedString("Enter your title here", comment: ""), message: NSLocalizedString("Enter your message here.", comment: ""), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (cancelAction) in
            _ = self.navigationController?.popViewController(animated: true)
        }
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // Logic of game board cell short click.
    func handleShortPress(gesture : UITapGestureRecognizer) {
        if isGameOver { return }
        if isFirstMove {
            isFirstMove = false
            startScoreTracking()
        }
        
        guard let board = gameBoard else { print("board is nil"); return }
        let p = gesture.location(in: self.gameGridView)
        
        if let indexPath = self.gameGridView.indexPathForItem(at: p) {
            //print(indexPath.item) // the cell that was clicked.
            
            let logicCell = board.cellsGrid[indexPath.item / board.rows][indexPath.item % board.cols]
            
            if (logicCell.hasFlag) { return }
            
            if (board.reveal(cell: logicCell)) {
                // Game is over - you hit a mine!
                gameOver(isWinner: false)
            } else {
                let totalCells = board.rows * board.cols
                if totalCells - board.minesAmount == board.cellsRevealed {
                    // Game is over - you win!
                    gameOver(isWinner: true)
                }
            }
            
            // update the data of the board after a move was made.
            DispatchQueue.main.async {
                self.gameGridView.reloadData()
            }
        }
    }
    
    // Logic of game board cell long click.
    func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended || isGameOver {
            return
        }
        
        guard let board = gameBoard else { return }
        
        let p = gesture.location(in: self.gameGridView)
        
        if let indexPath = self.gameGridView.indexPathForItem(at: p) {
            print(indexPath.item) // the cell that was clicked!
            
            let logicCell = board.cellsGrid[indexPath.item / board.rows][indexPath.item % gameBoard!.cols]
            board.setFlag(cell: logicCell)
            minesLeftText.text = String(board.minesAmount - board.flagsAmount)
            
            // redraw cell's view.
            DispatchQueue.main.async {
                self.gameGridView.reloadItems(at: [indexPath])
            }
        } else {
            print("couldn't find index path")
        }
    }
}

extension GameScreenViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.userLocation = locValue
        print("locations = \(userLocation.latitude) \(userLocation.longitude)")
    }
}
