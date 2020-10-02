//
//  EnterpriseSearch.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 02/10/20.
//

import SwiftUI

struct EnterpriseSearch: View {
    @State var searchQuery: String = ""
    @State var height: CGFloat = 200
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .bottom) {
                    Image("background") /* TODO Fazer imagem com símbolos Ioasys */
                        .resizable()
                        .frame(maxHeight: height)
                        .aspectRatio(1 , contentMode: .fill)
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(.gray)
                                .padding(.trailing, 4)
                            TextField("Pesquise por empresa...", text: $searchQuery, onEditingChanged: { (changed) in
                                if changed {
                                    withAnimation {
                                        height = 100
                                    }
                                } else {
                                    withAnimation {
                                        height = 200
                                    }
                                }
                            })
                            .keyboardType(.default)
                            .font(Font.custom("Rubik", size: 16))
                            .foregroundColor(.black)
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color("Gray 1")))
                    }
                    .padding(.horizontal)
                    .offset(y: 25)
                }
                .frame(maxWidth: .infinity, maxHeight: height)
                Spacer()
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea([.top])
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light)
    }
}

struct EnterpriseSearch_Previews: PreviewProvider {
    static var previews: some View {
        EnterpriseSearch()
    }
}
