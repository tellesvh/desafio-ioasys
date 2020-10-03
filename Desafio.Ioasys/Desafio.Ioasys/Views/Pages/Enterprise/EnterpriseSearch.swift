//
//  EnterpriseSearch.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 02/10/20.
//

import SwiftUI
import URLImage

struct EnterpriseSearch: View {
    @ObservedObject var enterpriseSearchController = EnterpriseSearchController()
    @State var loading: Bool = false
    @State var searchQuery: String = ""
    @State var hasSearched: Bool = false
    @State var enterprises: [Enterprise] = []
    @State var foundResultsText: String = ""
    @State var errors: [String] = []
    
    var body: some View {
        ProgressViewOverlay(isLoading: $loading) {
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
                            if (errors.count == 0) {
                                Text(foundResultsText)
                                    .foregroundColor(Color("Gray 3"))
                                    .font(Font.custom("Rubik", size: 12))
                                    .fontWeight(.light)
                                
                                VStack(spacing: 16) {
                                    ForEach(enterprises.indices, id: \.self) { index in
                                        EnterpriseRow(enterprise: self.enterprises[index])
                                    }
                                }
                                .padding(.top, 12)
                            } else {
                                ForEach(errors, id: \.self) { error in
                                    Text(error)
                                        .foregroundColor(Color("Error"))
                                        .font(Font.custom("Rubik", size: 12))
                                        .fontWeight(.regular)
                                }
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
                    errors = _errors
                }
            }
            loading = false
        }
    }
}

struct EnterpriseRow: View {
    var enterprise: Enterprise
    private var imageUrl: URL
    
    init(enterprise: Enterprise) {
        self.enterprise = enterprise
        if let _imageUrl = enterprise.photo {
            imageUrl = URL(DEV_HOST + _imageUrl)
        } else {
            imageUrl = URL("https://via.placeholder.com/600x300png")
        }
    }
    
    var body: some View {
        NavigationLink(destination: EnterpriseDetail(enterprise: enterprise)) {
            ZStack(alignment: .bottomTrailing) {
                URLImage(imageUrl,
                         placeholder: {
                            ProgressView($0) { progress in
                                ZStack {
                                    if progress > 0.0 {
                                        CircleProgressView(progress)
                                            .stroke(lineWidth: 8.0)
                                            .frame(height: 50)
                                            .foregroundColor(Color("Pink 1"))
                                    }
                                    else {
                                        CircleActivityView()
                                            .stroke(lineWidth: 50.0)
                                            .frame(height: 50)
                                            .foregroundColor(Color("Pink 1"))
                                    }
                                }
                            }
                            .frame(height: 150)
                         }
                        ) { proxy in
                            proxy.image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                          }
                    .frame(height: 150)
                
                if let name = enterprise.enterpriseName {
                    Text(name)
                        .font(Font.custom("Rubik", size: 14))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .cornerRadius(radius: 12, corners: [.topLeft])
                }
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}


struct EnterpriseSearch_Previews: PreviewProvider {
    static var previews: some View {
        EnterpriseSearch()
    }
}

struct EnterpriseRow_Previews: PreviewProvider {
    static var previews: some View {
        EnterpriseRow(enterprise: e)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/150.0/*@END_MENU_TOKEN@*/))
    }
}

var e: Enterprise = Enterprise(enterpriseName: "Telles", photo: "/uploads/enterprise/photo/1/240.jpeg", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut leo metus, finibus sit amet elit vel, bibendum cursus ligula. Phasellus fringilla tincidunt libero eget imperdiet. Praesent a risus quam. Nulla consequat tellus id malesuada vehicula. Donec consectetur ligula ligula, quis scelerisque ligula ornare at. Ut nec turpis feugiat nisi rhoncus varius. Morbi luctus interdum dolor, ut laoreet risus tincidunt bibendum. Donec in justo ut neque feugiat rutrum non tempor tortor. Nullam lacinia metus feugiat ligula placerat, in commodo arcu laoreet. Phasellus ut rutrum turpis, quis pretium nisl. Nam semper risus vel odio porttitor pharetra. Vivamus ornare quam in elit facilisis, quis lacinia urna condimentum. Fusce in est tellus. Nunc convallis scelerisque lobortis.\n\nSuspendisse eu libero nec orci iaculis laoreet. Fusce dictum non elit sed porta. Nullam placerat nunc eu dignissim sagittis. Mauris tempus orci ac purus auctor feugiat. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nullam ultrices justo ut ante consectetur, et condimentum elit efficitur. Maecenas dui risus, varius eget magna vitae, semper vulputate velit. Etiam et mauris finibus, euismod turpis nec, porta quam.\n\nAenean auctor felis hendrerit ex feugiat, ut ullamcorper urna egestas. Sed ac ex sit amet odio dapibus tempor sed eget sapien. Cras eget consequat leo, a hendrerit sapien. Phasellus congue, odio nec fringilla aliquet, elit nisi ullamcorper ex, vel egestas neque purus ac dui. Donec dignissim magna id dui lobortis tempus. Mauris pharetra urna mi, sed euismod massa lobortis et. Vivamus at maximus augue. Etiam pellentesque leo id lorem ultrices ultrices. Etiam tempor laoreet fringilla. Morbi sed hendrerit nisi, ac facilisis purus. Nulla vel libero nec urna ullamcorper dapibus. Sed auctor varius eros sed malesuada. Vivamus purus urna, convallis sed velit eu, auctor ultricies turpis. Donec quis varius magna.\n\nPraesent blandit ultrices nibh, eget iaculis velit finibus vel. Mauris ligula neque, posuere et mauris non, feugiat condimentum turpis. Donec et vulputate lectus, nec tempor erat. Mauris dapibus libero tortor, quis bibendum tortor facilisis non. Nullam malesuada rutrum metus non posuere. Pellentesque massa metus, elementum in condimentum sit amet, convallis tempor leo. Nullam ultrices elementum neque, ac congue lectus rutrum in. Sed vel orci maximus, interdum justo auctor, posuere lacus. Maecenas ut purus nec augue placerat viverra. Suspendisse malesuada nunc est, vel auctor arcu molestie suscipit. Quisque bibendum egestas ipsum, sagittis molestie lorem pretium sit amet. In hac habitasse platea dictumst. Suspendisse justo elit, faucibus eu vestibulum nec, gravida id massa.")
