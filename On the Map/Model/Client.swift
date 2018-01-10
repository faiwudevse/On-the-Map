//
//  Client.swift
//  On the Map
//
//  Created by Fai Wu on 10/27/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import Foundation

class Client : NSObject {
    
    // MARK: Properties
    var session = URLSession.shared
    var userID: String? = nil
    var objectID: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var studentLocationsData : [StudentLocation] = []
    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    func taskForGetMethod(_ domain: String, _ method: String, _ parameters: [String:AnyObject], _ jsonHead: [String:AnyObject], _ completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        let request = NSMutableURLRequest(url: urlFromParameters(domain, parameters, method))
        for(key, value) in jsonHead{
            request.addValue(value as! String , forHTTPHeaderField: key)
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(domain, data, completionHandlerForGET)
        }
        
        task.resume()
        return task
    }
    
    func taskForPutMethod(_ domain: String, _ method: String, _ parameters: [String:AnyObject], _ withPathExtension: String, _ jsonBody:String, _ jsonHead: [String:AnyObject], _ completeionHandlerForPut: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionTask {
        let request = NSMutableURLRequest(url: urlFromParameters(domain, parameters, method))
        request.httpMethod = "PUT"
        for(key, value) in jsonHead{
            request.addValue(value as! String , forHTTPHeaderField: key)
        }
        
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        /*  Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completeionHandlerForPut(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(domain, data, completeionHandlerForPut)
            
        }
        task.resume()
        return task
    }

    
    
    func taskForPostMethod(_ domain: String, _ method: String, _ parameters: [String:AnyObject], _ jsonBody:String, _ jsonHead: [String:AnyObject], _ completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        
        let request = NSMutableURLRequest(url: urlFromParameters(domain, parameters, method))

        request.httpMethod = "POST"
        for (key ,value) in jsonHead{
            request.addValue(value as! String , forHTTPHeaderField: key)
        }
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
            
        /*  Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
                
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                    completionHandlerForPOST(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
                
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
                
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
                
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
                
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(domain, data, completionHandlerForPOST)
            }
            
        /* 7. Start the request */
        task.resume()
            
            return task
            
    }
    
    func taskForDeleteMethod(_ domain: String, _ method:String, _ parameters: [String:AnyObject], _ completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
        let request = NSMutableURLRequest(url: urlFromParameters(domain,parameters,method))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        /*  Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(domain, data, completionHandlerForDELETE)
        }
        task.resume()
        return task
    }
    
    
    private func jsonBodyJoinedParameters(_ parameters: [String:AnyObject]) -> String {
        
        if parameters.isEmpty {
            return ""
        } else {
            var keyValuePairs = [String]()
            
            for (key, value) in parameters {
                
                // make sure that it is a string value
                let stringValuePair = "\"\(key)\": \"\(value)\""
                
                // append it
                keyValuePairs.append(stringValuePair)
                
            }
            
            return "{\(keyValuePairs.joined(separator: ","))}"
        }
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ domain: String, _ data: Data, _ completionHandlerForConvertData: (_  result: AnyObject?, _ error: NSError?) -> Void) {
        var newData = data
        
        if domain == Constants.UdacityDomain {
            let range = Range(5..<data.count)
            newData = data.subdata(in: range)
        }
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    
        completionHandlerForConvertData(parsedResult, nil)
    }
    private func urlFromParameters(_ domain: String, _ parameters: [String:AnyObject], _ withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        
        if domain == Constants.UdacityDomain {
            components.scheme = Constants.ApiScheme
            components.host = Constants.UdacityHost
            components.path = (withPathExtension ?? "")
        }
        else if domain == Constants.ParseDomain {
            components.scheme = Constants.ApiScheme 
            components.host = Constants.ParseHost
            components.path = (withPathExtension ?? "")
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }

        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> Client {
        struct Singleton {
            static var sharedInstance = Client()
        }
        return Singleton.sharedInstance
    }
}
