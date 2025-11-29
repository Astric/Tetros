//
//  Matrix.swift
//  TetrisEngine
//
//  Created by Kostas on 26/11/2025.
//

import Foundation

public typealias Matrix = [[Int]]

public extension Matrix {
    func rotateClockwise90() -> Self {
        guard !self.isEmpty else { return self }

        let cols = self[0].count

        return (0..<cols).map { col in
            self.reversed().map { $0[col] }
        }
    }

    func rotateCounterClockwise90() -> Self {
        guard !self.isEmpty else { return self }

        let cols = self[0].count

        return (0..<cols).reversed().map { col in
            self.map { $0[col] }
        }
    }

    func printMatrix() {
        for row in self {
            let rowString = row.map { "\($0)" }.joined(separator: " ")
            print(rowString)
        }
    }

    func matrixString(separator: String = " ") -> String {
        self.map { row in
            row.map { "\($0)" }.joined(separator: separator)
        }.joined(separator: "\n")
    }
}
