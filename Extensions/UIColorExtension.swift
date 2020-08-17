//
//  UIColorExtension.swift
//  Project2048
//
//  Created by hyperactive hi-tech ltd on 16/08/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

extension UIColor
{
    static func ColorForValue(value: Int) -> UIColor
    {
        switch value
        {
            case 2:
                return UIColor.init(red: 1, green: 247/255, blue: 0, alpha: 1)
            case 4:
                return UIColor.init(red: 1, green: 225/255, blue: 0, alpha: 1)
            case 8:
                return UIColor.init(red: 1, green: 145/255, blue: 0, alpha: 1)
            case 16:
                return UIColor.init(red: 1, green: 0, blue: 0, alpha: 1)
            case 32:
                return UIColor.init(red: 1, green: 0, blue: 123/255, alpha: 1)
            case 64:
                return UIColor.init(red: 1, green: 0, blue: 234/255, alpha: 1)
            case 128:
                return UIColor.init(red: 174/255, green: 0, blue: 1, alpha: 1)
            case 256:
                return UIColor.init(red: 17/255, green: 0, blue: 1, alpha: 1)
            case 512:
                return UIColor.init(red: 0, green: 1, blue: 221/255, alpha: 1)
            case 1024:
                return UIColor.init(red: 55/255, green: 1, blue: 0, alpha: 1)
            case 2048:
                return UIColor.init(red: 1, green: 215/255, blue: 0, alpha: 1)
            default:
                return UIColor.clear
        }
    }
    
    func DarkerColor() -> UIColor
    {
        var s: CGFloat = 0, h: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: min(b - (b * 0.2),b), alpha: a)
    }
}
