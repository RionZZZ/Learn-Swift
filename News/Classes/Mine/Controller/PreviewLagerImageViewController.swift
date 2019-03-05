//
//  PreviewLagerImageViewController.swift
//  News
//
//  Created by Rion on 2019/3/4.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import Kingfisher
import SVProgressHUD
import Photos

class PreviewLagerImageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var indexLabel: UILabel!

    var images = [LargeImage]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        indexLabel.text = "\(selectedIndex + 1)/\(images.count)"
        collectionView._registerCell(cell: DongtaiCollectionCell.self)
        view.layoutIfNeeded()
        collectionView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    @IBAction func saveClick(_ sender: UIButton) {
        let image = images[selectedIndex]
        ImageDownloader.default.downloadImage(with: URL(string: image.url as String)!, options: nil, progressBlock: { (received, total) in
            let progress = Float(received) / Float(total)
            SVProgressHUD.showProgress(progress)
            SVProgressHUD.setBackgroundColor(.clear)
            SVProgressHUD.setForegroundColor(.white)
        }) { result in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: (result.value?.image)!)
            }, completionHandler: { (success, error) in
                SVProgressHUD.dismiss()
                if success {
                    SVProgressHUD.showSuccess(withStatus: "保存成功!")
                }
            })
        }
    }

}

extension PreviewLagerImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView._dequeueReusableCell(indexPath: indexPath) as DongtaiCollectionCell
        cell.largeImage = images[indexPath.item]
        cell.thumbImageView.contentMode = .scaleAspectFit
        cell.thumbImageView.layer.borderWidth = 0
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.width, height: collectionView.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: false, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        selectedIndex = Int(scrollView.contentOffset.x / collectionView.width + 0.5) //向上取整
        indexLabel.text = "\(selectedIndex + 1)/\(images.count)"
    }
    
}
