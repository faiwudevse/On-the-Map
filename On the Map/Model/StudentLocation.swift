//
//  StudentInformation.swift
//  On the Map
//
//  Created by Fai Wu on 11/2/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//



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
            uniqueKey =  uniqueKeyVal as! String
        }else{
            return nil
        }
        
        if let firstNameVal = dictionary[Client.JSONBodyKeys.FirstName] {
            firstName =  firstNameVal as! String
        }else{
            return nil
        }
        
        if let lastNameVal = dictionary[Client.JSONBodyKeys.LastName]{
            lastName = lastNameVal as! String
        }else{
            return nil
        }
        
        if let mapStringVal = dictionary[Client.JSONBodyKeys.MapString] {
            mapString = mapStringVal as! String
        } else{
            return nil
        }
        
        if let latitudeVal = dictionary[Client.JSONBodyKeys.Latitude] {
            latitude = latitudeVal as! Double
        }else{
            return nil
        }
        
        if let longitudeVal = dictionary[Client.JSONBodyKeys.Longitude]{
            longitude = longitudeVal as! Double
        }else{
            return nil
        }
        
        if let mediaURLVal = dictionary[Client.JSONBodyKeys.MediaURL] {
            mediaURL = mediaURLVal as! String
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
