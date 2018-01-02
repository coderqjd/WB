//
//  PhotoBrowserCell.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/9/4.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SDWebImage

protocol PhotoBrowserCellDelegate: NSObjectProtocol {
    func photoBrowserCelldidClose(_ photoBrowserCell: PhotoBrowserCell)
}

class PhotoBrowserCell: UICollectionViewCell {
    
    // MARK:- 懒加载属性
    fileprivate lazy var scrollView : UIScrollView = UIScrollView()
    lazy var imageView : UIImageView = UIImageView()
    fileprivate lazy var progressView : ProgressView = ProgressView()
    
    // MARK:- 属性
    var picUrl : URL? {
        didSet {
            setupContent(picUrl: picUrl)
        }
    }
    
    var delegate: PhotoBrowserCellDelegate?
    
    // MARK:- 重写构造方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- UI界面
extension PhotoBrowserCell {
    
    fileprivate func setupUI() {
        // 设置scrollView
        scrollView.frame = contentView.bounds
        contentView.addSubview(scrollView)
        scrollView.bounds.size.width -= 20
        
        // 设置imageView
        scrollView.addSubview(imageView)
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(imageViewClick))
        imageView.addGestureRecognizer(tapGes)
        imageView.isUserInteractionEnabled = true
//        imageView.contentMode = .scaleAspectFit
        
        // 设置progresView
        progressView.bounds.size = CGSize.init(width: 50, height: 50)
        progressView.center = CGPoint.init(x: screenW * 0.5, y: screenH * 0.5)
        progressView.backgroundColor = UIColor.clear
        contentView.addSubview(progressView)
    }
}

// MARK:- 事件监听
extension PhotoBrowserCell {

    @objc func imageViewClick() {
        delegate?.photoBrowserCelldidClose(self)
    }
}

// 处理 imageView 图片
extension PhotoBrowserCell {

    fileprivate func setupContent(picUrl: URL?) {
        guard let picUrl = picUrl else {
            return
        }
        
        // 取得图片
        let image = (SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: picUrl.absoluteString))!
        
        // 设置 imageView 的frame
        let w = UIScreen.main.bounds.width
        let h = w / image.size.width * image.size.height
        let x : CGFloat = 0
        let y = h > UIScreen.main.bounds.height ? 0 : (UIScreen.main.bounds.height - h) * 0.5
        imageView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        
        // 设置图片
        progressView.isHidden = false
        imageView.sd_setImage(with: getBigImage(smallUrl: picUrl), placeholderImage: image, options: [], progress: { (current, total, _) in
            self.progressView.progress = CGFloat(current) / CGFloat(total)
        }) { (_, _, _, _) in
            self.progressView.isHidden = true
        }
        imageView.contentMode = .scaleAspectFill
        
        // 设置 scrollView 的内容尺寸
        scrollView.contentSize = CGSize.init(width: 0, height: h)
    }
    
    private func getBigImage(smallUrl: URL) -> URL {
        let smallUrlStr = smallUrl.absoluteString
        
        let largeUrlStr = smallUrlStr.replacingOccurrences(of: "thumbnail", with: "bmiddle")
        
        return URL.init(string: largeUrlStr)!
    }
}

