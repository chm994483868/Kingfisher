//
//  ProgressiveJPEGViewController.swift
//  Kingfisher
//
//  Created by lixiang on 2019/5/12.
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

class ProgressiveJPEGViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    
    private var isBlur = true
    private var isFastestScan = true
    
    // RoundCornerImageProcessor 是用于制作圆角图像的处理器。
    // macOS 仅支持基于 CG 的图像，如果传入非 CG 图像，则处理器将不执行任何操作。
    // - 注意：输入图像将在移除圆角像素的情况下呈现。如果图像本身不包含 alpha 通道（例如，JPEG 图像），则处理后的图像将在内存中包含 alpha 通道以正确显示。
    //        但是，当缓存到磁盘时，Kingfisher 默认尊重原始图像格式。这意味着这些图像的 alpha 通道将被删除。当您再次从缓存中加载处理后的图像时，您将失去透明角。
    // 在这种情况下，您可以使用 `FormatIndicatedCacheSerializer.png` 强制 Kingfisher 将图像序列化为 PNG 格式。
    private let processor = RoundCornerImageProcessor(cornerRadius: 30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Progressive JPEG"
        setupOperationNavigationBar()
        loadImage()
    }
    
    private func loadImage() {
        progressLabel.text = "- / -"
        
        let progressive = ImageProgressive(
            isBlur: isBlur,
            isFastestScan: isFastestScan,
            scanInterval: 0.1
        )

        KF.url(ImageLoader.progressiveImageURL)
            .loadDiskFileSynchronously()
            .progressiveJPEG(progressive)
            .roundCorner(radius: .point(30))
            .onProgress { receivedSize, totalSize in
                print("\(receivedSize)/\(totalSize)")
                self.progressLabel.text = "\(receivedSize) / \(totalSize)"
            }
            .onSuccess { result in
                print(result)
                print("Finished")
            }
            .onFailure { error in
                print(error)
                self.progressLabel.text = error.localizedDescription
            }
            .set(to: imageView)
    }
    
    override func alertPopup(_ sender: Any) -> UIAlertController {
        let alert = super.alertPopup(sender)
        
        func reloadImage() {
            // Cancel
            imageView.kf.cancelDownloadTask()
            // Clean cache
            KingfisherManager.shared.cache.removeImage(
                forKey: ImageLoader.progressiveImageURL.cacheKey,
                processorIdentifier: self.processor.identifier,
                callbackQueue: .mainAsync,
                completionHandler: {
                    self.loadImage()
                }
            )
        }
        
        do {
            let title = isBlur ? "Disable Blur" : "Enable Blur"
            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                self.isBlur.toggle()
                reloadImage()
            })
        }
        
        do {
            let title = isFastestScan ? "Disable Fastest Scan" : "Enable Fastest Scan"
            alert.addAction(UIAlertAction(title: title, style: .default) { _ in
                self.isFastestScan.toggle()
                reloadImage()
            })
        }
        return alert
    }
}
