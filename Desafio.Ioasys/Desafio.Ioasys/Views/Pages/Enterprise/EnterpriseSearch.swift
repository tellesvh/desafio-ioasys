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
    @State var errors: [String] = []
    
    var body: some View {
        NavigationView {
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
                    errors = _errors
                }
            }
            loading = false
        }
    }
}

struct EnterpriseRow: View {
    @ObservedObject var imageLoader: ImageLoader
    var enterprise: Enterprise?
    @State var image: UIImage = UIImage()
    
    init(enterprise: Enterprise) {
        self.enterprise = enterprise
        if let url = enterprise.photo {
            let finalUrl = "\(DEV_HOST)\(url)"
            imageLoader = ImageLoader(urlString: finalUrl)
        } else {
            imageLoader = ImageLoader(urlString: "https://via.placeholder.com/600x300png")
        }
    }
    
    var body: some View {
        if let name = enterprise?.enterpriseName {
            ZStack(alignment: .bottomTrailing) {
//                Image("background")
                Image(uiImage: image)
                    .resizable()
                    .frame(maxHeight: 150)
                    .aspectRatio(1 , contentMode: .fill)
                    .onReceive(imageLoader.didChange) { data in
                        self.image = UIImage(data: data) ?? UIImage()
                    }
                Text(name)
                    .font(Font.custom("Rubik", size: 14))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.75))
                    .cornerRadius(radius: 12, corners: [.topLeft])
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

var e: Enterprise = Enterprise(enterpriseName: "Telles", photo: "/uploads/enterprise/photo/1/240.jpeg")

struct EnterpriseRow_Previews: PreviewProvider {
    static var previews: some View {
        EnterpriseRow(enterprise: e)
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/150.0/*@END_MENU_TOKEN@*/))
    }
}



struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
