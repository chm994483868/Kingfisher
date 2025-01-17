//
//  HighResolutionCollectionViewController.swift
//  Kingfisher
//
//  Created by onevcat on 2018/11/24.
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

private let reuseIdentifier = "HighResolution"

class HighResolutionCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "High Resolution"
        setupOperationNavigationBar()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageLoader.highResolutionImageURLs.count * 30
    }

    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // 取消下载任务
        (cell as! ImageCollectionViewCell).cellImageView.kf.cancelDownloadTask()
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath)
    {
        let imageView = (cell as! ImageCollectionViewCell).cellImageView!
        let url = ImageLoader.highResolutionImageURLs[indexPath.row % ImageLoader.highResolutionImageURLs.count]
        
        // Use different cache key to prevent reuse the same image. It is just for this demo. Normally you can just use the URL to set image.
        // 使用不同的 cache key 以防止重复使用相同的图像。它只是为这个演示。通常，您只需使用 URL 来设置图像。

        // This should crash most devices due to memory pressure.
        // 由于内存压力，这应该会使大多数设备崩溃。
        
        // let resource = ImageResource(downloadURL: url, cacheKey: "\(url.absoluteString)-\(indexPath.row)")
        // imageView.kf.setImage(with: resource)

        // This would survive on even the lowest spec devices!
        // 即使在最低规格的设备上，这也能保持运行！（采样 250 250）
        KF.url(url, cacheKey: "\(url.absoluteString)-\(indexPath.row)")
            .downsampling(size: CGSize(width: 250, height: 250))
            .cacheOriginalImage()
            .set(to: imageView)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            let vc = segue.destination as! DetailImageViewController
            let index = collectionView.indexPathsForSelectedItems![0].row
            
            // 跳转
            vc.imageURL =  ImageLoader.highResolutionImageURLs[index % ImageLoader.highResolutionImageURLs.count]
        }
    }
}
