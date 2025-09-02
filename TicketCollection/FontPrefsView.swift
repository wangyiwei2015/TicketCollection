//
//  FontPrefsView.swift
//  TicketCollection
//
//  Created by leo on 2025.08.01.
//

import SwiftUI
import UIKit
import CoreText

struct FontLoaderView: View {
    @State private var customFont: UIFont? = nil
    @State private var showDocumentPicker = false
    @State private var showSysFontPicker = false
    @State private var compSelection = 0
    
    @Environment(\.dismiss) var dismiss
    
    @ViewBuilder func fontText(_ str: String) -> some View {
        Text(str).font(.system(size: 20)).lineLimit(1).padding(5)
    }
    @ViewBuilder func bg(for sel: Int) -> some View {
        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(sel == compSelection ? 0.2 : 0.001))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Group {
                    Image(systemName: "character.book.closed.fill").foregroundStyle(.gray)
                    Text("自定义字体").foregroundStyle(ticketColorDarker)
                }.font(.title2).bold()
                Spacer()
                Button {
                    dismiss()
                } label: {Image(systemName: "xmark")
                }.buttonStyle(TCButtonStyle(filled: false))
                    .frame(width: 50, height: 40)
            }
            
            #if DEBUG
            
            GeometryReader { geometry in
                let w = geometry.size.width
                let h = geometry.size.height
                return ZStack {
                    VStack(spacing: 0) {
                        HStack {
                            fontText("lorem ipsum font").background(bg(for: 1))
                                .onTapGesture { withAnimation { compSelection = 1 }}
                            Spacer()
                            fontText("lorem ipsum font").background(bg(for: 2))
                                .onTapGesture { withAnimation { compSelection = 2 }}
                        }.padding(.horizontal)
                        HStack {
                            fontText("lorem ipsum font").background(bg(for: 3))
                                .onTapGesture { withAnimation { compSelection = 3 }}
                            Spacer()
                            fontText("lorem ipsum font").background(bg(for: 4))
                                .onTapGesture { withAnimation { compSelection = 4 }}
                        }.padding(.horizontal)
                        HStack {
                            fontText("lorem ipsum font").background(bg(for: 5))
                                .onTapGesture { withAnimation { compSelection = 5 }}
                            Spacer()
                            fontText("lorem ipsum font").background(bg(for: 6))
                                .onTapGesture { withAnimation { compSelection = 6 }}
                        }.padding(.horizontal)
                        HStack {
                            fontText("lorem ipsum font").background(bg(for: 7))
                                .onTapGesture { withAnimation { compSelection = 7 }}
                        }.padding(.horizontal)
                        RoundedRectangle(cornerRadius: 20).fill(ticketColor)
                            .aspectRatio(CGSize(width: 85, height: 54), contentMode: .fit)
                            .padding(.vertical, 5)
                        HStack {
                            fontText("lorem ipsum font").background(bg(for: 8))
                                .onTapGesture { withAnimation { compSelection = 8 }}
                            Spacer()
                            fontText("lorem ipsum font").background(bg(for: 9))
                                .onTapGesture { withAnimation { compSelection = 9 }}
                        }.padding(.horizontal)
                        HStack {
                            fontText("lorem ipsum font").background(bg(for: 10))
                                .onTapGesture { withAnimation { compSelection = 10 }}
                            Spacer()
                            fontText("lorem ipsum font").background(bg(for: 11))
                                .onTapGesture { withAnimation { compSelection = 11 }}
                        }.padding(.horizontal)
                    }
                    Group {
                        Capsule().fill(ticketColorDarker).frame(width: 6)
                            .frame(height: 40).offset(x: 0, y: h * -0.126)
                        Capsule().fill(ticketColorDarker).frame(width: 6)
                            .frame(height: 44).offset(x: w * -0.36, y: h * -0.185)
                        Capsule().fill(ticketColorDarker).frame(width: 6)
                            .frame(height: 44).offset(x: w * 0.36, y: h * -0.185)
                        
                        Capsule().fill(ticketColorDarker).frame(width: 6)
                            .frame(height: 220).offset(x: w * -0.5, y: h * -0.183)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 15).offset(x: w * -0.484, y: h * 0.01)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 12).offset(x: w * -0.488, y: h * -0.376)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 12).offset(x: w * -0.488, y: h * -0.31)
                        
                        Capsule().fill(ticketColorDarker).frame(width: 6)
                            .frame(height: 188).offset(x: w * 0.5, y: h * -0.21)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 30).offset(x: w * 0.46, y: h * -0.046)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 12).offset(x: w * 0.488, y: h * -0.376)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 12).offset(x: w * 0.488, y: h * -0.31)
                        
                        Capsule().fill(ticketColorDarker).frame(width: 6)
                            .frame(height: 16).offset(x: w * -0.25, y: h * 0.278)
                        
                        Capsule().fill(ticketColorDarker).frame(width: 6)
                            .frame(height: 150).offset(x: w * -0.5, y: h * 0.244)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 15).offset(x: w * -0.484, y: h * 0.11)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 12).offset(x: w * -0.488, y: h * 0.376)
                        
                        Capsule().fill(ticketColorDarker).frame(width: 6)
                            .frame(height: 36).offset(x: w * 0.18, y: h * 0.26)
                        
                        Capsule().fill(ticketColorDarker).frame(width: 6)
                            .frame(height: 194).offset(x: w * 0.5, y: h * 0.2)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 45).offset(x: w * 0.44, y: h * 0.035)
                        Capsule().fill(ticketColorDarker).frame(height: 6)
                            .frame(width: 12).offset(x: w * 0.488, y: h * 0.376)
                    }
                }
            }.aspectRatio(0.8, contentMode: .fit)
            .ignoresSafeArea()
            
            #else
            Text("还在开发🤔")
            #endif
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 24).fill(Color.systemBackground)
                VStack(spacing: 16) {
                    Text("Hello, \((customFont ?? .systemFont(ofSize: 20)).fontName)")
                        .font(customFont != nil ? Font(customFont!) : .system(size: 20))
                        .padding()
                    
                    Button {
                        showDocumentPicker = true
                    } label: {
                        Text("选择字体文件…")
                    }.buttonStyle(TCButtonStyle())
                    
                    Button {
                        showSysFontPicker = true
                    } label: {
                        Text("选择已安装的字体")
                    }.buttonStyle(TCButtonStyle())
                }.padding().padding(.horizontal, 30)
            }.frame(height: 160)
        }
        .padding().background(Color(UIColor.systemGray6))
        
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                if let font = loadFont(from: url) {
                    customFont = font
                } else {
                    print("字体加载失败")
                }
            }
        }
        .sheet(isPresented: $showSysFontPicker) {
            SysFontPicker(selectedFont: $customFont)
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var onFileSelected: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.font])
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let selectedURL = urls.first else { return }
            parent.onFileSelected(selectedURL)
        }
    }
}

