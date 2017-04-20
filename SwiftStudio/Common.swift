//
//  Common.swift
//  SwiftStudio
//

import UIKit

class Common: NSObject {
    
   /*!
     @discussion 디자인가이드에 의한 디폴트 색상을 가져온다
     @discussion 단, UserDefault에 의한 themeColor가 따로 설정된 경우 에는 변경된다
     @return Int
    */
   let defaultColor: UIColor = {
        var color = UIColor(netHex: 0x00B9E6)
        
        if let setColor = UserDefaults.standard.value(forKey: "themaColor") as? Int {
            color = UIColor(netHex: setColor)
        }
        
        
        return color
    }()
    
    /*!
        @discussion 디자인 가이드에 의한 상위 스테이터스바의 색상
     */
    let defaultStatusColor : UIColor = {
        let color = UIColor(netHex: 0x000000, alpha: 0.2)

        return color
    }()
    
    /*!
     @discusson Navigationbar Default Size (44pt)
     @discusson 단, 반드시 status bar size( 20pt)를 별로로 더해줄것
    */
    let sizeOfNaviBar = 44
}
