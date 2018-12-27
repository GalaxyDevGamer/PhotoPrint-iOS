//
//  ViewController.swift
//  PrinterApp
//
//  Created by GINGA WATANABE on 2018/12/26.
//  Copyright © 2018 GalaxySoftware. All rights reserved.
//

import UIKit
import Photos

class LibraryView: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var allPhotos: PHFetchResult<PHAsset>!
    
    let options = PHImageRequestOptions()
    
    let controller = UIPrintInteractionController.shared
    
    let printInfo = UIPrintInfo(dictionary: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.register(UINib(nibName: "LibraryCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        options.isSynchronous = true
        options.isNetworkAccessAllowed = true
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "Photo Print from iPhone"
        printInfo.orientation = UIPrintInfo.Orientation.portrait
        controller.printInfo = printInfo
        getAllPhotos()
    }

    func getAllPhotos() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case PHAuthorizationStatus.authorized:
                let options = PHFetchOptions()
                options.sortDescriptors = [
                    NSSortDescriptor(key: "creationDate", ascending: false)
                ]
                self.allPhotos = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: options)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .notDetermined:
                print("Not determined")
            case .restricted, .denied:
                print("Not allowed")
            }
        }
    }
    
    func getImagesForCollection(asset: PHAsset) -> UIImage {
        var thumbnail = UIImage(named: "Image48pt")
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: PHImageContentMode.aspectFill, options: options) { (image, info) in
            if let safeImage = image {
                thumbnail = safeImage
            }
        }
        return thumbnail!
    }
    
    func getOriginalImage(asset: PHAsset) -> UIImage {
        var original = UIImage(named: "Image48pt")
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.default, options: options) { (image, info) in
            if let thumbnail = image {
                original = thumbnail
            }
        }
        return original!
    }
}

extension LibraryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allPhotos == nil ? 0 : allPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LibraryCell
        cell.setImage(image: getImagesForCollection(asset: allPhotos[indexPath.row]))
        return cell
    }
}

extension LibraryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        controller.printingItem = getOriginalImage(asset: allPhotos[indexPath.row])
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
