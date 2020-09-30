//
//  ViewExtensions.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 30/09/20.
//

import SwiftUI

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> TupleView<(Self?, Content?)> {
        if conditional { return TupleView((nil, content(self))) }
        else { return TupleView((self, nil)) }
    }
}
