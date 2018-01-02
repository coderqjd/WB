//
//  picCollectionView.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/17.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SDWebImage

class PicCollectionView: UICollectionView {

    // MARK:- 属性
    var picURLs : [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    fileprivate lazy var photoBrowserAnimator = PhotoBrowserAnimator()
    
    // MARK:- 系统调用方法
    override func awakeFromNib() {
        delegate = self
        dataSource = self
    }

}

// MARK:- collectionView数据源方法和代理方法
extension PicCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicCollectionViewCell
        cell.picURL = picURLs[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 发送弹出照片浏览器的通知
        NotificationCenter.default.post(name: NSNotification.Name.init(showPhotoBrowserNote), object: self, userInfo: [showPhotoBrowserIndexPath : indexPath, showPhotoBrowserPictureURLs : picURLs])
    }
}

extension PicCollectionView: PresentedAnimatorDelegate {
    
    func presentedAnimator(_ animator: PhotoBrowserAnimator, imageViewStartRectWith indexPath: IndexPath) -> CGRect {
        let cell = self.cellForItem(at: indexPath)!
        let startFrame = convert(cell.frame, to: UIApplication.shared.keyWindow)
        return startFrame
    }
    
    func presentedAnimator(_ animator: PhotoBrowserAnimator, imageViewEndRectWith indexPath: IndexPath) -> CGRect {
        let pic = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURLs[indexPath.item].absoluteString)
        guard let image = pic else {
            return CGRect.zero
        }
        
        let w = screenW
        let h = w * image.size.height / image.size.width
        let x: CGFloat = 0
        let y = h < screenH ? (screenH - h) * 0.5 : 0
        return CGRect.init(x: x, y: y, width: w, height: h)
    }
    
    func presentedAnimator(_ animator: PhotoBrowserAnimator, imageViewWith indexPath: IndexPath) -> UIImageView {
        let imageView = UIImageView()
        let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picURLs[indexPath.item].absoluteString)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}

// MARK:- 自定义cell类
class PicCollectionViewCell : UICollectionViewCell {
    
    // MARK:- 控件属性
    @IBOutlet weak var imageView: UIImageView!
    
    // 图片URL
    var picURL : URL? {
    
        didSet {
            guard let picURL = picURL else {
                return
            }
            // 设置配图
            imageView.sd_setImage(with: picURL, placeholderImage: UIImage.init(named: "empty_picture"))
        }
    }
}



