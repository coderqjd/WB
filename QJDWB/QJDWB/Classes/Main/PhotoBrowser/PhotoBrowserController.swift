//
//  PhotoBrowserController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/9/1.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

fileprivate let photoBrowserID = "photoBrowser"

class PhotoBrowserController: UIViewController {
    
    // MARK:- 懒加载属性
    lazy var collectionView : UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: PhotoBrowserLayout())
    lazy var closeBtn : UIButton = UIButton.init(title: "关 闭", backgrdColor: UIColor.darkGray, fontSize: 16)
    lazy var saveBtn : UIButton = UIButton.init(title: "保 存", backgrdColor: UIColor.darkGray, fontSize: 16)
    
    // MARK:- 属性
    var indexPath : IndexPath
    var picUrls : [URL]
    
    // MARK:- 自定义构造函数
    init(indexPath: IndexPath, picUrls: [URL]){
        
        self.indexPath = indexPath
        self.picUrls = picUrls
        
        super.init(nibName: nil, bundle: nil)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // 滚动到点击的图片位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

// MARK:- UI设置
extension PhotoBrowserController {
    
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(closeBtn)
        view.addSubview(saveBtn)
        
        // 设置 frame
        collectionView.frame = view.bounds
        collectionView.bounds.size.width += 20
        closeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.bottom.equalTo(-20)
            maker.size.equalTo(CGSize.init(width: 90, height: 32))
        }
        saveBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-20)
            maker.bottom.equalTo(closeBtn.snp.bottom)
            maker.size.equalTo(closeBtn.snp.size)
        }
        
        // 设置 collectionView 的属性
        collectionView.dataSource = self
        collectionView.register(PhotoBrowserCell.self, forCellWithReuseIdentifier: photoBrowserID)
        
        // 给按钮添加点击事件
        closeBtn.addTarget(self, action: #selector(close), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(save), for: .touchUpInside)
    }
    
}

// MARK:- 事件监听(保存图片)
extension PhotoBrowserController {

    @objc fileprivate func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func save() {
        // 获取当前显示的图片
        let cell = collectionView.visibleCells.first as! PhotoBrowserCell
        guard let image = cell.imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFnishSavingWithError:contextInfo:)), nil)
    }
    
    @objc fileprivate func image(image: UIImage, didFnishSavingWithError error: NSError?, contextInfo: AnyObject) {
        var info = ""
        if error != nil {
            info = "保存失败"
        } else {
            info = "保存成功"
        }
        SVProgressHUD.showInfo(withStatus: info)
    }
}

// MARK:- collectionView 数据源方法
extension PhotoBrowserController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoBrowserID, for: indexPath) as! PhotoBrowserCell
        cell.delegate = self
        cell.picUrl = picUrls[indexPath.item]
        
        return cell
    }
}

// MARK:- PhotoBrowserCellDelegate
extension PhotoBrowserController: PhotoBrowserCellDelegate {
    
    func photoBrowserCelldidClose(_ photoBrowserCell: PhotoBrowserCell) {
        close()
    }
}

// MARK:- AnimatorDismissedDelegate
extension PhotoBrowserController: DismissedAnimatorDelegate {

    func indexPathForDismiss(in animator: PhotoBrowserAnimator) -> IndexPath {
        // 1.获取当前显示的cell
        let cell = collectionView.visibleCells.first as! PhotoBrowserCell
        
        return collectionView.indexPath(for: cell)!
    }
    
    func imageViewForDismiss(in animator: PhotoBrowserAnimator) -> UIImageView {
        let imageView = UIImageView()
        
        let cell = collectionView.visibleCells.first as! PhotoBrowserCell
        imageView.image = cell.imageView.image
        imageView.frame = cell.imageView.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
}

// MARK:- 自定义布局类
fileprivate class PhotoBrowserLayout : UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        itemSize = collectionView!.bounds.size
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        collectionView?.isPagingEnabled = true
        
        scrollDirection = .horizontal
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}



