//
//  PicPickerCell.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/24.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class PicPickerCell: UICollectionViewCell {
    // MARK:- 控件属性
    @IBOutlet weak var addPicBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var removePicBtn: UIButton!
    
    // MARK:- 属性
    var image : UIImage? {
        didSet {
            if let image = image {
                imageView.image = image
                addPicBtn.isUserInteractionEnabled = false
                removePicBtn.isHidden = false
            } else {
                imageView.image = UIImage.init(named: "compose_pic_add") // 防止循环引用
                addPicBtn.isUserInteractionEnabled = true
                removePicBtn.isHidden = true
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
    }
    
    // MARK:- 事件监听
    @IBAction func addPicture() {
        NotificationCenter.default.post(name: Notification.Name(picPickerAddPhotoNote), object: nil)
    }

    @IBAction func removePicture() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: picPickerRemovePhotoNote), object: imageView.image)
    }
}
