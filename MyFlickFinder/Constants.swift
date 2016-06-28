//
//  Constants.swift
//  MyFlickFinder
//
//  Created by Rubal Wanchoo on 6/27/16.
//  Copyright © 2016 wanchoo. All rights reserved.
//  https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=4f6d1b92ad1230b34eff886862483510&text=gurgaon&extras=url_m&format=json&nojsoncallback=1

import Foundation

struct Constants{
    
    //MARK: Flickr Struct
    struct Flickr{
        static let Scheme = "https"
        static let Host = "api.flickr.com"
        static let Path = "/services/rest"
    }
    
    
    //MARK: FlickrParameterKeys Struct
    struct FlickrParameterKeys{
        static let Method="method"
        static let APIKey="api_key"
        static let Text="text"
        static let Latitude="lat"
        static let Longitude="lon"
        static let Extras="extras"
        static let Format="format"
        static let NoJSONCallback="nojsoncallback"
    }
    
    
    //MARK: FlickrParameterValues Struct
    struct FlickrParameterValues{
        
        static let Method="flickr.photos.search"
        static let APIKey="20bc9e2f4ad91e3bbc190e0a4a0d9278"
        static let Extras="url_m"
        static let Format="json"
        static let NoJSONCallback="1"
        
    }
    
    
    //MARK: FlickrResponseKeys Struct
    struct FlickrResponseKeys{
        static let Status="stat"
        static let Photos="photos"
        static let Photo="photo"
        static let Title="title"
        static let MediumURL="url_m"
        static let Total="total"
    }
    
    //MARK: FlickrResponseValues Struct
    struct FlickrResponseValues{
        static let OKStatus="ok"
    }
    
}