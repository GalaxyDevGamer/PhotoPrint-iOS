//
//  LibraryCell.swift
//  PrinterApp
//
//  Created by GINGA WATANABE on 2018/12/26.
//  Copyright © 2018 GalaxySoftware. All rights reserved.
//

import UIKit

class LibraryCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setImage(image: UIImage) {
        imageView.image = image
    }
}
