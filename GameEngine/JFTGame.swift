//
//  Game.swift
//  Project2048
//
//  Created by hyperactive hi-tech ltd on 16/08/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

import Foundation

class JFTGame
{
    enum MoveType
    {
        case Right
        case Left
        case Up
        case Down
    }
    
    private weak var controllerReference: GameViewController?
    private var oldPositions: Array = Array<JFTPosition>()
    private var newPositions: Array = Array<JFTPosition>()
    private var gameBoard: Array = Array<JFTTile>()
    private var isGameOver: Bool = false
    private var score: Int = 0
    
    init(_ controller: GameViewController)
    {
        controllerReference = controller
    }
    
    
    
    
    func OnMoveMade(moveType: MoveType)
    {
        moveTiles(moveType: moveType)
        let tileAdded = addRandomTile()
        if !tileAdded
        {
            gameLost()
        }
        resetMergedAfterTurnConcluded()
        controllerReference!.OnTurnConclution(tiles: gameBoard, score: score, oldPositions: oldPositions, newPositions: newPositions)
        resetEventPositionsAfterTurnConcluded()
        OnSaveStateRequired()
    }
    
    func OnGameResetRequired()
    {
        score = 0
        isGameOver = false
        gameInit()
    }
    
    func OnSaveStateRequired()
    {
        UserDefaults.standard.setValue(boardToJSON(), forKeyPath: "game_board")
        UserDefaults.standard.setValue(score, forKeyPath: "game_score")
    }
    
    func OnLoadStateRequired()
    {
        if let savedState = UserDefaults.standard.value(forKey: "game_board")
        {
            boardFromJSON(json: savedState as! Array<Dictionary<String, Any>>)
            score = UserDefaults.standard.integer(forKey: "game_score")
            controllerReference!.OnGameStateUpdated(tiles: gameBoard, score: score)
        }
        else
        {
            gameInit()
        }
    }
    
    
    
    
    
    
    
    private func gameWon()
    {
        isGameOver = true
        controllerReference!.OnGameWon()
    }
    
    private func gameLost()
    {
        isGameOver = true
        controllerReference!.OnGameLost()
    }
    
    private func gameInit()
    {
        gameBoard.removeAll()
        addRandomTile()
        addRandomTile()
        controllerReference!.OnGameStateUpdated(tiles: gameBoard, score: score)
        OnSaveStateRequired()
    }
    
    private func moveTiles(moveType: MoveType)
    {
        sortBoardBy(moveType: moveType)
        for tile in gameBoard
        {
            moveTile(tileToMove: tile, moveType: moveType)
        }
        removeZeroes()
    }
    
    private func moveTile(tileToMove: JFTTile, moveType: MoveType)
    {
        let oldPosition = tileToMove.Position
        var newPosition = tileToMove.Position
        while  nextPosition(position: newPosition, moveType: moveType).InBounds()
        {
            newPosition = nextPosition(position: newPosition, moveType: moveType)
            if let tileAtPosition = gameBoard.first(where: { (tile) -> Bool in tile.Position == newPosition && tile.Value != 0})
            {
                if tileAtPosition.Value == tileToMove.Value && !tileToMove.Merged && !tileAtPosition.Merged
                {
                    addEventPositions(oldPosition: oldPosition, newPosition: newPosition)
                    mergeTiles(a: tileToMove, b: tileAtPosition)
                    break
                }
                else
                {
                    newPosition = previousPosition(position: newPosition, moveType: moveType)
                    break
                }
            }
            if tileToMove.Value != 0
            {
                changeTilePosition(tileToUpdate: tileToMove, newPosition: newPosition)
            }
        }
        if tileToMove.Value != 0
        {
            addEventPositions(oldPosition: oldPosition, newPosition: newPosition)
        }
    }
    
