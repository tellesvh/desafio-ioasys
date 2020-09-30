//
//  ProgressViewOverlay.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 30/09/20.
//

import SwiftUI

struct ProgressViewOverlay<Content: View>: View {
    @Binding var isLoading: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {
                self.content()
                    .disabled(self.isLoading)
                    .blur(radius: self.isLoading ? 2 : 0)
                
                if (isLoading) {
                    Color.black
                        .opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                }
                
                VStack {
                    ProgressView()
                }
                .padding(16)
                .background(Color.white)
                .foregroundColor(Color.primary)
                .cornerRadius(16)
                .opacity(self.isLoading ? 1 : 0)
            }
        }
    }
}
