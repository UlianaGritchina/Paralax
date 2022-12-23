//
//  ContentView.swift
//  Paralax
//
//  Created by Ульяна Гритчина on 23.12.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var color: Color = .white
    @State private var opacity = 0
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    TabView {
                        ForEach(0..<3) { _ in
                            image(geo: geometry)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(
                        width: UIScreen.main.bounds.width,
                        height: geometry.frame(in: .global).minY > 0
                        ?  geometry.frame(in: .global).minY + (UIScreen.main.bounds.height / 5)
                        : UIScreen.main.bounds.height / 5
                    )
                    .offset(y: -geometry.frame(in: .global).minY)
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height / 5
                )
                VStack {
                    ForEach(0..<10) { _ in
                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: 200)
                    }
                    .padding()
                }
                .background(Color.red)
            }
        }
        .overlay(navBar, alignment: .top)
    }
    
    private func image(geo: GeometryProxy) -> some View {
        Image("photo")
            .resizable()
            .scaledToFill()
            .onChange(of: geo.frame(in: .global).minY) { newValue in
                DispatchQueue.main.async {
                    withAnimation {
                        if newValue <= -80 {
                            opacity = 1
                        } else {
                            opacity = 0
                        }
                    }
                }
            }
    }
    
    private var navBar: some View {
        HStack {
            backButton
            Spacer()
            RoundedRectangle(cornerRadius: 5)
                .shadow(color: .gray.opacity(Double(opacity)), radius: 3)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .overlay(Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.black))
        }
        .padding()
        .background(.ultraThinMaterial.opacity(Double(opacity)))
    }
    
    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            Circle()
                .foregroundColor(.white)
                .shadow(color: .gray.opacity(Double(opacity)), radius: 3)
                .frame(width: 30, height: 30)
                .overlay(Image(systemName: "chevron.left")
                    .foregroundColor(.black))
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
