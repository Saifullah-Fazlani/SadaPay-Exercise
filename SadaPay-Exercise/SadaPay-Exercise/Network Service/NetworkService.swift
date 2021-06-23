//
//  NetworkService.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 19/06/2021.
//

import Foundation
import Alamofire

class NetworkService {
    
    // Make initializer private and a sharedInstance to ensure Singleton design pattern
    static var sharedInstance = NetworkService()
    private init() {}
    
    func performRequest(route: URL, params: Parameters?, method: HTTPMethod, completionHandler: @escaping (_ responseData: Data?, _ errorMessage: String?, _ statusCode: Int?) -> Void) {
        
        // Check either network is reachable
        if NetworkReachabilityManager()!.isReachable {
            
            AF.request(route, method: method, parameters: params).responseJSON { response in
                switch response.result {
                
                // API was reachable and returned data
                case .success:
                    print(response as Any)
                    guard let responseData = response.data else {
                        completionHandler(nil, response.error?.errorDescription, nil)
                        return
                    }
                    // Pass response data and status code for success
                    completionHandler(responseData, nil, response.response?.statusCode)
                    
                // API was unreachable and couldn't return data
                case .failure:
                    print(response as Any)
                    // Pass error message for failure
                    completionHandler(nil, response.error.debugDescription, nil)
                }
            }
        }
        
        else {
            // Pass error message if network is unreachable
            completionHandler(nil, Strings.networkUnreachable, nil)
        }
        
    }
    
    func getRepositoryList(_ callback: @escaping((_ response: Repository?, _ error: String?) -> Void)) {
        
        let route = URL(string: URLConstant.baseURL.rawValue + URLConstant.repositoryList.rawValue)!
        
        self.performRequest(route: route, params: nil, method: .get) { (response, errorMessage, statusCode) in
            
            // Check either response is not null and error message is null
            guard let responseData = response, errorMessage == nil else {
                print(errorMessage as Any)
                
                // Pass error message if either's the case
                callback(nil, errorMessage)
                return
            }
            
            guard statusCode == 200 else {
                print(Strings.invalidResponse)
                
                // Pass error message if statusCode is not 200, indicating response was not as expected or erroneous
                callback(nil, Strings.signalBlocked)
                return
            }
            
            do {
                // Decode data using pre-defined model for Repository
                let repositoryModel = try JSONDecoder().decode(Repository.self, from: responseData)
                
                // Pass decoded data
                callback(repositoryModel, nil)
            }
            catch {
                print(Strings.unableToDecode)
                
                // Pass error message if there was any error while deocoding the data
                callback(nil, Strings.signalBlocked)
            }
            
        }
    }
}
