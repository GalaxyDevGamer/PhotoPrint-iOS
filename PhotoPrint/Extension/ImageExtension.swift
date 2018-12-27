//
//  ImageExtension.swift
//  PrinterApp
//
//  Created by GINGA WATANABE on 2018/12/27.
//  Copyright © 2018 GalaxySoftware. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func resizeForA4() -> UIImage {
        let size = CGSize(width: 2480, height: 3508)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