    private func sortBoardBy(moveType: MoveType)
    {
        switch moveType
        {
            case MoveType.Right:
                gameBoard.sort { (a, b) -> Bool in a.Position.Column > b.Position.Column}
                gameBoard.sort { (a, b) -> Bool in a.Position.Row < b.Position.Row}
                break
            case MoveType.Left:
                gameBoard.sort { (a, b) -> Bool in a.Position.Column < b.Position.Column}
                gameBoard.sort { (a, b) -> Bool in a.Position.Row < b.Position.Row}
                break
            case MoveType.Up:
                gameBoard.sort { (a, b) -> Bool in a.Position.Row < b.Position.Row}
                gameBoard.sort { (a, b) -> Bool in a.Position.Column < b.Position.Column}
                break
            case MoveType.Down:
                gameBoard.sort { (a, b) -> Bool in a.Position.Row > b.Position.Row}
                gameBoard.sort { (a, b) -> Bool in a.Position.Column < b.Position.Column}
                break
        }
    }
    
    private func mergeTiles(a: JFTTile, b:JFTTile)
    {
        if a.Value == b.Value
        {
            b.Value += a.Value
            score += b.Value
            if b.Value == 2048
            {
                gameWon()
            }
            b.Merged = true
            a.Value = 0
        }
    }
    
    private func removeZeroes()
    {
        gameBoard.removeAll { (tile) -> Bool in tile.Value == 0 }
    }
    
    private func changeTilePosition(tileToUpdate: JFTTile, newPosition: JFTPosition)
    {
        gameBoard[gameBoard.firstIndex(where: { (tile) -> Bool in tile.Position == tileToUpdate.Position})!].Position = newPosition
    }
    
    private func resetMergedAfterTurnConcluded()
    {
        for tile in gameBoard
        {
            tile.Merged = false
        }
    }
    
    private func nextPosition(position: JFTPosition, moveType: MoveType) -> JFTPosition
    {
        switch moveType
        {
            case MoveType.Right:
                return JFTPosition(row: position.Row, col: position.Column + 1)
            case MoveType.Left:
                return JFTPosition(row: position.Row, col: position.Column - 1)
            case MoveType.Up:
                return JFTPosition(row: position.Row - 1, col: position.Column)
            case MoveType.Down:
                return JFTPosition(row: position.Row + 1, col: position.Column)
        }
    }
    
    private func previousPosition(position: JFTPosition, moveType: MoveType) -> JFTPosition
    {
        switch moveType
        {
            case MoveType.Right:
                return JFTPosition(row: position.Row, col: position.Column - 1)
            case MoveType.Left:
                return JFTPosition(row: position.Row, col: position.Column + 1)
            case MoveType.Up:
                return JFTPosition(row: position.Row + 1, col: position.Column)
            case MoveType.Down:
                return JFTPosition(row: position.Row - 1, col: position.Column)
        }
    }
    
    @discardableResult private func addRandomTile() -> Bool
    {
        let rPosition = JFTPosition.GetRandomPosition(tiles: gameBoard)
        if rPosition == nil
        {
            return false
        }
        let rValue = (Float.random(in: 0...1) > 0.1) ? 2 : 4
        let newTile = JFTTile(position: rPosition!, value: rValue)
        gameBoard.append(newTile)
        return true
    }
    
    private func resetEventPositionsAfterTurnConcluded()
    {
        oldPositions.removeAll()
        newPositions.removeAll()
    }
    
    private func addEventPositions(oldPosition: JFTPosition, newPosition: JFTPosition)
    {
        oldPositions.append(oldPosition)
        newPositions.append(newPosition)
    }
    
    private func boardToJSON() -> Array<Dictionary<String, Any>>
    {
        var jsonBoard = Array<Dictionary<String, Any>>()
        for tile in gameBoard
        {
            jsonBoard.append(tile.toJSON())
        }
        return jsonBoard
    }
    
    private func boardFromJSON(json: Array<Dictionary<String, Any>>)
    {
        gameBoard.removeAll()
        for jsonTile in json
        {
            gameBoard.append(JFTTile(json: jsonTile))
        }
    }
}
