//
//  UIViewController+KingfisherOperation.swift
//  Kingfisher
//
//  Created by onevcat on 2018/11/18.
//
//  Copyright (c) 2019 Wei Wang <onevcat@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit
import Kingfisher

/// 定义仅有一个 reload 方法的协议，用于进行 tableView 和 collectionView 的刷新
protocol MainDataViewReloadable {
    func reload()
}

/// UITableViewController 和 UICollectionViewController 分别遵循 MainDataViewReloadable 协议实现各自的 reload 协议方法
extension UITableViewController: MainDataViewReloadable {
    func reload() {
        tableView.reloadData()
    }
}

extension UICollectionViewController: MainDataViewReloadable {
    func reload() {
        collectionView.reloadData()
    }
}

/// 定义仅有一个 alertPopup 方法的协议（alertPopup 方法用于构建 UIAlertController）
protocol KingfisherActionAlertPopup {
    func alertPopup(_ sender: Any) -> UIAlertController
}

/// 定义一个全局函数，用于创建一个 清理缓存 的 UIAlertAction
/// - Returns: UIAlertAction 对象
func cleanCacheAction() -> UIAlertAction {
    return UIAlertAction(title: "Clean Cache", style: .default) { _ in
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
}

/// 定义一个全局函数，用于创建一个 刷新 的 UIAlertAction
/// - Parameter reloadable: 入参需要遵循 MainDataViewReloadable 协议，它会有一个 reload 函数
/// - Returns: UIAlertAction 对象
func reloadAction(_ reloadable: MainDataViewReloadable) -> UIAlertAction {
    return UIAlertAction(title: "Reload", style: .default) { _ in
        reloadable.reload()
    }
}

/// 取消 按钮
let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

/// 全局函数创建 UIAlertController
/// - Parameters:
///   - sender: 触发点
///   - actions: action 数组
/// - Returns: UIAlertController 对象
func createAlert(_ sender: Any, actions: [UIAlertAction]) -> UIAlertController {
    let alert = UIAlertController(title: "Action", message: nil, preferredStyle: .actionSheet)
    
    // UIPopoverPresentationController 需要下面两个属性设置
    alert.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
    alert.popoverPresentationController?.permittedArrowDirections = .any
    
    // 使用 forEach 把 actions 数组中的 UIAlertAction 都添加到 alert 上
    actions.forEach { alert.addAction($0) }
    
    return alert
}

/// UIViewController 遵循 KingfisherActionAlertPopup 协议，需要实现 alertPopup 这个协议方法
extension UIViewController: KingfisherActionAlertPopup {
    @objc func alertPopup(_ sender: Any) -> UIAlertController {
        
        // 创建 UIAlertController，添加 清理缓存 和 取消 两个 action
        let alert = createAlert(sender, actions: [cleanCacheAction(), cancelAction])
        
        // 判断 UIViewController 是否遵循 MainDataViewReloadable 协议，如果遵循的话再添加一个 刷新 的 action。
        // 这里遵循协议的判定用的 as? 符号，原来还可以这么用，一直觉的 as 仅是用来做类型转换的。
        if let r = self as? MainDataViewReloadable {
            alert.addAction(reloadAction(r))
        }
        
        return alert
    }
}

extension UIViewController  {
    
    /// 给导航条右边添加一个 action 按钮
    func setupOperationNavigationBar() {
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Action", style: .plain, target: self, action: #selector(performKingfisherAction))
    }
    
    /// action 点击事件
    /// - Parameter sender: UIBarButtonItem 对象
    @objc func performKingfisherAction(_ sender: Any) {
        present(alertPopup(sender), animated: true)
    }
}
