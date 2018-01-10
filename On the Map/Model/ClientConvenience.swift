//
//  ClientConvenience.swift
//  On the Map
//
//  Created by Fai Wu on 10/28/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import Foundation

extension Client{
    func authenticateUserLogin(_ userName: String, _ password: String, _ completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        let parameters = [String:AnyObject]()
        let jsonBody = "{\"\(JSONBodyKeys.Udacity)\": {\"\(JSONBodyKeys.Username)\": \"\(userName)\", \"\(JSONBodyKeys.Password)\": \"\(password)\"}}"
        let jsonHeader = [HTTPHeaderFieldValue.Accept : HTTPHeaderField.JsonApplication, HTTPHeaderFieldValue.ContentType : HTTPHeaderField.JsonApplication]
        
        let _ = taskForPostMethod(Constants.UdacityDomain, Methods.UdacitySession, parameters, jsonBody, jsonHeader as [String:AnyObject]){ (results, error) in
            if let error = error {
                completionHandlerForAuth(false, error.localizedDescription)
            }else {
                completionHandlerForAuth(true, nil)
                guard let account = results![JSONResponseKeys.Account] as? NSDictionary else {
                    self.errorCanNotbeFoundMessage(JSONResponseKeys.Account, results!)
                    return
                }
                if let accountKey = account[JSONResponseKeys.AccountKey] as? String {
                    self.userID = accountKey
                    self.getUserInfo(self.userID!){(firstName, lastName, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else{
                            self.firstName = firstName
                            self.lastName = lastName
                        }
                    }
                    
                }else{
                    self.errorCanNotbeFoundMessage(JSONResponseKeys.AccountKey, account)
                }
            }
        }
    }
    
    func userLogout(_ completionHandlerForLogOut: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        let parameters = [String:AnyObject]()
        let _ = taskForDeleteMethod(Constants.UdacityDomain,Methods.UdacitySession, parameters) { (result, error) in
            if let error = error {
                completionHandlerForLogOut(false, error.localizedDescription)
            }else {
                completionHandlerForLogOut(true, nil)
            }
        }
    }
    
    func getRecentStudentLocations(_ completionHandlerForRecentStudentLocations: @escaping ( _ results: [StudentLocation]?, _ error: NSError?) -> Void ){
        let parameters = [ParameterKeys.Order : ParameterValues.UpdateAt, ParameterKeys.Limit : "100"]
        let jsonHeader = [HTTPHeaderField.ParseApplicationID : HTTPHeaderFieldValue.ParseApplicationID, HTTPHeaderField.ParseAPIRestKey :HTTPHeaderFieldValue.RestAPIKey]
        let _ = taskForGetMethod(Constants.ParseDomain, Methods.ParseLocation, parameters as [String:AnyObject], jsonHeader as [String: AnyObject]){ (results, error) in
            if let error = error {
                completionHandlerForRecentStudentLocations(nil, error)
            }else{
                if let results = results![JSONResponseKeys.Results] as? [[String:AnyObject]] {
                    let studentsDataInfo = StudentLocation.studentsInformationFromResults(results)

                    self.studentLocationsData.removeAll()
                    self.studentLocationsData = studentsDataInfo
                    completionHandlerForRecentStudentLocations(studentsDataInfo,nil)
                }
                else{
                    self.errorCanNotbeFoundMessage(JSONResponseKeys.Results, results!)
                    completionHandlerForRecentStudentLocations(nil, NSError(domain: "getRecentStudentsInfo", code: 0, userInfo: [NSLocalizedDescriptionKey : ""]))
                }
            }
        }
    }
    func getUserInfo(_ userID: String, _ completionHandlerForUserInfo: @escaping(_ firstName: String?, _ lastName: String?,_ error: NSError?) -> Void){
        let parameters = [String:AnyObject]()
        let jsonHead = [String:AnyObject]()
        let _ = taskForGetMethod(Constants.UdacityDomain, Methods.UdacityUserInfo + userID, parameters as [String:AnyObject], jsonHead as [String:AnyObject]){ (result, error) in
            if let error = error {
                completionHandlerForUserInfo(nil, nil, error)
            }else {
                guard let userInfo = result![JSONResponseKeys.User] as? NSDictionary else {
                    self.errorCanNotbeFoundMessage(JSONResponseKeys.User, result!)
                    completionHandlerForUserInfo(nil, nil, error)
                    return
                }
                
                guard let firstName = userInfo[JSONResponseKeys.FirstName] as? String else {
                    self.errorCanNotbeFoundMessage(JSONResponseKeys.User, result!)
                    completionHandlerForUserInfo(nil, nil, error)
                    return
                }
                
                guard let lastName = userInfo[JSONResponseKeys.LastName] as? String else {
                    self.errorCanNotbeFoundMessage(JSONResponseKeys.User, result!)
                    completionHandlerForUserInfo(nil, nil, error)
                    return
                }
                completionHandlerForUserInfo(firstName, lastName, nil)
            }
        }
    }
    func postAStudentLocation(_ mapString: String, _ mediaUrl: String, _ latitude: Double, _ longitude: Double, _ completionHanderlForPostAStudentLocation: @escaping(_ success: Bool, _ errorString: String?) -> Void){
        let parameters = [String:AnyObject]()
        let jsonHeader = [HTTPHeaderField.ParseApplicationID : HTTPHeaderFieldValue.ParseApplicationID, HTTPHeaderField.ParseAPIRestKey :HTTPHeaderFieldValue.RestAPIKey, HTTPHeaderFieldValue.ContentType : HTTPHeaderField.JsonApplication]
        let jsonBody = "{\"\(JSONBodyKeys.UniqueKey)\": \"\(self.userID!)\", \"\(JSONBodyKeys.FirstName)\": \"\(self.firstName!)\", \"\(JSONBodyKeys.LastName)\": \"\(self.lastName!)\", \"\(JSONBodyKeys.MapString)\": \"\(mapString)\", \"\(JSONBodyKeys.MediaURL)\": \"\(mediaUrl)\", \"\(JSONBodyKeys.Latitude)\": \(latitude) , \"\(JSONBodyKeys.Longitude)\": \(longitude)}"
        let _ = taskForPostMethod(Constants.ParseDomain, Methods.ParseLocation, parameters as [String:AnyObject], jsonBody, jsonHeader as [String:AnyObject]){ (result, error) in
            if let error = error {
                completionHanderlForPostAStudentLocation(false,error.localizedDescription)
            }
            else{
                if let error = error {
                    completionHanderlForPostAStudentLocation(false,error.localizedDescription)
                }else{
                    completionHanderlForPostAStudentLocation(true, nil)
                }
            }
            
        }
    }
    
    func updateStudentInfoData(_ jsonBody: String, _ compeletionHandlerForUpdate: @escaping(_ success:Bool , _ errorString: String?) -> Void){
        let parameters = [String:AnyObject]()
        let jsonHeader = [HTTPHeaderField.ParseApplicationID : HTTPHeaderFieldValue.ParseApplicationID, HTTPHeaderField.ParseAPIRestKey :HTTPHeaderFieldValue.RestAPIKey]
        let pathExtension = self.objectID!
        
        let _ = taskForPutMethod(Constants.ParseDomain, Methods.ParseLocation, parameters as [String:AnyObject], pathExtension, jsonBody, jsonHeader as [String: AnyObject]){ (result, error) in
            if let error = error{
                compeletionHandlerForUpdate(false,error.localizedDescription)
            }else{
                compeletionHandlerForUpdate(true,nil)
            }
        }
    }
    
    func errorCanNotbeFoundMessage(_ key:String, _ result: AnyObject) -> Void{
        print("Cannnot find \(key) in \(result)")
    }
    
}
