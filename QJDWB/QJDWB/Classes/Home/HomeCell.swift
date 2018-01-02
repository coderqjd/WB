//
//  HomeCell.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/16.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SDWebImage


/// 边缘间距
fileprivate let edgeMargin : CGFloat = 10
/// 图片间距
fileprivate let itemMargin : CGFloat = 5

class HomeCell: UITableViewCell {

    // MARK:- 控件属性
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var createdTime: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentTextLabel: QJDLabel!
    @IBOutlet weak var picCollectionView: PicCollectionView!
    @IBOutlet weak var reweetedTextLabel: QJDLabel!
    @IBOutlet weak var reweetedBackgroud: UIView!

    
    // MARK:- 约束属性
    @IBOutlet weak var contentTextWCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWidthCons: NSLayoutConstraint!
    @IBOutlet weak var picViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var reweetedContentTopCons: NSLayoutConstraint!
    @IBOutlet weak var picViewBottomCons: NSLayoutConstraint!
    
    // MARK:- 模型属性
    var statusVM : StatusViewModel? {
        didSet {
            guard let statusVM = statusVM else {
                return
            }
            // 设置头像
            profileView.sd_setImage(with: statusVM.profileURL, placeholderImage: UIImage.init(named: "avatar_default_small"))
            // 设置认证图标
            verifiedView.image = statusVM.verifiedImage
            // 设置昵称
            screenName.text = statusVM.status?.user?.screen_name
            // 设置会员图标
            vipView.image = statusVM.vipImage
            // 设置创建时间
            createdTime.text = statusVM.creatAtText
            // 设置来源
            sourceLabel.text = statusVM.sourceText
            // 设置文字内容
            contentTextLabel.attributedText = EmoticonFromAttributedString.shareInstance.showAttributedString(text: statusVM.status?.text, font: contentTextLabel.font)
            // 设置昵称颜色
            screenName.textColor = statusVM.vipImage == nil ? UIColor.black : UIColor.orange
            
            // 计算配图View的尺寸
            let picViewSize = calculatePicViewSize(count: statusVM.picURLs.count)
            picViewWidthCons.constant = picViewSize.width
            picViewHeightCons.constant = picViewSize.height
            // 将数据传给配图视图
            picCollectionView.picURLs = statusVM.picURLs
            
            // 设置转发微博文字内容
            if statusVM.status?.retweeted_status?.text != nil { // 有转发
                
                if let screenName = statusVM.status?.retweeted_status?.user?.screen_name {
                    let retweetText = "@" + "\(screenName):" + (statusVM.status?.retweeted_status?.text)!
                    reweetedTextLabel.attributedText = EmoticonFromAttributedString.shareInstance.showAttributedString(text: retweetText, font: reweetedTextLabel.font)
                }
                
                // 转发微博背景显示
                reweetedBackgroud.isHidden = false
                
                reweetedContentTopCons.constant = 15
                
            } else {
                reweetedContentTopCons.constant = 0

                reweetedTextLabel.text = nil
                // 转发微博背景隐藏
                reweetedBackgroud.isHidden = true
            }
            
        }
    }
    

    // MARK:- 系统回调方法
    override func awakeFromNib() {
        super.awakeFromNib()
    
        // 设置文字label的宽度约束
        contentTextWCons.constant = UIScreen.main.bounds.width - 2 * edgeMargin
        
        // 设置 label 的颜色
        contentTextLabel.matchTextColor = UIColor.orange
        reweetedTextLabel.matchTextColor = UIColor.orange
        
        
        // 监听@谁谁谁的点击
        contentTextLabel.userTapHandler = { (label, user, range) in
            QJDLog(user)
            QJDLog(range.toRange()!)
        }
        
        // 监听链接的点击
        contentTextLabel.linkTapHandler = { (label, link, range) in
            QJDLog(link)
            QJDLog(range.toRange()!)
        }
        
        // 监听话题的点击
        contentTextLabel.topicTapHandler = { (label, topic, range) in
            QJDLog(topic)
            QJDLog(range.toRange()!)
        }
    }

}

// MARK:- 计算配图视图的尺寸
extension HomeCell {

    fileprivate func calculatePicViewSize(count: Int) -> CGSize {
    
        // 总列数
        let columns = 3
        let cols = CGFloat(columns)
        // 总行数
        let r = (count - 1) / columns + 1
        let rows = CGFloat(r)
        // 每个imageItem的尺寸
        let itemWH = (UIScreen.main.bounds.width - 2 * edgeMargin - (cols - 1) * itemMargin) / cols
        
        // 设置picView的layout
        let layout = picCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = itemMargin
        layout.minimumInteritemSpacing = itemMargin
        
        // 1.没有配图
        if count == 0 {
            picViewBottomCons.constant = 0
            return CGSize.zero
        }
        
        picViewBottomCons.constant = 10
        
        // 2.只有一张配图
        if count == 1 {
            // 取得最新的图片string
            let urlString = statusVM?.picURLs.last?.absoluteString
            
            // 获取缓存的图片
            let image = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: urlString)
            
            guard let tempImage = image else {
                return CGSize.zero
            }
            // 设置一张配图时的layout
            layout.itemSize = CGSize.init(width: tempImage.size.width * 2, height: tempImage.size.height * 2)
            
            return layout.itemSize
        }
        
        // 设置其他情况的layout
        layout.itemSize = CGSize.init(width: itemWH, height: itemWH)
        
        // 3.四张配图
        if count == 4 {
            let picviewWH = itemWH * (cols - 1) + itemMargin
            return CGSize.init(width: picviewWH, height: picviewWH)
        }
        
        // 4.其他
        let picViewW = UIScreen.main.bounds.width - 2 * edgeMargin
        let picViewH = rows * itemWH + (rows - 1) * itemMargin
        
        return CGSize.init(width: picViewW, height: picViewH)
    }
}
