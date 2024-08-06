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
            let osz = transparent.extent.size
            let resizedImg = transparent.transformed(by: CGAffineTransform(scaleX: w! / osz.width, y: h! / osz.height))
            return UIImage(cgImage: context.createCGImage(resizedImg, from: resizedImg.extent)!)
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
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
