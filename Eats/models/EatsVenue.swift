//
//  EatsVenue.swift
//  Eats
//
//  Created by Brian Correa on 5/15/16.
//  Copyright © 2016 milkshake-systems. All rights reserved.
//

import UIKit

class EatsVenue: NSObject {

    var name: String!
    var address = ""
    var rating: Double!
    var phone = ""
    var lng: Double!
    var lat: Double!
    
    //MARK: - Parsing Function
    
    func populate(info: Dictionary<String, AnyObject>){
        if let n = info["name"] as? String {
            self.name = n
        }
        
        if let a = info["vicinity"] as? String {
            self.address = a
        }
        
        if let location = info["location"] as? Dictionary<String, AnyObject> {
            //            print("LOCATION: \(location)")
            
            if let addr = location["address"] as? String {
                self.address = addr
            }
            if let lng = location["lng"] as? Double {
                self.lng = lng
            }
            if let lat = location["lat"] as? Double {
                self.lat = lat
            }
        }
        
        if let contact = info["contact"] as? Dictionary<String, AnyObject> {
            //            print("CONTACT: \(contact)")
            if let formattedPhone = contact["formattedPhone"] as? String {
                //                print("PHONE: \(phone)")
                self.phone = formattedPhone
            }
        }
        
        if let r = info["rating"] as? Double {
            self.rating = r
        }
        
    }
    
}