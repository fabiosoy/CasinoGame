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

    private var afterToken : String?
    
    //MARK: - Feed Manager Methods
    
    func resetTokens() {
        afterToken = nil
    }
    
    func getDataFromServer( completionHandler : ((NSError?, [AnyObject])->())? ) {
        var finalUrlString = Config.url.stringByAppendingFormat("&limit=%d",Config.limitPerPage)
        if let afterToken = self.afterToken {
            finalUrlString = finalUrlString.stringByAppendingFormat("&after=%@",afterToken)
        }
        if let urlRequest = NSURL(string: finalUrlString){
            let session = NSURLSession.sharedSession()
            session.dataTaskWithURL(urlRequest) { [weak self] (data : NSData?, response : NSURLResponse?, error : NSError?) in
                var resultArray = [AnyObject]()
                if error == nil {
                    if let data = data {
                        do {
                            let JsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                            if let dictFromJSON = JsonDict as? [String:AnyObject]
                            {
                                if let array = self?.parseData(dictFromJSON) {
                                    resultArray.appendContentsOf(array)
                                }
                                
                            }
                        } catch let error as NSError {
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
    
    func gerImageFromServer(url : String?, completionHandler : (NSData?)->() ) {
        guard let url = url else {
            return
        }
        if let urlRequest = NSURL(string: url){
            let session = NSURLSession.sharedSession()
            session.dataTaskWithURL(urlRequest, completionHandler: { (data : NSData?, response : NSURLResponse?, error : NSError?) in
                completionHandler(data)
            }).resume()
        }
    }
    
    func parseData(json : Dictionary<String,AnyObject>) -> Array<AnyObject> {
        var array = Array<AnyObject>()
        if let data = json["data"] as? NSDictionary {
            if let after = data["after"] as? String { self.afterToken = after }
            if let children = data["children"] as? NSArray {
                for itemData in children {
                    if let item = itemData["data"] as? NSDictionary {
                        array.append(item)
                    }
                }
            }
        }
        return array
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
