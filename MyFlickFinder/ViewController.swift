//
//  ViewController.swift
//  MyFlickFinder
//
//  Created by Rubal Wanchoo on 6/26/16.
//  Copyright © 2016 wanchoo. All rights reserved.
//  https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=4f6d1b92ad1230b34eff886862483510&text=gurgaon&extras=url_m&format=json&nojsoncallback=1
//  OR
//  https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=dc29c800c34e2955c179219f36bc7d83&lat=27&lon=78&extras=url_m&format=json&nojsoncallback=1

import UIKit

class ViewController: UIViewController {

    
    //MARK: View Variable Declarations
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var phraseTextSearch: UITextField!
    @IBOutlet weak var latTextSearch: UITextField!
    @IBOutlet weak var longTextSearch: UITextField!
    @IBOutlet weak var imageDescriptionLabel: UILabel!
    
    //MARK:Custom Variable Declarations
    var myFlickFinderQueue = dispatch_queue_create("myFlickFinderQueue", nil)
    
    
    
    //MARK: ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK:View Controller Actions
    
    @IBAction func phraseTextSearch(sender: AnyObject) {
        
        if let searchText=self.phraseTextSearch.text where searchText.characters.count>0{
            
            dispatch_async(myFlickFinderQueue) {
                self.searchImage([Constants.FlickrParameterKeys.Text:searchText])
            }
        }else{
            print("Text Field is nil")
        }
        
       
    }
    
    @IBAction func geoSearch(sender: AnyObject) {
        
        if let searchText1=self.latTextSearch.text,
            let searchText2 = self.longTextSearch.text
                where (searchText1.characters.count>0 && searchText2.characters.count>0){
            
            dispatch_async(myFlickFinderQueue) {
                self.searchImage([Constants.FlickrParameterKeys.Latitude:searchText1,Constants.FlickrParameterKeys.Longitude:searchText2])
            }
        }else{
            print("One of Latitude/Longitude text field is nil")
        }

    }
    
    
    //MARK:Custom Methods
    
    func searchImage(let paramDictionary:[String:AnyObject])-> Void{
        
        //Get URL
        let myURL = buildURL(paramDictionary) as NSURL
        
        //Make URL request
        let myURLRequest = NSURLRequest(URL: myURL)
        
        //Make Data Task
        let myTask = NSURLSession.sharedSession().dataTaskWithRequest(myURLRequest) { (data, response, error) in
            
            if(error == nil){
                
                var parsedResults:AnyObject!
                
                if let data=data{
                    
                    do{
                        
                        parsedResults = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                        //print("API Response " + parsedResults.description)
                        
                        
                    }catch{
                        print("Could not parse JSON")
                    }
                    
                    
                }else{
                    print("No Data in response")
                }
                
                
                if let photosDict=parsedResults[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject],
                    let totalPhotos = photosDict[Constants.FlickrResponseKeys.Total] as? String,
                    let photoDictArray=photosDict[Constants.FlickrResponseKeys.Photo] as? [[String:AnyObject]] where totalPhotos != "0"{
                    
                    let randomIndex=Int(arc4random_uniform(UInt32(photoDictArray.count)))
                    
                    let randomSelectedPhoto=photoDictArray[randomIndex]
                    
                    let imgURL = NSURL(string: randomSelectedPhoto[Constants.FlickrResponseKeys.MediumURL] as! String)
                    
                    let imgData=NSData(contentsOfURL: imgURL!)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.myImageView.image=UIImage(data: imgData!)
                        self.imageDescriptionLabel.text=randomSelectedPhoto[Constants.FlickrResponseKeys.Title] as? String
                    }
                    
                }else{
                    print("No Photos found")
                }
                
                
                
                
                
                
                
                
            }//end if
            
            
        }
        
        
        myTask.resume()
        
        
        

        
    }
    
    
    
    func buildURL(let additionalParams:[String:AnyObject])->NSURL!{
        
        let components = NSURLComponents()
        
        components.scheme = Constants.Flickr.Scheme
        components.host = Constants.Flickr.Host
        components.path = Constants.Flickr.Path
        components.queryItems = [NSURLQueryItem]()
        
        
        //Always needed query items
        components.queryItems!.append(NSURLQueryItem(name:Constants.FlickrParameterKeys.Method,value: Constants.FlickrParameterValues.Method))
        components.queryItems!.append(NSURLQueryItem(name:Constants.FlickrParameterKeys.APIKey,value: Constants.FlickrParameterValues.APIKey))
        components.queryItems!.append(NSURLQueryItem(name:Constants.FlickrParameterKeys.Extras,value: Constants.FlickrParameterValues.Extras))
        components.queryItems!.append(NSURLQueryItem(name:Constants.FlickrParameterKeys.Format,value: Constants.FlickrParameterValues.Format))
        components.queryItems!.append(NSURLQueryItem(name:Constants.FlickrParameterKeys.NoJSONCallback,value: Constants.FlickrParameterValues.NoJSONCallback))
        
        
        //Conditional Query Items
        for dictItem in additionalParams{
            components.queryItems!.append(NSURLQueryItem(name: dictItem.0,value:dictItem.1 as? String))
        }
        
        
        print("URL - " + components.URL!.description)
        
        return components.URL
    }
    
    
    
    
    
    

}

