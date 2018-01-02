//
//  EmoticonCell.swift
//  0828-表情键盘
//
//  Created by 强进冬 on 2017/8/29.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class EmoticonCell: UICollectionViewCell {
  
    // MARK:- 懒加载属性
    fileprivate lazy var emoticonBtn : UIButton = UIButton()
    
    // MARK:- 模型属性
    var emoticon : Emoticon? {
        didSet {
            guard let emoticon = emoticon else {
                return
            }
            
            emoticonBtn.setImage(UIImage.init(contentsOfFile: emoticon.pngPath ?? ""), for: .normal)
            emoticonBtn.setTitle(emoticon.emojiCode, for: .normal)
            
            // 设置删除按钮
            if emoticon.isRemove {
                emoticonBtn.setImage(UIImage.init(named: "compose_emotion_delete"), for: .normal)
            }
            
            if emoticon.isEmpty {
                emoticonBtn.setImage(nil, for: .normal)
                emoticonBtn.setTitle(nil, for: .normal)
            }
        }
    }
    
    // MARK:- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmoticonCell {

    fileprivate func setupUI() {
    
        emoticonBtn.frame = bounds
        emoticonBtn.isUserInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        contentView.addSubview(emoticonBtn)
    }
}
