//
//  AutoSizingTableViewController.swift
//  Kingfisher
//
//  Created by onevcat on 2021/03/15.
//
//  Copyright (c) 2021 Wei Wang <onevcat@gmail.com>
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

// Cell with an image view (loading by Kingfisher) with fix width and dynamic height which keeps the image with aspect ratio.
class AutoSizingTableViewCell: UITableViewCell {
    
    // 宽度限制为 200，高度根据图片原始比例计算
    static let p = ResizingImageProcessor(referenceSize: .init(width: 200, height: CGFloat.infinity), mode: .aspectFit)
    
    @IBOutlet weak var leadingImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    
    /// 更新布局的闭包
    var updateLayout: (() -> Void)?
    
    func set(with url: URL) {
        
        leadingImageView.kf.setImage(with: url, options: [.processor(AutoSizingTableViewCell.p), .transition(.fade(1))]) { r in

            // 处理完成的回调
            if case .success(let value) = r {
                self.sizeLabel.text = "\(value.image.size.width) x \(value.image.size.height)"
                self.updateLayout?()
            } else {
                self.sizeLabel.text = ""
            }
        }
    }
}

class AutoSizingTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    // 699 个 cell
    var data: [Int] = Array(1..<700)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 默认情况下启用动画。如果禁用动画，后续动画块中的代码仍会执行，但实际上不会发生动画。
        // 因此，您在动画块内所做的任何更改都会立即反映出来，而不是进行动画处理。
        // 无论您使用基于块的动画方法还是开始/提交动画方法，都是如此。
        
        // 此方法仅影响调用后提交的那些动画。如果您在现有动画运行时调用此方法，这些动画将继续运行，直到它们到达它们的自然终点。
        
        // class func setAnimationsEnabled(_ enabled: Bool)
        
        // 关闭 UIView 动画
        UIView.setAnimationsEnabled(false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 需要再打开 UIView 动画
        UIView.setAnimationsEnabled(true)
    }
}

extension AutoSizingTableViewController: UITableViewDataSource {
    
    // 更新布局
    private func updateLayout() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AutoSizingTableViewCell", for: indexPath) as! AutoSizingTableViewCell
        
        // https://github.com/onevcat/Flower-Data-Set/raw/master/rose/rose-\(index).jpg
        cell.set(with: ImageLoader.roseImage(index: data[indexPath.row]))
        
        // 回调 tableView 更新布局
        cell.updateLayout = { [weak self] in
            self?.updateLayout()
        }
        
        return cell
    }
    
    
}
