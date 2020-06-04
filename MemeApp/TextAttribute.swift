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
    static let meme: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor:UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -4.5
    ]
}
