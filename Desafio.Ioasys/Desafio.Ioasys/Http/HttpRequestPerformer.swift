//
//  RequestPerformer.swift
//  Desafio.Ioasys
//
//  Created by Victor Hugo Telles on 01/10/20.
//

import Alamofire

class HttpRequestPerformer : NSObject {
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var url: String = BASE_URL
    var encoding: ParameterEncoding! = JSONEncoding.default
    
    init(body: [String : Any], headers: [String : String] = [:], url: String, method: HTTPMethod = .get, isJSONRequest: Bool = true) {
        super.init()
        body.forEach{parameters.updateValue($0.value, forKey: $0.key)}
        headers.forEach({self.headers.add(name: $0.key, value: $0.value)})
        if !isJSONRequest{
            encoding = URLEncoding.default
        }
        self.url = "\(self.url)\(url)"
        self.method = method
    }
    
    func run<T, J>(completion: @escaping (Response<T, J>) -> Void) where T: Codable, J: Codable {
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData(completionHandler: {response in
            switch response.result {
                case .success(let res):
                    if let statusCode = response.response?.statusCode{
                        switch statusCode {
                        case 200...299:
                            do {
                                var headers: [String : String] = [:]
                                if let _headers = response.response?.headers {
                                    _headers.forEach({headers.updateValue($0.value, forKey: $0.name)})
                                }
                                completion(.success(try JSONDecoder().decode(T.self, from: res), headers))
                            } catch let error {
                                var parsedError: J? = nil
                                do {
                                    parsedError = try JSONDecoder().decode(J.self, from: res)
                                } catch {
                                    
                                }
                                completion(.failure(parsedError, error))
                            }
                        default:
                            var parsedError: J? = nil
                            do {
                                parsedError = try JSONDecoder().decode(J.self, from: res)
                            } catch {
                                
                            }
                            
                            let error = NSError(domain: response.debugDescription, code: statusCode, userInfo: response.response?.allHeaderFields as? [String: Any])
                            completion(.failure(parsedError, error))
                        }
                    }
                case .failure(let error):
                    completion(.failure(nil, error))
                }
        })
    }
}

enum Response<T, J> {
    case success(T, [String : String])
    case failure(J?, Error)
}
