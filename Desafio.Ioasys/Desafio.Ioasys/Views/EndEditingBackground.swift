//
//  EndEditingBackground.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 30/09/20.
//

import SwiftUI

struct EndEditingBackground<Content: View>: View {
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        Color.white
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .overlay(content)
    }
}
