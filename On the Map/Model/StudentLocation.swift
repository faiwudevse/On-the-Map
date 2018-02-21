//
//  StudentInformation.swift
//  On the Map
//
//  Created by Fai Wu on 11/2/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import Foundation

struct StudentLocation {
    
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
// initilize studentsInfo property
    init?(_ dictionary: [String:AnyObject]) {
        if let uniqueKeyVal = dictionary[Client.JSONBodyKeys.UniqueKey] {
            if !(uniqueKeyVal is NSNull) {
                uniqueKey =  uniqueKeyVal as! String
            }
            else{
                return nil
            }
        }else{
            return nil
        }
        
        if let firstNameVal = dictionary[Client.JSONBodyKeys.FirstName] {
            if !(firstNameVal is NSNull) {
                firstName =  firstNameVal as! String
            }
            else {
                return nil
            }
        }else{
            return nil
        }
        
        if let lastNameVal = dictionary[Client.JSONBodyKeys.LastName]{
            if !(lastNameVal is NSNull) {
                lastName = lastNameVal as! String
            }
            else{
                return nil
            }
        }else{
            return nil
        }
        
        if let mapStringVal = dictionary[Client.JSONBodyKeys.MapString] {
            if !(mapStringVal is NSNull) {
                mapString = mapStringVal as! String
            }
            else{
                return nil
            }
        } else{
            return nil
        }
        
        if let latitudeVal = dictionary[Client.JSONBodyKeys.Latitude] {
            if !(latitudeVal is NSNull) {
                latitude = latitudeVal as! Double
            }
            else{
                return nil
            }
        }else{
            return nil
        }
        
        if let longitudeVal = dictionary[Client.JSONBodyKeys.Longitude]{
            if !(longitudeVal is NSNull) {
                longitude = longitudeVal as! Double
            }
            else{
                return nil
            }
        }else{
            return nil
        }
        
        if let mediaURLVal = dictionary[Client.JSONBodyKeys.MediaURL] {
            if !(mediaURLVal is NSNull) {
                mediaURL = mediaURLVal as! String
            }
            else{
                return nil
            }
        }else {
             return nil
        }
        
        
        
    }
    
    static func studentsInformationFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        var studentLocationsData : [StudentLocation] = []
        for result in results {
            let studentLocation = StudentLocation(result)
            if studentLocation != nil {
                studentLocationsData.append(studentLocation!)
            }
        }
        return studentLocationsData
    }
    
    
    
}
