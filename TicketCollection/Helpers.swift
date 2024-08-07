//
//  DateHelper.swift
//  TicketCollection
//
//  Created by leo on 2024-01-22.
//

import SwiftUI

// - MARK: Date Formatter

let df: DateFormatter = {
    let _df = DateFormatter()
    _df.dateFormat = "YYYYMMDDHHmm"
    return _df
}()

// - MARK: Render view

extension View {
    func snapshot() -> UIImage {
        let hosting = UIHostingController(rootView: self.ignoresSafeArea())
        let window = UIWindow(frame: CGRect(
            origin: .zero, size: hosting.view.intrinsicContentSize
        ))
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
    }
}

extension UIView {
    var renderedImage: UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

/* iOS 16+
 func generateSnapshot() {
 Task {
 let renderer = await ImageRenderer(
 content: ())
 if let image = await renderer.uiImage {
 self.snapshot = image
 }
 }
 }
 */

// - MARK: Hans to Pinyin

extension String {
    func 拼音(带声调: Bool = false, 带空格: Bool = false) -> String? {
        var cfstr = NSMutableString(string: self) as CFMutableString
        if CFStringTransform(cfstr, nil, kCFStringTransformMandarinLatin, false) {
            if !带声调 {
                CFStringTransform(cfstr, nil, kCFStringTransformStripDiacritics, false)
            }
            var result = String(cfstr)
            if !带空格 {
                result.removeAll(where: {$0 == " "})
            }
            return result
        } else {
            return nil
        }
    }
}
