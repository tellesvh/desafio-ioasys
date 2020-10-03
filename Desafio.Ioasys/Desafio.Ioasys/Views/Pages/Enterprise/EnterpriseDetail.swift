//
//  EnterpriseDetail.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 02/10/20.
//

import SwiftUI
import URLImage

struct EnterpriseDetail: View {
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
        ScrollView {
            VStack {
                URLImage(imageUrl,
                         placeholder: {
                            ProgressView($0) { progress in
                                ZStack {
                                    if progress > 0.0 {
                                        CircleProgressView(progress)
                                            .stroke(lineWidth: 8.0)
                                            .frame(height: 75)
                                            .foregroundColor(Color("Pink 1"))
                                    }
                                    else {
                                        CircleActivityView()
                                            .stroke(lineWidth: 50.0)
                                            .frame(height: 75)
                                            .foregroundColor(Color("Pink 1"))
                                    }
                                }
                            }
                            .frame(height: 200)
                         }
                        ) { proxy in
                            proxy.image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                          }
                    .frame(height: 200)
                
                if let description = enterprise.description {
                    Text(description)
                        .font(Font.custom("Rubik", size: 16))
                        .foregroundColor(Color("Gray 4"))
                        .padding()
                }
                
            }
        }
        .navigationBarTitle(enterprise.enterpriseName ?? "Detalhes", displayMode: .inline)
        .navigationBarColor(UIColor(named: "Pink 1"))
    }
}

struct EnterpriseDetail_Previews: PreviewProvider {
    static var previews: some View {
        EnterpriseDetail(enterprise: e)
    }
}
