//
//  ConnectionManager.swift
//  Test
//
//  Created by Fabio Bermudez on 29/08/16.
//  Copyright © 2016 Fabio Bermudez. All rights reserved.
//

import UIKit
import SystemConfiguration

class ConnectionManager: NSObject {
    
    static let sharedInstance = ConnectionManager()

    //MARK: - Private Properties

    fileprivate var afterToken : String?
    
    //MARK: - Feed Manager Methods
    
    func resetTokens() {
        afterToken = nil
    }
    
    func getDataFromServer( _ completionHandler : ((Error?, [Any])->())? ) {
        var finalUrlString = Config.url.appendingFormat("&limit=%d",Config.limitPerPage)
        if let afterToken = self.afterToken {
            finalUrlString = finalUrlString.appendingFormat("&after=%@",afterToken)
        }
        if let request = URL(string: finalUrlString){
            URLSession.shared.dataTask(with: request) {[weak self]
                data, response, error in
                var resultArray = [Any]()
                if error == nil {
                    if let data = data {
                        do {
                            let JsonDict = try JSONSerialization.jsonObject(with: data, options: [])
                            if let dictFromJSON = JsonDict as? [String:AnyObject]
                            {
                                if let array = self?.parseData(dictFromJSON) {
                                    resultArray.append(contentsOf: array)
                                }
                                
                            }
                        } catch  {
                            print(error)
                        }
                    }
                }
                if let completionHandler = completionHandler {
                    completionHandler(error,resultArray)
                }
                
                
                }.resume()
        }
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = URL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    func gerImageFromServer(_ url : String?, completionHandler : @escaping (Data?)->() ) {
        guard let url = url,let request = URL(string: url), self.verifyUrl(urlString: url) else {
            completionHandler(nil)
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            completionHandler(data)
            }.resume()
    }
    
    func parseData(_ json : Dictionary<String,AnyObject>) -> Array<Any> {
        var array = Array<Any>()
        if let data = json["data"] as? Dictionary<String,AnyObject> {
            if let after = data["after"] as? String { self.afterToken = after }
            if let children = data["children"] as? Array<Dictionary<String,AnyObject>> {
                for itemData in children {
                    if let item = itemData["data"] as? Dictionary<String,AnyObject> {
                        array.append(item)
                    }
                }
            }
        }
        return array
    }

    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
