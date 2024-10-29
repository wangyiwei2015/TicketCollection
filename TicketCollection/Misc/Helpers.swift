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

// - MARK: 2D operations

extension CGSize {
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    static func +=(lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs + rhs
    }
}

// - MARK: UI
let ticketColor = Color(hue: 0.53, saturation: 0.40, brightness: 0.92)
let ticketColorDarker = Color(hue: 0.53, saturation: 0.6, brightness: 0.65)
let overlayGradient = LinearGradient(
    gradient: Gradient(colors: [Color.black.opacity(0.65), Color.black.opacity(0.85)]),
    startPoint: .top, endPoint: .bottom
)

extension Color {
    init(light: Color, dark: Color) {
        self.init(light: UIColor(light), dark: UIColor(dark))
    }
    
    init(light: UIColor, dark: UIColor) {
        self.init(uiColor: UIColor(dynamicProvider: { traits in
            switch traits.userInterfaceStyle {
            case .light, .unspecified:
                return light
            case .dark:
                return dark
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \(traits.userInterfaceStyle)")
                return light
            }
        }))
    }
    
    static let systemBackground = Color(UIColor.systemBackground)
}

struct TCButtonStyle: ButtonStyle {
    var filled: Bool
    var height: CGFloat = 36
    var tint: Color = ticketColorDarker
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(filled ? tint : Color(UIColor.systemBackground))
                .shadow(
                    color: .black.opacity(0.5),
                    radius: configuration.isPressed ? 1 : 2,
                    y: configuration.isPressed ? 0 : 1
                )
            configuration.label.bold().foregroundColor(filled ? .white : tint)
        }.frame(height: height)
    }
}

struct RoundedBtnStyle: ButtonStyle {
    var filled: Bool
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .fill(
                    filled
                    ? ticketColorDarker
                    : (configuration.isPressed
                       ? Color(UIColor.systemGray5)
                       : Color.systemBackground
                    )
                )
                .shadow(
                    color: .black.opacity(0.5),
                    radius: configuration.isPressed ? 1 : 2,
                    y: configuration.isPressed ? 0 : 1
                )
            configuration.label.foregroundColor(filled ? .white : ticketColorDarker)
        }.aspectRatio(1, contentMode: .fit)
    }
}

struct ListItemBtnStyle: ButtonStyle {
    let colorScheme: ColorScheme
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(
                    colorScheme == .dark || configuration.isPressed
                    ? UIColor.systemGray6 : UIColor.systemBackground
                ))
                .shadow(
                    color: .black.opacity(0.5),
                    radius: configuration.isPressed ? 1 : 3,
                    y: configuration.isPressed ? 0 : 2)
            configuration.label
        } // zstack
    }
}

struct MinimalistButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}

extension AnyTransition {
    static var ticketView: AnyTransition {
        AnyTransition.modifier(
            active: TicketTransitionModifier(isShown: false),
            identity: TicketTransitionModifier(isShown: true)
        )
    }
}
fileprivate struct TicketTransitionModifier: ViewModifier {
    let isShown: Bool
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(isShown ? 0 : -20), anchor: .center)
    }
}

// - MARK: Operators

infix operator ||=
func ||=(lhs: inout Bool, rhs: Bool) -> Void {
    lhs = lhs || rhs
}

infix operator &&=
func &&=(lhs: inout Bool, rhs: Bool) -> Void {
    lhs = lhs && rhs
}
