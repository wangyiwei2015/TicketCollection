//
//  QRGen.swift
//  TicketCollection
//
//  Created by leo on 2024-01-22.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import CoreGraphics

class QRGen {
    static let shared = QRGen()
    private init() {}
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    func generateQRCode(from string: String, w: CGFloat? = nil, h: CGFloat? = nil) -> UIImage {
        filter.message = Data(string.utf8)
        //filter.correctionLevel
        if let outputImage = filter.outputImage {
            let transparent = outputImage.tinted(using: .black)!
            
            if let _w = w, let _h = h {
                let adjustedExtent = CGRect(
                    x: -(_w - transparent.extent.width) / 2,
                    y: -(_h - transparent.extent.height) / 2,
                    width: _w, height: _h)
                let cgImg = context.createCGImage(transparent.cropped(to: adjustedExtent), from: adjustedExtent)!
                print(cgImg.width)
                return UIImage(cgImage: cgImg)
            }
            
            //if let cgimg = context.createCGImage(transparent, from: CGRect(x: 0, y: 0, width: 56, height: 56)) {
            //if let cgimg = context.createCGImage(transparent, from: transparent.extent.insetBy(dx: -28, dy: -28)) {
            if let cgimg = context.createCGImage(transparent, from: transparent.extent) {
                if let _w = w, let _h = h {
                    if let resized = scaleCGImg(cgimg, w: _w, h: _h) {
                        return UIImage(cgImage: resized)
                    }
                } else {
                    print(cgimg.width)
                    return UIImage(cgImage: cgimg)
                }
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func scaleCGImg(_ originalCGImage: CGImage, w: CGFloat, h: CGFloat) -> CGImage? {
        guard let newContext = CGContext(
            data: nil, width: Int(w), height: Int(h),
            bitsPerComponent: originalCGImage.bitsPerComponent,
            bytesPerRow: originalCGImage.bytesPerRow,
            space: originalCGImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: originalCGImage.bitmapInfo.rawValue
        ) else { return nil }
        newContext.interpolationQuality = .none // 关键步骤：设置插值质量为none，避免平滑处理
        // 绘制原始CGImage到新的上下文中
        newContext.draw(originalCGImage, in: CGRect(x: 0, y: 0, width: w, height: h))
        // 从上下文中创建新的CGImage
        return newContext.makeImage()
    }
}

extension CIImage {
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }
    
    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
    
    /// Applies the given color as a tint color.
    func tinted(using color: UIColor) -> CIImage?
    {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage!
    }
}
