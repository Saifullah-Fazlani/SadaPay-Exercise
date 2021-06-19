//
//  NetworkService.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 19/06/2021.
//

import Foundation
import Alamofire

class NetworkService {
    
    static var sharedInstance = NetworkService()
    
    private init() {}
    
    func performRequest(route: URL, params: Parameters?, method: HTTPMethod, completionHandler: @escaping (_ responseData: Data?, _ errorMessage: String?, _ statusCode: Int?) -> Void) {
        
        if NetworkReachabilityManager()!.isReachable {
            
            AF.request(route, method: method, parameters: params).responseJSON { response in
                
                switch response.result {
                
                case .success:
                    guard let responseData = response.data else {return}
                    completionHandler(responseData, nil, response.response?.statusCode)
                    
                case .failure:
                    completionHandler(nil, response.error.debugDescription, nil)
                    
                }
            }
        }
        
        else {
            completionHandler(nil, Strings.networkUnreachable, nil)
        }
        
    }
    
    func getRepositoryList(_ callback: @escaping((_ response: Repository?, _ error: String?) -> Void)) {
        
        let route = URL(string: URLConstant.baseURL.rawValue + URLConstant.repositoryList.rawValue)!
        
        self.performRequest(route: route, params: nil, method: .get) { (response, errorMessage, statusCode) in
            
            guard let responseData = response, errorMessage == nil else {
                callback(nil, errorMessage)
                return
            }
            
            guard statusCode == 200 else {
                callback(nil, Strings.invalidResponse)
                return
            }
            
            do {
                let repositoryModel = try JSONDecoder().decode(Repository.self, from: responseData)
                callback(repositoryModel, nil)
            }
            catch {
                callback(nil, Strings.unableToDecode)
            }
            
        }
    }
}
