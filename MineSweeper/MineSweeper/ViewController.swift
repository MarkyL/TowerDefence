//
//  ViewController.swift
//  MineSweeper
//
//  Created by Omri Ohayon on 06/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var difficultyPickerView: UIPickerView!
    @IBOutlet weak var playBtn: UIButton!
    
    let defaults = UserDefaults.standard
    
    var difficultyList = [ DifficultyType.EASY, DifficultyType.MEDIUM, DifficultyType.HARD ]

    var selectedDifficulty = DifficultyType.MEDIUM
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return difficultyList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        switch row {
            case 0:
            return "Easy"
            case 1:
            return "Medium"
            case 2:
            return "Hard"
        default:
            return "Easy"
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDifficulty = difficultyList[row];
    }
    
    @IBAction func onPlayclicked(_ sender: Any) {
        //print("selectedDifficulty = " + selectedDifficulty.hashValue)
        if let name = userNameTextField.text {
            defaults.set(name, forKey: "username")
            print("username = " + name)
        }
        
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // mark test first commit
        
        self.userNameTextField.delegate = self
        self.userNameTextField.text = defaults.string(forKey: "username")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is GameScreenViewController {
            let vc = segue.destination as? GameScreenViewController
            if let name = userNameTextField.text {
                vc?.recievedUserName = name
                vc?.recievedDifficulty = selectedDifficulty
            }
        }
        
    }
}

