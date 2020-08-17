//
//  JFTTileView.swift
//  Project2048
//
//  Created by hyperactive hi-tech ltd on 16/08/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

@IBDesignable class JFTTileView: UIView
{
    @IBOutlet var view: UIView!
    @IBOutlet weak var TileValueLable: UILabel!
    private let xibName = "JFTTileView"
    private var color: UIColor = UIColor.ColorForValue(value: 0)
    var Position: JFTPosition = JFTPosition(row: 0, col: 0)
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        commonInit()
    }
    
    func PostInit(tile: JFTTile)
    {
        color = UIColor.ColorForValue(value: tile.Value)
        TileValueLable.text = String(tile.Value)
        Position = tile.Position
    }
    
    override func draw(_ rect: CGRect)
    {
        drawBackground(rect)
    }
    
    private func commonInit()
    {
        Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    private func drawBackground(_ rect: CGRect)
    {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 0.15)
        color.DarkerColor().setStroke()
        color.setFill()
        path.fill()
        path.stroke()
    }
}
