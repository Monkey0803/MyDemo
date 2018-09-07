//
//  SwiftViewController.swift
//  ThirdLib
//
//  Created by 王博 on 2018/6/26.
//  Copyright © 2018年 胡晓辉. All rights reserved.
//

import UIKit
import Dispatch
import Foundation

class SwiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red;
        let ss = Bool.init(truncating: NSNumber(floatLiteral: 100.0))
        
        let url = URLComponents(string: "T##String")
        print("\(url?.host ?? "")")
        
        
        let label: AnyObject = UILabel()
        let _: UILabel = label as! UILabel
        
        let image = UIImage(named: "")
        let _ = image?.resizeImage(wantSize: CGSize(width: 10, height: 80))
        
        let lockTable = NSMapTable<AnyObject, AnyObject>.weakToWeakObjects()
        var locksTableLock = OS_SPINLOCK_INIT
        func synchronized(obj: AnyObject, f: () -> Void) {
            OSSpinLockLock(&locksTableLock)
            var lock = lockTable.object(forKey: obj) as! NSRecursiveLock?
            if lock == nil{
                lock = NSRecursiveLock()
                lockTable.setObject(lock!, forKey: obj)
            }
            OSSpinLockUnlock(&locksTableLock)
            lock!.lock()
            f()
            lock!.unlock()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

private extension SwiftViewController {

    
}



extension UIImage {
    
    func resizeImage(wantSize: CGSize) -> UIImage? {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        /**
         创建一个图片类型的上下文。调用UIGraphicsBeginImageContextWithOptions函数就可获得用来处理图片的图形上下文。利用该上下文，你就可以在其上进行绘图，并生成图片
         
         size：表示所要创建的图片的尺寸
         opaque：表示这个图层是否完全透明，如果图形完全不用透明最好设置为YES以优化位图的存储，这样可以让图层在渲染的时候效率更高
         scale：指定生成图片的缩放因子，这个缩放因子与UIImage的scale属性所指的含义是一致的。传入0则表示让图片的缩放因子根据屏幕的分辨率而变化，所以我们得到的图片不管是在单分辨率还是视网膜屏上看起来都会很好
         */
        
        UIGraphicsBeginImageContextWithOptions(wantSize, !hasAlpha, scale)
        self.draw(in: CGRect(origin: .zero, size: wantSize))
        let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //        return resizeImage ?? nil
        return resizeImage
    }
    
    
    func resizeImageCG(wantSize: CGSize) -> UIImage? {
        guard let cgimage = self.cgImage else { return nil }
        let bitsPerComponent = cgimage.bitsPerComponent
        let bytesPerRow = cgimage.bytesPerRow
//        let bitsPerPixel = cgimage?.bitsPerPixel
        let bitmapInfo = cgimage.bitmapInfo
        let colorSpace = cgimage.colorSpace
        guard let content = CGContext(data: nil,
                                      width: Int(wantSize.width),
                                      height: Int(wantSize.height),
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace!,
                                      bitmapInfo: bitmapInfo.rawValue) else
        {
            return nil
        }
        content.interpolationQuality = .high
        content.draw(cgimage, in: CGRect(origin: .zero, size: wantSize))
        let resizeImage = content.makeImage().flatMap{
            UIImage(cgImage: $0)
        }
        return resizeImage
    }
    /*
     CGImageSourceCreateThumbnailAtIndex
     
     Image I / O是一个功能强大但鲜为人知的用于处理图像的框架。 独立于Core Graphics，它可以在许多不同格式之间读取和写入，访问照片元数据以及执行常见的图像处理操作。 这个库提供了该平台上最快的图像编码器和解码器，具有先进的缓存机制，甚至可以逐步加载图像。
     
     作者：大神Q
     链接：https://www.jianshu.com/p/de7b6aede888
     來源：简书
     简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
     */
    func resizeImageIO(wantSize: CGSize) -> UIImage? {
        guard let data = UIImagePNGRepresentation(self) else { return nil }
        let maxPixelSize = max(wantSize.width, wantSize.height)
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
         //kCGImageSourceThumbnailMaxPixelSize为生成缩略图的大小。当设置为800，如果图片本身大于800*600，则生成后图片大小为800*600，如果源图片为700*500，则生成图片为800*500
        let option: [String : Any] = [
            kCGImageSourceThumbnailMaxPixelSize as String : maxPixelSize,
            kCGImageSourceCreateThumbnailFromImageAlways as String : true,
        ]
        let resizeImage = CGImageSourceCreateImageAtIndex(imageSource, 0, option as CFDictionary).flatMap{
            UIImage(cgImage: $0)
        }
        
        return resizeImage
    }
    /*
     CoreImage
     
     CoreImage是IOS5中新加入的一个Objective-c的框架，里面提供了强大高效的图像处理功能，用来对基于像素的图像进行操作与分析。IOS提供了很多强大的滤镜(Filter)，这些Filter提供了各种各样的效果，并且还可以通过滤镜链将各种效果的Filter叠加起来，形成强大的自定义效果，如果你对该效果不满意，还可以子类化滤镜。
     
     作者：大神Q
     链接：https://www.jianshu.com/p/de7b6aede888
     來源：简书
     简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
     */
    func resizeImageCI(wantSize: CGSize) -> UIImage? {
        guard let cgimage = self.cgImage else { return nil }
        let scale = (Double)(wantSize.width) / (Double)(wantSize.height)
        let image = CIImage(cgImage: cgimage)
        let filter = CIFilter(name: "CILanczosScaleTransform")
        filter?.setValue(image, forKey: kCIInputImageKey)
        filter?.setValue(NSNumber(value: scale), forKey: kCIInputScaleKey)
        filter?.setValue(1.0, forKey: kCIInputAspectRatioKey)
        guard let outputImage = filter?.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        
        let content = CIContext(options: [kCIContextUseSoftwareRenderer: false])
        let resizeImage = content.createCGImage(outputImage, from: CGRect(origin: .zero, size: wantSize)).flatMap{
            UIImage(cgImage: $0)
        }
        return resizeImage
    }
    
    
}



extension SwiftViewController {
    func GCD() -> Void {
        //这里的名字能够方便开发者进行Debug,
        //初始化的队列是一个默认配置的队列
        let _ = DispatchQueue(label: "T##String")
        
//        可以显式的指明对列的其他属性
        let label = "label" //队列的标识符，方便调试
        let qos = DispatchQoS.default //队列的quality of service。用来指明队列的“重要性”
        let attri = DispatchQueue.Attributes.concurrent //队列的属性
        var autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency//自动释放频率
        if #available(iOS 10.0, *) {
            autoreleaseFrequency = DispatchQueue.AutoreleaseFrequency.never
        } else {
            autoreleaseFrequency = DispatchQueue.AutoreleaseFrequency.inherit
        }
        
        let _ = DispatchQueue(label: label, qos: qos, attributes: attri, autoreleaseFrequency: autoreleaseFrequency, target: nil)
        
//        主队列/全局队列可以这样获取
        let _ = DispatchQueue.main
        let _ = DispatchQueue.global()
        let _ = DispatchQueue.global(qos: .userInitiated)
        
        let _ = DispatchQueue(label: "") //串行
        let _ = DispatchQueue(label: "T##String", attributes: DispatchQueue.Attributes.concurrent) //并行
        
        
        if #available(iOS 10.0, *) {
            DispatchQueue.main.activate()
        } else {
            // Fallback on earlier versions
        }
        
        //Qos
        let _ = DispatchQoS.default
        let _ = DispatchQoS.background //用户不可见，比如在后台存储大量数据
        let _ = DispatchQoS.userInitiated //需要立刻的结果，比如push一个ViewController之前的数据计算
        let _ = DispatchQoS.userInteractive //和用户交互相关，比如动画等等优先级最高。比如用户连续拖拽的计算
        let _ = DispatchQoS.utility //可以执行很长时间，再通知用户结果。比如下载一个文件，给用户下载进度
        let _ = DispatchQoS.unspecified
        
        //DispatchWorkItem
        
        let item = DispatchWorkItem {
            
        }
        DispatchQueue.main.async(execute: item)
        
        
        /** 第一个参数表示QoS。
        第二个参数类型为DispatchWorkItemFlags。指定这个任务的配饰信息
        第三个参数则是实际的任务block*/
        /*
         - noQoS //没有QoS
         - inheritQoS //继承Queue的QoS
         - enforceQoS //自己的QoS覆盖Queue
         */
        let _ = DispatchWorkItem(qos: .background, flags: [.enforceQoS, .assignCurrentContext]) {
            
        }
        
//        asyncAfter
//        DispatchTime 的精度是纳秒
//        DispatchWallTime 的精度是微秒
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 10) {
            print("")
        }
        DispatchQueue.global().asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
            print("")
        }

    }
    
   
    
}


struct NotificationDescriptor<A> {
    let name: Notification.Name
    let convert: (Notification) -> A
}

extension NotificationCenter {
    
    func addServer<A>(forDescriptor d: NotificationDescriptor<A>, using block: @escaping (A) -> ()) -> NSObjectProtocol {
        return addObserver(forName: d.name, object: nil, queue: nil) { (note) in
            block(d.convert(note))
        }
    }
}

enum ConversionError: Error {
    case InvalidFormat, OutOfBounds, Unknown
}

extension UInt8 {
//    init(fromStr: String) throws {
////        guard let _ = fromStr.rangeOfCharacter(from: <#T##CharacterSet#>)
////            else { return ConversionError.InvalidFormat }
//    }
    
}


