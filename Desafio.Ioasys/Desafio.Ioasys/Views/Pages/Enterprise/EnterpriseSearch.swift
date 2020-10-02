//
//  EnterpriseSearch.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 02/10/20.
//

import SwiftUI

struct EnterpriseSearch: View {
    @ObservedObject var enterpriseSearchController = EnterpriseSearchController()
    @State var loading: Bool = false
    @State var searchQuery: String = ""
    @State var hasSearched: Bool = false
    @State var enterprises: [Enterprise] = []
    @State var foundResultsText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    Image("background") /* TODO Fazer overlay com símbolos Ioasys */
                        .resizable()
                        .frame(maxHeight: 200)
                        .aspectRatio(1 , contentMode: .fill)
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass").foregroundColor(.gray)
                                .padding(.trailing, 4)
                            TextField("Pesquise por empresa...", text: $searchQuery,
                                      onCommit: {
                                        hasSearched = true
                                        searchEnterprises()
                                      })
                                .keyboardType(.default)
                                .font(Font.custom("Rubik", size: 16))
                                .foregroundColor(.black)
                        }
                        .padding(16)
                        .background(RoundedRectangle(cornerRadius: 6).foregroundColor(Color("Gray 1")))
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)
                    .offset(y: 25)
                }
                .zIndex(2.0)
                .frame(maxWidth: .infinity, maxHeight: 200)
                
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        if (!hasSearched) {
                            Text("Digite o texto da busca e toque em \"Retorno\" para efetuá-la.")
                                .foregroundColor(Color("Gray 3"))
                                .font(Font.custom("Rubik", size: 12))
                                .fontWeight(.light)
                        } else {
                            Text(foundResultsText)
                                .foregroundColor(Color("Gray 3"))
                                .font(Font.custom("Rubik", size: 12))
                                .fontWeight(.light)
                            
                            ForEach(enterprises.indices, id: \.self) { index in
                                Text("\(index) \(self.enterprises[index].enterpriseName ?? "")")
                            }
                        }
                    }
                    .padding(.top, 36)
                    .padding(.horizontal)
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea([.top])
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.light)
    }
    
    func searchEnterprises() {
        loading = true
        foundResultsText = ""
        enterpriseSearchController.searchEnterprises(query: searchQuery) {
            (result: Result<[Enterprise], ErrorResponse>) in
            switch result {
            case .success(let enterprises):
                self.enterprises = enterprises
                let plural = enterprises.count > 1 || enterprises.count == 0
                foundResultsText = "\(enterprises.count) resultado\(plural ? "s" : "") encontrado\(plural ? "s" : "")."
            case .failure(let parsedError):
                if let _errors = parsedError.errors {
//                    errors = _errors
                }
            }
            loading = false
        }
    }
}

struct EnterpriseSearch_Previews: PreviewProvider {
    static var previews: some View {
        EnterpriseSearch()
    }
}
