//
//  CollectionCellItem.swift
//  MineSweeper
//
//  Created by Omri Ohayon on 12/04/2019.
//  Copyright © 2019 Omri Ohayon. All rights reserved.
//

import UIKit

class CollectionCellItem: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(imageName : String) {
        cellImage.image = UIImage(named: imageName)
    }

}
