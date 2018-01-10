//
//  Constants.swift
//  On the Map
//
//  Created by Fai Wu on 10/28/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

extension Client{
    
    struct Constants {
        // MARK: URLs
        static let ApiScheme = "https"
        static let UdacityHost = "www.udacity.com"
        static let ParseHost = "parse.udacity.com"
        static let ParseAPIRestKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let UdacityDomain = "udacity"
        static let ParseDomain = "parse"
    }
    
    struct URLKeys {
        static let UserID = "id"
    }
    
    struct ParameterKeys{
        static let Limit = "limit"
        static let Order = "order"
        static let Skip = "skip"
        static let Where = "where"
    }
    
    struct ParameterValues {
        static let UpdateAt = "-updatedAt"
    }
    
    struct Methods {
        static let UdacitySession = "/api/session"
        static let UdacityUserInfo = "/api/users/"
        static let ParseLocation = "/parse/classes/StudentLocation"
    }
    
    struct JSONResponseKeys{
        static let Account = "account"
        static let AccountKey = "key"
        static let Results = "results"
        static let User = "user"
        static let FirstName = "first_name"
        static let LastName = "last_name"
    }
    
    struct JSONBodyKeys{
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    struct HTTPHeaderField{
        static let ParseApplicationID = "X-Parse-Application-Id"
        static let ParseAPIRestKey = "X-Parse-REST-API-Key"
        static let Token = "X-XSRF-TOKEN"
        static let JsonApplication = "application/json"
    }
    struct HTTPHeaderFieldValue {
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
        static let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        }
}
