//
//  Tetromino.swift
//  TetrisEngine
//
//  Created by Kostas on 26/11/2025.
//

import Foundation

public enum Tetromino: Int, CaseIterable, Hashable {
    case I = 1
    case O = 2
    case T = 3
    case J = 4
    case L = 5
    case S = 6
    case Z = 7
}

public struct ActivePiece {
    public let type: Tetromino
    public var matrix: Matrix

    public init(type: Tetromino) {
        self.type = type
        self.matrix = type.matrix
    }

    public mutating func rotate(clockwise: Bool = true) {
        matrix = clockwise ? matrix.rotateClockwise90() : matrix.rotateCounterClockwise90()
    }
}

public extension Tetromino {
    var matrix: Matrix {
        switch self {
        case .I:
            [
                [0, 0, 0, 0],
                [1, 1, 1, 1],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
            ]
        case .O:
            [
                [0, 0, 0, 0],
                [0, 2, 2, 0],
                [0, 2, 2, 0],
                [0, 0, 0, 0],
            ]
        case .T:
            [
                [0, 0, 0, 0],
                [0, 3, 3, 3],
                [0, 0, 3, 0],
                [0, 0, 0, 0],
            ]
        case .J:
            [
                [0, 0, 0, 0],
                [0, 4, 0, 0],
                [0, 4, 4, 4],
                [0, 0, 0, 0],
            ]
        case .L:
            [
                [0, 0, 0, 0],
                [0, 0, 0, 5],
                [0, 5, 5, 5],
                [0, 0, 0, 0],
            ]
        case .S:
            [
                [0, 0, 0, 0],
                [0, 0, 6, 6],
                [0, 6, 6, 0],
                [0, 0, 0, 0],
            ]
        case .Z:
            [
                [0, 0, 0, 0],
                [0, 7, 7, 0],
                [0, 0, 7, 7],
                [0, 0, 0, 0],
            ]
        }
    }
}
