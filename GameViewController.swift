//
//  GameViewController.swift
//  Project2048
//
//  Created by hyperactive hi-tech ltd on 16/08/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import UIKit

class GameViewController: UIViewController
{
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var TileContainerView: UIView!
    @IBOutlet weak var VictoryScreenView: UIView!
    @IBOutlet weak var DefeatScreenView: UIView!
    private var gameEngine: JFTGame?
    private var tileSize: Float = 0
    
    
    
    
    override func loadView()
    {
        super.loadView()
        gameEngine = JFTGame(self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tileSize = (Float(TileContainerView.frame.size.height) / 4) - 5
        VictoryScreenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OnEndScreenTapped(_:))))
        DefeatScreenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(OnEndScreenTapped(_:))))
        gameEngine!.OnLoadStateRequired()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        gameEngine!.OnSaveStateRequired()
    }
    
    deinit
    {
        gameEngine!.OnSaveStateRequired()
    }
    
    @IBAction func OnResetClick(_ sender: UIButton)
    {
        gameEngine!.OnGameResetRequired()
    }
    
    @IBAction func OnPanRecognized(_ recognizer: UIPanGestureRecognizer)
    {
        if recognizer.state == .ended
        {
            let translation = recognizer.translation(in: recognizer.view)
            if abs(translation.x) > abs(translation.y)
            {
                if translation.x > 0
                {
                    gameEngine!.OnMoveMade(moveType: .Right)
                }
                else if translation.x < 0
                {
                    gameEngine!.OnMoveMade(moveType: .Left)
                }
            }
            else
            {
                if translation.y > 0
                {
                    gameEngine!.OnMoveMade(moveType: .Down)
                }
                else if translation.y < 0
                {
                    gameEngine!.OnMoveMade(moveType: .Up)
                }
            }
        }
    }
    
    @objc func OnEndScreenTapped(_ sender: UITapGestureRecognizer)
    {
        sender.view!.isHidden = true
        gameEngine!.OnGameResetRequired()
    }
    
    func OnTurnConclution(tiles: Array<JFTTile>, score: Int, oldPositions: Array<JFTPosition>, newPositions: Array<JFTPosition>)
    {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn)
        buildAnimations(animator: animator, oldPositions: oldPositions, newPositions: newPositions)
        animator.addCompletion { _ in
            self.OnGameStateUpdated(tiles: tiles, score: score)
        }
        animator.startAnimation()
    }
    
    func OnGameStateUpdated(tiles: Array<JFTTile>, score: Int)
    {
        layoutTiles(tiles: tiles)
        ScoreLabel.text = String(score)
    }
    
    func OnGameWon()
    {
        VictoryScreenView.isHidden = false
    }
    
    func OnGameLost()
    {
        DefeatScreenView.isHidden = false
    }
    
    
    
    
    private func layoutTiles(tiles: Array<JFTTile>)
    {
        cleanTileContainer()
        for tile in tiles
        {
            let tileView = JFTTileView(frame: CGRect(x: CGFloat((Float(tile.Position.Column) * tileSize) + 10), y: CGFloat(Float(tile.Position.Row) * tileSize), width: CGFloat(tileSize), height: CGFloat(tileSize)))
            tileView.PostInit(tile: tile)
            TileContainerView.addSubview(tileView)
        }
    }
    
    private func cleanTileContainer()
    {
        for view in TileContainerView.subviews
        {
            view.removeFromSuperview()
        }
    }
    
    private func buildAnimations(animator: UIViewPropertyAnimator, oldPositions: Array<JFTPosition>, newPositions: Array<JFTPosition>)
    {
        let size = oldPositions.count
        if size != 0
        {
            for i in 0..<size
            {
                let rowTranslation = oldPositions[i].Column == newPositions[i].Column
                let viewToAnimate = viewAtPosition(position: oldPositions[i])
                animator.addAnimations {
                    if rowTranslation
                    {
                        viewToAnimate?.frame.origin.y = CGFloat(Float(newPositions[i].Row) * self.tileSize)
                    }
                    else
                    {
                        viewToAnimate?.frame.origin.x = CGFloat(Float(newPositions[i].Column) * self.tileSize)
                    }
                }
            }
        }
    }
    
    private func viewAtPosition(position: JFTPosition) -> JFTTileView?
    {
        return TileContainerView.subviews.first { (view) -> Bool in (view as! JFTTileView).Position == position} as? JFTTileView
    }
}
