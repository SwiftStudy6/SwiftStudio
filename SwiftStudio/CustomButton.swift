//
//  CustomButton.swift
//  SwiftStudio
//
//  Created by David June Kang on 2016. 12. 30..
//  Copyright © 2016년 ven2s.soft. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
extension CustomButton {
    // MARK: - UIButton+Aligment
    
    //image top / label buttom
    func alignContentVerticallyByCenter(offset:CGFloat = 10) {
        let buttonSize = frame.size
        
        let windowWidth = UIScreen.main.bounds.width
        
        if let titleLabel = titleLabel,
            let imageView = imageView {
            
            if let buttonTitle = titleLabel.text,
                let image = imageView.image {
                let titleString:NSString = NSString(string: buttonTitle)
                let titleSize = titleString.size(attributes: [NSFontAttributeName : titleLabel.font])
                let buttonImageSize = image.size
                
                
                let topImageOffset = (buttonSize.height - (titleSize.height + buttonImageSize.height + offset)) / 2 - 3
                var leftImageOffset = (buttonSize.width - buttonImageSize.width) / 2
                
                if windowWidth <= 320 {
                    leftImageOffset = leftImageOffset - 5.5;
                }
                
                
                imageEdgeInsets = UIEdgeInsetsMake(topImageOffset,leftImageOffset,0,0)
                
                let titleTopOffset = topImageOffset + offset + buttonImageSize.height
                var leftTitleOffset = (buttonSize.width - titleSize.width) / 2 - (image.size.width)
                
                if windowWidth <= 320 {
                    leftTitleOffset = leftTitleOffset - 5.5;
                }
              
                titleEdgeInsets = UIEdgeInsetsMake(titleTopOffset, leftTitleOffset, 0, 0)
                
            }
        }
    }
    
    //resizing Image
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
   
}
