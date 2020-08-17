//
//  JFTTile.swift
//  Project2048
//
//  Created by hyperactive hi-tech ltd on 16/08/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

class JFTTile
{
    var Position: JFTPosition = JFTPosition(row: 0, col: 0)
    var Value: Int = 0
    var Merged: Bool = false
    
    init(position: JFTPosition, value: Int, merged: Bool = false)
    {
        Position = position
        Value = value
        Merged = merged
    }
    
    init(json: Dictionary<String, Any>)
    {
        Position = JFTPosition(json: json["position"] as! Dictionary<String, Any>)
        Value = json["value"] as! Int
        Merged = json["merged"] as! Bool
    }
    
    func toJSON() -> Dictionary<String, Any>
    {
        return ["position":Position.toJSON(), "value":Value, "merged":Merged]
    }
}
