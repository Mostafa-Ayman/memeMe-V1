//
//  characterAttrebute.swift
//  MemeMe
//
//  Created by SAM on 11/27/18.
//  Copyright © 2018 SAM. All rights reserved.
//

import UIKit

class attribute {

let memeTextAttributes:[String: Any] = [
NSAttributedStringKey.strokeColor.rawValue: UIColor.black /* TODO: fill in appropriate UIColor */,
NSAttributedStringKey.foregroundColor.rawValue: UIColor.white/* TODO: fill in appropriate UIColor */,
NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
NSAttributedStringKey.strokeWidth.rawValue : -5/* TODO: fill in appropriate Float */
]
    
}
/*
 import UIKit
 
 let memeTextAttributes: [NSAttributedString.Key: Any] = [
 .strokeColor: UIColor.black,
 .foregroundColor: UIColor.white,
 .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
 .strokeWidth: -5.00
 ]
 */
