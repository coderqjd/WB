//
//  MessageViewController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/4.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.setupVisitorViewInfo(iconName: "visitordiscover_image_message", title: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
        
    }
    
    deinit {
        print("MessageViewController.deinit")
    }
}

