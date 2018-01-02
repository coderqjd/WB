//
//  PicPickerCollectionView.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/24.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

fileprivate let picPickerCellID = "picPickerCellID"
fileprivate let margin : CGFloat = 10

class PicPickerCollectionView: UICollectionView {
    
    // MARK:- 属性
    var images : [UIImage] = [UIImage]() {
        didSet {
            reloadData()
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemWH = (screenW - margin * 4) / 3
        layout.itemSize = CGSize.init(width: itemWH, height: itemWH)
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        contentInset = UIEdgeInsets.init(top: margin, left: margin, bottom: 0, right: margin)
        
        dataSource = self
        register(UINib.init(nibName: String.init(describing: PicPickerCell.self), bundle: nil), forCellWithReuseIdentifier: picPickerCellID)
    }
}

// MARK:- 数据源方法
extension PicPickerCollectionView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: picPickerCellID, for: indexPath) as! PicPickerCell
        
        cell.backgroundColor = UIColor.green
        
        cell.image = indexPath.item <= images.count - 1 ? images[indexPath.item] : nil
        
        return cell
    }
}
