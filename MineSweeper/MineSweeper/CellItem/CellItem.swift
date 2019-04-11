//
//  CellItem.swift
//  MineSweeper
//
//  Created by Mark Lurie on 11/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit

class CellItem: UICollectionViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(imageName : String) {
        cellImage.image = UIImage(named: imageName)
    }
    
}
