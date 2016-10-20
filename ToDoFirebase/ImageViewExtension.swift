//
//  ImageViewExtension.swift
//  ToDoFirebase
//
//  Created by Thiago Cortat on 15/10/16.
//  Copyright © 2016 Infnet. All rights reserved.
//

import Foundation
import UIKit

let  imageCache = NSCache<NSString,UIImage>()

extension UIImageView {
    
    func loadImageWithCache(_ urlString:String) {
        self.image = nil
        
        //Check o cache para a image primeiro
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
        }
        else {
            let url = URL(string: urlString)
            let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if error != nil {
                    return
                }
                DispatchQueue.main.async {
                    if let dowloadImage = UIImage(data: data!) {
                        imageCache.setObject(dowloadImage, forKey: urlString as NSString)
                        self.image = dowloadImage
                    }
                }
            }
            task.resume()
        }
    }
}
