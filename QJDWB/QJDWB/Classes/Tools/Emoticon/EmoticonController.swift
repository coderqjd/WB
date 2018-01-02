//
//  EmoticonController.swift
//  0828-表情键盘
//
//  Created by 强进冬 on 2017/8/28.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

fileprivate let emoticonID = "emoticon"

class EmoticonController: UIViewController {
    
    // MARK:- 属性
    var emoticonCallBack: (_ emoticon: Emoticon) -> ()
    
    // MARK:- 懒加载属性
    fileprivate lazy var collectionView : UICollectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: EmoticonCollectioViewLayout())
    
    fileprivate lazy var toolBar : UIToolbar = UIToolbar()
    
    fileprivate lazy var manager : EmoticonManager = EmoticonManager()
    
    // MARK:- 自定义构造函数
    init(emoticonCallBack: @escaping (_ emoticon: Emoticon) -> ()) {
        self.emoticonCallBack = emoticonCallBack
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}

// MARK:- UI设置
extension EmoticonController {
    
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        
        collectionView.backgroundColor = UIColor.brown
        toolBar.backgroundColor = UIColor.white
        
        // 设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let views : [String : Any] = ["collectionView" : collectionView, "toolBar" : toolBar]
        var cons = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[toolBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[collectionView]-0-[toolBar]-0-|", options: [.alignAllLeft, .alignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        prepareForCollectionView()
        
        prepareToolBar()
    }
    
    fileprivate func prepareForCollectionView() {
        // 注册cell
        collectionView.register(EmoticonCell.self, forCellWithReuseIdentifier: emoticonID)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    fileprivate func prepareToolBar() {
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        var index = 0
        var items = [UIBarButtonItem]()
        for title in titles {
            let btnItem = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(btnItemClick(btnItem:)))
            btnItem.tag = index
            index += 1
            items.append(btnItem)
            items.append(UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        toolBar.items = items
        toolBar.tintColor = UIColor.orange
    }
}

// MARK:- 事件监听
extension EmoticonController {

    @objc fileprivate func btnItemClick(btnItem: UIBarButtonItem) {
        let indexPath = IndexPath.init(item: 0, section: btnItem.tag)
        
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}

// MARK:- UICollectionView的数据源和代理方法
extension EmoticonController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return manager.packages[section].emoticons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emoticonID, for: indexPath) as! EmoticonCell
        
//        cell.backgroundColor = indexPath.item % 2 == 0 ? UIColor.lightGray : UIColor.black
        cell.emoticon = manager.packages[indexPath.section].emoticons[indexPath.item]
        
        return cell
    }
    
    // 代理方法
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 取出点击的表情
        let package = manager.packages[indexPath.section]
        let emoticon = package.emoticons[indexPath.item]
        
        // 将点击的表情添加最近分组
        insertRecentlyEmoticon(selectedEmoticon: emoticon)
        
        // 将selectedEmotion传递给外部控制器
        emoticonCallBack(emoticon)
    }
    
    fileprivate func insertRecentlyEmoticon(selectedEmoticon: Emoticon) {
        if selectedEmoticon.isEmpty || selectedEmoticon.isRemove {
            return
        }
        
        if manager.packages.first?.emoticons.contains(selectedEmoticon) == true {
            let index = (manager.packages.first?.emoticons.index(of: selectedEmoticon))!
            manager.packages.first?.emoticons.remove(at: index)
        } else {
            manager.packages.first?.emoticons.remove(at: 19)
        }
    
        manager.packages.first?.emoticons.insert(selectedEmoticon, at: 0)
        
    }
}

fileprivate class EmoticonCollectioViewLayout : UICollectionViewFlowLayout {

    override func prepare() {
        let itemWH = UIScreen.main.bounds.width / 7
        itemSize = CGSize.init(width: itemWH, height: itemWH)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        scrollDirection = .horizontal
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        
        let h = collectionView!.bounds.height
        let inset = (h - itemWH * 3) / 2
        collectionView?.contentInset = UIEdgeInsets.init(top: inset, left: 0, bottom: inset, right: 0)
    }
}

