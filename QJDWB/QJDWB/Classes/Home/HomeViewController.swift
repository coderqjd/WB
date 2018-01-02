//
//  HomeViewController.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/4.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh

class HomeViewController: BaseViewController {
    
    /// 记录提示栏显示
    var isTipLabelShowing: Bool = false

    // MARK:- 懒加载属性
    fileprivate lazy var titleBtn : TitleButton = TitleButton()
    fileprivate lazy var popoverAnimator : PopoverAnimator = PopoverAnimator.init { [weak self] (isPresented) in
        // 调整titleBtn的状态
        self?.titleBtn.isSelected = isPresented
    }
    fileprivate lazy var statusVMs : [StatusViewModel] = [StatusViewModel]()
    fileprivate lazy var tipLabel : UILabel = UILabel()
    fileprivate lazy var photoBrowserAnimator = PhotoBrowserAnimator.init()
    
    // MARK:- 系统回调方法
    override func viewDidLoad() {
        super.viewDidLoad()

        // 没有登录设置
        visitorView.addRotationAnimation()
        if !isLogin {
            return
        }
    
        // 设置登录时的导航栏内容
        setupNavigationBar()
        
        // 自动计算cell高度
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 添加刷新控件
        setupRefresh()
        
        // 添加提示的label
        setupTipLabel()
        
        // 注册通知
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK:- UI界面
extension HomeViewController {
    fileprivate func setupNavigationBar() {
        // 设置左边的item
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_friendattention")
        
        // 设置右侧的item
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(imageName: "navigationbar_pop")
        
        // 设置titleView
        titleBtn.setTitle("coderqjd", for: .normal)
        titleBtn.addTarget(self, action: #selector(titleBtnClick(titleButton:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
    
    fileprivate func setupRefresh() {
        // 创建headerView
        let header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadNewStatuses))
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("释放更新", for: .pulling)
        header?.setTitle("加载中...", for:.refreshing)
        tableView.mj_header = header
        // 开始刷新
        self.tableView.mj_header.beginRefreshing()
        
        tableView.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadMoreStatuses))
    }
    
    fileprivate func setupTipLabel() {
        navigationController?.view.insertSubview(tipLabel, belowSubview: (navigationController?.navigationBar)!)
        tipLabel.frame = CGRect.init(x: 0, y: 32, width: UIScreen.main.bounds.width, height: 32)
        tipLabel.backgroundColor = UIColor.orange
        tipLabel.alpha = 0.8
        tipLabel.textColor = UIColor.white
        tipLabel.font = UIFont.systemFont(ofSize: 14)
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
    }
    
    // 注册通知
    fileprivate func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPhotoBrowser(note:)), name: NSNotification.Name.init(showPhotoBrowserNote), object: nil)
    }
}

// MARK:- 事件监听
extension HomeViewController {
    // 加载最新数据
    @objc fileprivate func loadNewStatuses() {
//        loadStatuses(isNewData: true)
        loadLocalData()
    }
    
    // 加载更多数据
    @objc fileprivate func loadMoreStatuses() {
        loadStatuses(isNewData: false)
    }
    
    // 标题点击事件
    @objc fileprivate func titleBtnClick(titleButton: TitleButton) {
        // 创建控制器
        let popoverVc = PopoverViewController()
        // 设置模态的样式（如果不设置，导航栏和标签栏会被系统移除）
        popoverVc.modalPresentationStyle = .custom
        // 设置转场代理
        popoverVc.transitioningDelegate = popoverAnimator
        popoverAnimator.presentViewFrame = CGRect.init(x: 100, y: 60, width: 180, height: 250)
        // 弹出控制器
        present(popoverVc, animated: true, completion: nil)
    }
    
