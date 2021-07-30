//
//  GIFViewController.swift
//  Kingfisher
//
//  Created by onevcat on 2018/11/25.
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

class GIFViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    // AnimatedImageView 表示用于显示动画图像的`UIImageView` 的子类。
    // 与在普通 `UIImageView`（一次加载所有帧）中显示动画图像不同，`AnimatedImageView` 仅尝试加载几帧（由`framePreloadCount` 定义）到减少内存使用。
    // 它提供了内存使用和 CPU 时间之间的权衡。如果您在使用普通图像视图加载 GIF 数据时遇到内存问题，您可以试试这个类。
    // Kingfisher 支持将 GIF 动画数据设置为开箱即用的 `UIImageView` 和 `AnimatedImageView`。所以在它们之间切换是相当容易的。
    @IBOutlet weak var animatedImageView: AnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = ImageLoader.gifImageURLs.last!
        
        // Should need to use different cache key to prevent data overwritten by each other.
        // 需要使用不同的 cache key 来防止数据被对方覆盖。
        KF.url(url, cacheKey: "\(url)-imageview").set(to: imageView)
        
        KF.url(url, cacheKey: "\(url)-animated_imageview").set(to: animatedImageView)
    }
}
