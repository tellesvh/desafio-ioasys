//
//  EnterpriseSearch.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 02/10/20.
//

import SwiftUI

struct EnterpriseSearch: View {
    @State var searchQuery: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack(alignment: .bottom) {
                    Image("background")
                        .resizable()
                        .frame(maxHeight: 200)
                        .aspectRatio(1 , contentMode: .fill)
                    VStack {
                        TextField("Pesquise por empresa...", text: $searchQuery)
                            .textFieldStyle(SearchTextFieldStyle())
                            .padding(.horizontal)
                            .offset(y: 25)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 200)
                Spacer()
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea([.top])
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light)
    }
}

struct SearchTextFieldStyle: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(16)
            .keyboardType(.default)
            .font(Font.custom("Rubik", size: 16))
            .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color("Gray 1")))
            .foregroundColor(.black)
    }
    
}

struct EnterpriseSearch_Previews: PreviewProvider {
    static var previews: some View {
        EnterpriseSearch()
    }
}
