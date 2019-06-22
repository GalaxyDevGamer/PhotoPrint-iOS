//
//  ViewController.swift
//  PrinterApp
//
//  Created by GINGA WATANABE on 2018/12/26.
//  Copyright © 2018 GalaxySoftware. All rights reserved.
//

import UIKit
import Photos
import PhotoLibrary

class LibraryView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var needGrantView: UIView!
    
    var allPhotos: PHFetchResult<PHAsset>!
    
    let library = PhotoLibrary()
    
    let controller = UIPrintInteractionController.shared
    
    let printInfo = UIPrintInfo(dictionary: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.register(UINib(nibName: "LibraryCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        printInfo.outputType = UIPrintInfo.OutputType.photo
        printInfo.jobName = "Photo Print from iPhone"
        printInfo.orientation = UIPrintInfo.Orientation.portrait
        controller.printInfo = printInfo
        if library.isAuthorized() {
            allPhotos = library.getAllPhotos()
        } else {
            requestPermission()
        }
    }
    
    @IBAction func grantClick(_ sender: Any) {
        requestPermission()
    }
    
    func requestPermission() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.needGrantView.isHidden = true
                self.allPhotos = self.library.getAllPhotos()
                break
            default:
                self.needGrantView.isHidden = false
                break
            }
        }
    }
}

extension LibraryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos == nil ? 0 : allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LibraryCell
        cell.setImage(image: allPhotos[indexPath.row].getImagesForCollection())
        return cell
    }
}

extension LibraryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.printingItem = allPhotos[indexPath.row].getOriginalImage().resizeForA4()
        controller.present(animated: true) { (controller, success, error) in
            if error != nil {
                let dialog = UIAlertController(title: "Error", message: "Sending the data failed", preferredStyle: UIAlertController.Style.alert)
                dialog.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
            }
        }
    }
}

extension LibraryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width/3-7, height: self.view.frame.size.width/3-7)
    }
}