    // 监听显示照片浏览器通知
    @objc fileprivate func showPhotoBrowser(note: Notification) {
        // 取出indexPath和URL数组
        let indexPath = note.userInfo?[showPhotoBrowserIndexPath] as! IndexPath
        let picURLs = note.userInfo?[showPhotoBrowserPictureURLs] as! [URL]
        let picCollectionView = note.object as! PicCollectionView
        
        let photoBrowserVc = PhotoBrowserController.init(indexPath: indexPath, picUrls: picURLs)
        photoBrowserVc.modalPresentationStyle = .custom
        photoBrowserVc.transitioningDelegate = photoBrowserAnimator
        
        photoBrowserAnimator.presentDelegate = picCollectionView
        photoBrowserAnimator.indexPath = indexPath
        
        photoBrowserAnimator.dismissDelegate = photoBrowserVc
        present(photoBrowserVc, animated: true, completion: nil)
    }
}

// MARK:- 请求数据
extension HomeViewController {
    
    fileprivate func loadLocalData() {
        let dict = NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "json", ofType: "plist")!)!
        let dicts = dict["statuses"] as! [[String : Any]]
        var tempViewModels = [StatusViewModel]()
        for dict in dicts {
            // 将模型保存到数组中
            let status = Status.init(dict)
            let statusVM = StatusViewModel.init(status: status)
            tempViewModels.append(statusVM)
        }
        
        self.statusVMs = tempViewModels
        
        // 5.缓存图片,刷新表格
        self.cacheImages(viewModels: tempViewModels)
    }

    fileprivate func loadStatuses(isNewData: Bool) {
        var since_id = 0
        var max_id = 0
        
        if isNewData {
            since_id = statusVMs.first?.status?.mid ?? 0
        } else {
            max_id = statusVMs.last?.status?.mid ?? 0
            max_id = max_id == 0 ? max_id : max_id - 1
        }
    
        NetworkTools.shareInstance.loadStatuses(since_id: since_id, max_id: max_id) { (results, error) in
            // 1.错误校验
            if error != nil {
                print(error!)
                return
            }
            
            // 2.获取去字典数组数据
            guard let dicts = results else {
                return
            }
            
            // 3.遍历数组
            var tempViewModels = [StatusViewModel]()
            for dict in dicts {
                // 将模型保存到数组中
                let status = Status.init(dict)
                let statusVM = StatusViewModel.init(status: status)
                tempViewModels.append(statusVM)
            }
            
            // 4.将最新的数据放到模型数组最前面
            if isNewData {
                self.statusVMs = tempViewModels + self.statusVMs
            } else {
                self.statusVMs += tempViewModels
            }
            
            // 5.缓存图片,刷新表格
            self.cacheImages(viewModels: tempViewModels)
        }
    }
    
    fileprivate func cacheImages(viewModels: [StatusViewModel]) {
        // 创建group, 执行完异步操作
        let group = DispatchGroup()
        
        // 缓存图片
        for viewModel in viewModels {
            for picURL in viewModel.picURLs {
                group.enter()
                SDWebImageManager.shared().loadImage(with: picURL, options: [], progress: nil, completed: { (_, _, _, _, _, _) in
                group.leave()
                })
            }
            
        }
        
        // 刷新表格
        group.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            // 显示提示label
            self.showTipLabel(count: viewModels.count)
        }
    }
    
    /// 显示提示label
    ///
    /// - Parameter count: 更新的微博数量
    fileprivate func showTipLabel(count: Int) {
        if isTipLabelShowing {
            return
        }
        isTipLabelShowing = true
        tipLabel.isHidden = false
        tipLabel.text = count == 0 ? "暂时没有新微博,休息下吧" : "更新了\(count)条微博"
        UIView.animate(withDuration: 1, animations: { 
            self.tipLabel.frame.origin.y = 64
        }) { (_) in
            UIView.animate(withDuration: 1, delay: 1.5, options: [], animations: { 
                self.tipLabel.frame.origin.y = 32
            }) { (_) in
                self.tipLabel.isHidden = true
                self.isTipLabelShowing = false
            }
        }
    }
}


// MARK:- tableView数据源和代理方法
extension HomeViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.mj_footer.isHidden = statusVMs.count == 0
        return statusVMs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "status") as! HomeCell
        
        cell.statusVM = statusVMs[indexPath.row]
        
        return cell
    }
}

