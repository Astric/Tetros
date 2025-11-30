//
//  TetrisBoard.swift
//  TetrisEngine
//
//  Created by Kostas on 27/11/2025.
//

import Foundation

public struct Position {
    public var x: Int
    public var y: Int

    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public class TetrisBoard {
    public var grid: [[Int]]
    public private(set) var rows: Int
    public private(set) var columns: Int

    public init(rows: Int = 20, columns: Int = 10) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: Array(repeating: 0, count: columns), count: rows)
    }

    public func canMovePieceDown(pieceMatrix: Matrix, currentPiecePosition: Position) -> Bool {
        let newY = currentPiecePosition.y + 1

        for row in 0..<pieceMatrix.count {
            for col in 0..<pieceMatrix[row].count {
                if pieceMatrix[row][col] == 0 {
                    continue
                }

                let boardY = newY + row
                let boardX = currentPiecePosition.x + col

                // Skip collision check for cells above the board
                if boardY < 0 {
                    continue
                }

                if boardY >= rows {
                    return false
                }

                if grid[boardY][boardX] != 0 {
                    return false
                }
            }
        }

        return true
    }

    public func canMovePieceLeft(pieceMatrix: Matrix, currentPiecePosition: Position) -> Bool {
        let newX = currentPiecePosition.x - 1

        for row in 0..<pieceMatrix.count {
            for col in 0..<pieceMatrix[row].count {
                if pieceMatrix[row][col] == 0 {
                    continue
                }

                let boardY = currentPiecePosition.y + row
                let boardX = newX + col

                // Skip collision check for cells above the board
                if boardY < 0 {
                    continue
                }

                if boardX < 0 {
                    return false
                }

                if boardX >= columns {
                    return false
                }

                if grid[boardY][boardX] != 0 {
                    return false
                }
            }
        }

        return true
    }

    public func canMovePieceRight(pieceMatrix: Matrix, currentPiecePosition: Position) -> Bool {
        let newX = currentPiecePosition.x + 1

        for row in 0..<pieceMatrix.count {
            for col in 0..<pieceMatrix[row].count {
                if pieceMatrix[row][col] == 0 {
                    continue
                }

                let boardY = currentPiecePosition.y + row
                let boardX = newX + col

                // Skip collision check for cells above the board
                if boardY < 0 {
                    continue
                }

                if boardX < 0 {
                    return false
                }

                if boardX >= columns {
                    return false
                }

                if grid[boardY][boardX] != 0 {
                    return false
                }
            }
        }

        return true
    }

    public func canRotatePiece(pieceMatrix: Matrix, currentPiecePosition: Position, clockwise: Bool = true) -> Bool {
        let rotatedMatrix = clockwise ? pieceMatrix.rotateClockwise90() : pieceMatrix.rotateCounterClockwise90()

        for row in 0..<rotatedMatrix.count {
            for col in 0..<rotatedMatrix[row].count {
                if rotatedMatrix[row][col] == 0 {
                    continue
                }

                let boardY = currentPiecePosition.y + row
                let boardX = currentPiecePosition.x + col

                if boardY < 0 || boardY >= rows || boardX < 0 || boardX >= columns {
                    return false
                }

                if grid[boardY][boardX] != 0 {
                    return false
                }
            }
        }

        return true
    }

    public func absorbPiece(pieceMatrix: Matrix, position: Position) {
        for row in 0..<pieceMatrix.count {
            for col in 0..<pieceMatrix[row].count {
                if pieceMatrix[row][col] == 0 {
                    continue
                }

                let boardY = position.y + row
                let boardX = position.x + col

                if boardY < 0 {
                    continue
                }

                grid[boardY][boardX] = pieceMatrix[row][col]
            }
        }
    }

    // Indices of the complete rows
    public var completeRows: [Int] {
        var result = [Int]()

        for (i, row) in grid.reversed().enumerated() {
            var isComplete = true
            for col in row {
                if col == 0 {
                    isComplete = false
                    break
                }
            }
            if isComplete {
                result.append(i)
            }
        }

        return result
    }

    // TODO: Make it more efficient?
    @discardableResult
    public func removeCompleteRows() -> Int {
        var rowsRemoved = 0

        while !completeRows.isEmpty {
            if let idx = completeRows.first {
                grid.remove(at: rows - idx - 1)
                grid.insert(Array(repeating: 0, count: columns), at: 0)

                rowsRemoved += 1
            }
        }

        return rowsRemoved
    }

}
