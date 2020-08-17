//
//  JFTPosition.swift
//  Project2048
//
//  Created by hyperactive hi-tech ltd on 16/08/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

struct JFTPosition
{
    var Row: Int = 0
    var Column: Int = 0
    
    init(row: Int, col: Int)
    {
        Row = row
        Column = col
    }
    
    init(json: Dictionary<String, Any>)
    {
        Row = json["row"] as! Int
        Column = json["col"] as! Int
    }
    
    func toJSON() -> Dictionary<String, Any>
    {
        return ["row":Row, "col":Column]
    }
    
    func InBounds() -> Bool
    {
        if (Row >= 0 && Row <= 3) && (Column >= 0 && Column <= 3)
        {
            return true
        }
        return false
    }
    
    static func ==(a: JFTPosition, b: JFTPosition) -> Bool
    {
        return a.Row == b.Row && a.Column == b.Column
    }
    
    static func GetRandomPosition(tiles: Array<JFTTile>) -> JFTPosition?
    {
        var possiblePositions: Array = Array<JFTPosition>()
        for i in 0...3
        {
            for j in 0...3
            {
                possiblePositions.append(JFTPosition(row: i, col: j))
            }
        }
        for tile in tiles
        {
            possiblePositions.remove(at: possiblePositions.firstIndex(where: { (position) -> Bool in
                position == tile.Position
            })!)
        }
        return possiblePositions.randomElement()
    }
}
