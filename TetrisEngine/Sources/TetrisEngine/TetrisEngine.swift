//
//  TetrisEngine.swift
//  TetrisEngine
//
//  Created by Kostas on 27/11/2025.
//

import Foundation

public class TetrisEngine {
    public private(set) var board: TetrisBoard
    public private(set) var currentPiece: ActivePiece?
    public private(set) var currentPiecePosition: Position = Position(x: 0, y: -4)
    public private(set) var score: Int = 0
    public private(set) var level: Int = 0
    public private(set) var linesCleared: Int = 0
    public private(set) var isGameOver: Bool = false
    public private(set) var isPaused: Bool = false

    private let sevenBag = SevenBag(things: Set(Tetromino.allCases))
    public var nextPiece: Tetromino?

    private var fallTimer: TimeInterval = 0
    private let hardDropInterval: TimeInterval = 0.03

    private var isHardDropping: Bool = false
    private var hardDropTargetY: Int = 0

    // Classic Game Boy Tetris speed curve (in seconds per cell)
    // Levels 0-8, gets progressively faster
    private let speedTable: [TimeInterval] = [
        0.80,  // Level 0
        0.72,  // Level 1
        0.63,  // Level 2
        0.55,  // Level 3
        0.47,  // Level 4
        0.38,  // Level 5
        0.30,  // Level 6
        0.22,  // Level 7
        0.13   // Level 8
    ]

    private var fallInterval: TimeInterval {
        return speedTable[min(level, speedTable.count - 1)]
    }

    public enum UserAction {
        case moveLeft
        case moveRight
        case rotate
        case softDrop
        case hardDrop
    }

    public init(rows: Int = 20, columns: Int = 10) {
        board = TetrisBoard(rows: rows, columns: columns)
        spawnNewPiece()
    }

    public func update(deltaTime: TimeInterval, action: UserAction?) {
        guard !isGameOver && !isPaused else { return }

        if let action {
            handleAction(action)
        }

        fallTimer += deltaTime

        // Animate the hard droping
        if isHardDropping {
            if fallTimer >= hardDropInterval {
                fallTimer = 0
                if currentPiecePosition.y < hardDropTargetY {
                    currentPiecePosition.y += 1
                } else {
                    isHardDropping = false
                    lockCurrentPiece()
                }
            }
        } else {
            if fallTimer >= fallInterval {
                fallTimer = 0
                tryMovePieceDown()
            }
        }
    }

    public func togglePause() {
        isPaused.toggle()
    }

    private func handleAction(_ action: UserAction) {
        switch action {
        case .moveLeft:
            tryMovePieceLeft()
        case .moveRight:
            tryMovePieceRight()
        case .rotate:
            tryRotatePiece()
        case .softDrop:
            tryMovePieceDown()
        case .hardDrop:
            hardDropPiece()
        }
    }

    private func tryMovePieceDown() {
        guard let piece = currentPiece else {
            return
        }

        if !board.canMovePieceDown(
            pieceMatrix: piece.matrix,
            currentPiecePosition: currentPiecePosition
        ) {
            lockCurrentPiece()
        } else {
            currentPiecePosition.y += 1
        }
    }

    private func tryMovePieceRight() {
        guard let piece = currentPiece else {
            return
        }

        if board.canMovePieceRight(
            pieceMatrix: piece.matrix,
            currentPiecePosition: currentPiecePosition
        ) {
            currentPiecePosition.x += 1
        }
    }

    private func tryMovePieceLeft() {
        guard let piece = currentPiece else {
            return
        }

        if board.canMovePieceLeft(
            pieceMatrix: piece.matrix,
            currentPiecePosition: currentPiecePosition
        ) {
            currentPiecePosition.x -= 1
        }
    }

    private func tryRotatePiece() {
        guard var piece = currentPiece else {
            return
        }

        if board.canRotatePiece(
            pieceMatrix: piece.matrix,
            currentPiecePosition: currentPiecePosition
        ) {
            piece.rotate(clockwise: true)
            currentPiece = piece
        }
    }

    private func hardDropPiece() {
        guard let piece = currentPiece else {
            return
        }

        // Calculate the final landing position
        var targetY = currentPiecePosition.y
        while board.canMovePieceDown(
            pieceMatrix: piece.matrix,
            currentPiecePosition: Position(
                x: currentPiecePosition.x,
                y: targetY
            )
        ) {
            targetY += 1
        }

        isHardDropping = true
        hardDropTargetY = targetY
        fallTimer = 0
    }

    private func lockCurrentPiece() {
        guard let piece = currentPiece else {
            return
        }

        // Game over if piece locks while above the visible board
        if currentPiecePosition.y < 0 {
            isGameOver = true
            return
        }

        board.absorbPiece(
            pieceMatrix: piece.matrix,
            position: currentPiecePosition
        )

        let clearedLines = board.removeCompleteRows()
        if clearedLines > 0 {
            linesCleared += clearedLines
            updateScore(linesCleared: clearedLines)
            updateLevel()
        }

        spawnNewPiece()
    }

    private func updateScore(linesCleared: Int) {
        // Classic Tetris scoring
        let baseScore: Int
        switch linesCleared {
        case 1: baseScore = 40
        case 2: baseScore = 100
        case 3: baseScore = 300
        case 4: baseScore = 1200
        default: baseScore = 0
        }

        score += baseScore * (level + 1)
    }

    private func updateLevel() {
        // Level up every 10 lines
        let newLevel = min(linesCleared / 10, 8)
        level = newLevel
    }

    private func prepareNewPiece() {
        nextPiece = sevenBag.next
    }

    private func spawnNewPiece() {
        if nextPiece == nil {
            prepareNewPiece()
        }
        currentPiece = ActivePiece(type: nextPiece!)

        let centeredX = (board.columns - 4) / 2
        currentPiecePosition = Position(x: centeredX, y: -4)

        prepareNewPiece()
    }
}

public extension TetrisEngine {
    /// Returns a composite grid combining the absorbed pieces and the current active piece
    /// This is what should be rendered to the screen
    func getDisplayGrid() -> Matrix {
        var displayGrid = board.grid

        guard let piece = currentPiece else {
            return displayGrid
        }

        let matrix = piece.matrix
        for row in 0..<matrix.count {
            for col in 0..<matrix[row].count {
                if matrix[row][col] == 0 {
                    continue
                }

                let boardY = currentPiecePosition.y + row
                let boardX = currentPiecePosition.x + col

                if boardY >= 0 && boardY < board.rows && boardX >= 0
                    && boardX < board.columns
                {
                    displayGrid[boardY][boardX] = matrix[row][col]
                }
            }
        }

        return displayGrid
    }
}
