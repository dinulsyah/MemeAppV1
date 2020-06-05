//
//  MemeTextAttribute.swift
//  MemeApp
//
//  Created by On The Way on 04/06/20.
//  Copyright © 2020 Dinulsyah. All rights reserved.
//

import Foundation
import UIKit

struct textAttributes{
    let strokeColor:UIColor
    let foregroundColor:UIColor
    let font:UIFont
    let strokeWidth:Float
    let paragragraphStyle:NSMutableParagraphStyle
    
    var meme: [NSAttributedString.Key: Any]{
        get{
            let Attributes : [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.strokeColor: self.strokeColor,
                NSAttributedString.Key.foregroundColor:self.foregroundColor,
                NSAttributedString.Key.font: self.font,
                NSAttributedString.Key.strokeWidth: self.strokeWidth,
                NSAttributedString.Key.paragraphStyle:self.paragragraphStyle
            ]
            return Attributes
        }
    }
}
