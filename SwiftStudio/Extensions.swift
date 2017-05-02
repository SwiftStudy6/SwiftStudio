//
//  Extensions.swift
//  FireBaseChat
//
//  Created by 유명식 on 2017. 2. 17..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingCacheWithUrlStirng(urlString:String){
        
        self.image = nil
        //check cache for iamge first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a nw downlaod
        
        let url = NSURL(string: urlString)
        URLSession.shared.dataTask(with: url! as URL,completionHandler:{(data,response,err)in
            if err != nil{
                print(err)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
                
                if let donwloadedImage = UIImage(data: data!){
                    
                    imageCache.setObject(donwloadedImage, forKey: urlString as AnyObject)
                    self.image = donwloadedImage
                }
                
                //cell.imageView?.image=UIImage(data:data!)
            }
           
        }).resume();
    }
}