// 加载字体函数
func loadFont(from fileURL: URL) -> UIFont? {
    // 获取Documents目录路径
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let destinationURL = documentsURL.appendingPathComponent("somefont.raw")//fileURL.lastPathComponent)
    do {
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            try FileManager.default.removeItem(at: destinationURL)
        }
        try FileManager.default.copyItem(at: fileURL, to: destinationURL)
        let fontData = try Data(contentsOf: destinationURL)
        let provider = CGDataProvider(data: fontData as CFData)!
        let font = CGFont(provider)!
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("字体注册失败: \(String(describing: error?.takeRetainedValue()))")
            return nil
        }
        
        guard let postScriptName = font.postScriptName as String? else {
            print("无法获取字体的PostScript名称")
            return nil
        }
        
        let uiFont = UIFont(name: postScriptName, size: 24)
        return uiFont
    } catch {
        print("加载字体文件时出错: \(error.localizedDescription)")
        return nil
    }
}

struct SysFontPicker: View {
    @Binding var selectedFont: UIFont?
    @State var searchText = ""
    @Environment(\.dismiss) var dismiss
    
    var availableFonts: [String] {
        if searchText.isEmpty {
            return UIFont.familyNames
        } else {
            return UIFont.familyNames.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(availableFonts, id: \.self) { familyName in
                Section(header: Text(familyName)) {
                    ForEach(UIFont.fontNames(forFamilyName: familyName), id: \.self) { fontName in
                        Button {
                            selectedFont = UIFont(name: fontName, size: 24)
                            dismiss()
                        } label: {
                            Text(fontName)
                        }
                    }
                } // Section
            } // List
        } // NavigationStack
        .searchable(text: $searchText) {
//            ForEach(
//                searchText.count < 2 ? [] : availableFonts,
//                id: \.self
//            ) { result in
//                Text("Completion: \(result)").searchCompletion(result)
//            }
        }
        .tint(ticketColorDarker)
    }
}

#Preview {
    FontLoaderView()
}
