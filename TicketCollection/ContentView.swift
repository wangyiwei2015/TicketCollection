//
//  ContentView.swift
//  TicketCollection
//
//  Created by leo on 2023-11-12.
//

import SwiftUI
import SwiftData

@MainActor
struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: [SortDescriptor(\TicketItem.departTime)]) var tickets: [TicketItem]
    
    @State var showsEditor = false
    
    let str: [String] = [
        "FangSong_GB2312",
        "SimHei",
        "SimSun",
        "Arial Unicode MS",
        "STSong",
        "STHeitiSC-Medium",
        "Technic-Bold",
        "Technic",
    ]
    
    var body: some View {
        VStack {
            ForEach(0..<str.count, id: \.self) {id in
                Text("\(str[id]) ABCacb123啊")
                    .font(.custom(str[id], fixedSize: 20))
            }
            Button("all") {
                for family in UIFont.familyNames.sorted() {
                    let names = UIFont.fontNames(forFamilyName: family)
                    print("Family: \(family) Font names: \(names)")
                }
            }
            ShareLink("Export PDF", item: render())
            Button("Editor") {showsEditor = true}.buttonStyle(.borderedProminent).font(.title)
            Button("debug show") {print(tickets.count)}
            Button("Add empty") {modelContext.insert(TicketItem()); try! modelContext.save()}
        }
        .padding()
        .fullScreenCover(isPresented: $showsEditor) {
            EditorView(ticketItem: tickets[0], trainDate: Date())
        }
    }
    
    func render() -> URL {
        // 1: Render Hello World with some modifiers
        let renderer = ImageRenderer(content:
            Text("Hello, world!")
            .font(.largeTitle)
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(Capsule())
        )
        
        // 2: Save it to our documents directory
        let url = URL.documentsDirectory.appending(path: "output.pdf")
        
        // 3: Start the rendering process
        renderer.render { size, context in
            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            
            // 5: Create the CGContext for our PDF pages
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }
            
            // 6: Start a new PDF page
            pdf.beginPDFPage(nil)
            
            // 7: Render the SwiftUI view data onto the page
            context(pdf)
            
            // 8: End the page and close the file
            pdf.endPDFPage()
            pdf.closePDF()
        }
        
        return url
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TicketItem.self, configurations: config)
    
    for i in 1..<5 {
        let t = TicketItem()
        t.departTime = Date(timeIntervalSinceNow: TimeInterval(60 * i))
        container.mainContext.insert(t)
    }
    
    return ContentView()
        .modelContainer(container)
}
