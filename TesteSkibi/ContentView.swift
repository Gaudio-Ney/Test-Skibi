//
//  ContentView.swift
//  TesteSkibi
//
//  Created by Gáudio Ney on 14/10/20.
//

import SwiftUI
import LinkPresentation

struct ContentView: View {
    //can default original state
    @State var togglePreview = false
    let urls: [String] = ["https://medium.com/","https://www.youtube.com/watch?v=Q9QwguLSKw0","https://yahoo.com","https://stackoverflow.com", "https://github.com/yStrack/Skibi", "https://www.facebook.com/", "https://twitter.com/carolgradel/status/1316026645946363907?s=20", "https://www.instagram.com/p/CGVFbOEh-WL/?utm_source=ig_web_copy_link"]
    let colums = [GridItem(.flexible(minimum: 180)), GridItem(.flexible(minimum: 180))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: colums, spacing: 10) {
                    ForEach(urls, id: \.self) { url in
                        URLPreview(previewURL: URL(string: url)!, togglePreview: self.$togglePreview)
                            .frame(width: 180, height:300)
                            .padding(.horizontal)
                            .aspectRatio(contentMode: .fit)
                    }
            }.padding()
        }//.background(Color(.black))
    }
}

struct URLPreview : UIViewRepresentable {
    var previewURL:URL
    //Add binding
    @Binding var togglePreview: Bool
    
    func makeUIView(context: Context) -> LPLinkView {
        let view = LPLinkView(url: previewURL)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 180).isActive = true
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        let provider = LPMetadataProvider()
        
        provider.startFetchingMetadata(for: previewURL) { (metadata, error) in
            if let md = metadata {
                DispatchQueue.main.async {
                    view.metadata = md
                    view.sizeToFit()
//                    view.sizeThatFits(CGSize(width: 100, height: 100))
//                    self.togglePreview.toggle()
                }
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: LPLinkView, context: UIViewRepresentableContext<URLPreview>) {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
