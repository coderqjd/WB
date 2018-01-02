//
//  ComposeViewController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/23.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    // MARK:- 约束属性
    @IBOutlet weak var toolbarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerCollectionViewH: NSLayoutConstraint!
    
    // MARK:- 控件属性
    @IBOutlet weak var textView: ComposeTextView!
    @IBOutlet weak var picPickerCollectionView: PicPickerCollectionView!
    
    // MARK:- 懒加载属性
    fileprivate lazy var titleView : UIView = UIView()
    fileprivate lazy var images : [UIImage] = [UIImage]()
    fileprivate lazy var emoticonVc : EmoticonController = EmoticonController.init { [weak self] (emoticon) in
        self?.textView.insertEmoticon(emoticon)
        self?.textViewDidChange(self!.textView)
    }

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        
        textView.delegate = self
        
        setupNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 让textview成为第一响应者
        textView.becomeFirstResponder()
    }
    
    deinit {
        print("composevc.deinit")
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- UI界面
extension ComposeViewController {

    /// 设置导航栏
    fileprivate func setupNavigationBar() {
        // 设置左侧的按钮
         navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "取消", style: .plain, target: self, action: #selector(cancle))
        
        // 设置右侧的按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "发送", style: .plain, target: self, action: #selector(compose))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // 设置标题
        titleView = ComposeTitleView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 40))
        navigationItem.titleView = titleView
    }
    
    /// 通知监听
    fileprivate func setupNotification() {
        // 监听键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
        // 接收照片选择或删除的通知
        NotificationCenter.default.addObserver(self, selector: #selector(picPickerAddPhoto), name: NSNotification.Name(rawValue: picPickerAddPhotoNote), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(picPickerRemovePhoto(note:)), name: Notification.Name(picPickerRemovePhotoNote), object: nil)
    }
}

// MARK:- 事件监听
extension ComposeViewController {
    
    @objc fileprivate func cancle() {
        textView.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func compose() {
        let statusText = textView.getEmoticonString()
        
        SVProgressHUD.showInfo(withStatus: "正在发送...")
        
        NetworkTools.shareInstance.sendStatus(text: statusText) { (isSuccessed, error) in
            if isSuccessed {
                SVProgressHUD.showSuccess(withStatus: "发送微博成功！")
            } else {
                SVProgressHUD.showError(withStatus: "发送微博失败！")
                print(error!)
            }
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func keyboardWillChangeFrame(note: Notification) {
        // 持续时间
        let duration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        // 键盘的frame
        let keyBoardF = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyBoardY = keyBoardF.origin.y
        
        // 底部工具栏距离底部的间距
        let margin = UIScreen.main.bounds.height - keyBoardY
        
        toolbarBottomCons.constant = margin
        
        UIView.animate(withDuration: duration) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func pickPicture() {
        textView.resignFirstResponder()
        
        picPickerCollectionViewH.constant = screenH * 0.65
        
        UIView.animate(withDuration: 0.5) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func emojiBtnClick() {
        textView.endEditing(true)
        
        // 切换键盘
        textView.inputView = textView.inputView == nil ? emoticonVc.view : nil
        
        textView.becomeFirstResponder()
    }
}
// MARK:- 照片添加或删除的通知事件
extension ComposeViewController {
    
    @objc fileprivate func picPickerAddPhoto() {
        // 1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        return
        }

        // 2.创建控制器
        let ipc = UIImagePickerController()

        // 3.设置数据源
        ipc.sourceType = .photoLibrary

        // 4.设置代理
        ipc.delegate = self
        // 5.弹出控制器
        present(ipc, animated: true, completion: nil)
    }
    
    @objc fileprivate func picPickerRemovePhoto(note: Notification) {
        
        guard let image = note.object as? UIImage else {
            return
        }
        
        guard let index = images.index(of: image) else {
            return
        }
        
        images.remove(at: index)
        
        picPickerCollectionView.images = images
    }
}

// MARK:- UIImagePickerControllerDelegate 
extension ComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 获取image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 将图数组传给视图
        images.append(image)
        picPickerCollectionView.images = images
        
        // 选中图片后退出
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK:- UITextViewDelegate
extension ComposeViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.textView.placeHolderText.isHidden = textView.hasText
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}


