//
//  ContentView.swift
//  Obvious-Project
//
//  Created by Babul Raj on 02/03/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var presenter: ImageListPresenter
    @State private var showingAlert = false
    var body: some View {
        NavigationStack {
            List(0..<presenter.imageList.count, id:\.self) {
                index in
                ZStack {
                    ImageCellView(text: presenter.imageList[index].title, url: presenter.imageList[index].url)
                    NavigationLink("") {
                        DetailedView(title: presenter.imageList[index].title, text: presenter.imageList[index].explanation, url: presenter.imageList[index].hdURL!)
                    }.opacity(0)
                }
            }.navigationTitle("Image List")
            .onAppear {
                presenter.getImages()
            }
            .refreshable {
                presenter.getImages()
            }
            
            .alert(presenter.error?.localizedDescription ?? "Alert", isPresented: $presenter.showError) {
                HStack {
                    Button("Cancel") {
                        
                    }
                    Button("Try again") {
                        presenter.getImages()
                    }
                }
            }
        }
    }
}

struct ImageCellView: View {
    var text:String
    var url:String
    var font: Font = .headline
    
    var body: some View {
        VStack {
            HStack {
                Text(text)
                    .font(font)
                Spacer()
            }
            
            AsyncImageCache(url: URL(string:url)!) { phase in
                if phase.image == nil {
                    ProgressView()
                } else {
                    phase.image?.resizable()
                        .frame(height:300)
                }
            }
        }
    }
}

struct DetailedView: View {
    var title:String
    var text:String
    var url:String
    var font: Font = .headline
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text(title)
                        .font(font)
                    Spacer()
                }
                
                Spacer()
                    .frame(height:30)
                AsyncImageCache(url: URL(string:url)!) { phase in
                    if phase.image == nil {
                        ProgressView()
                    } else {
                        phase.image?.resizable()
                            .frame(height:300)
                    }
                }
                
                Text(text)
                    .font(.headline)
            }
        }.padding()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        //ContentView(presenter: <#ImageListPresenter#>)
//    }
//}

