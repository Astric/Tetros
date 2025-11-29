//
//  TetrosTests.swift
//  TetrosTests
//
//  Created by Kostas on 27/11/2025.
//

import Testing
@testable import Tetros

extension TetrisBoard {
    static var sample: TetrisBoard {
        let board = TetrisBoard(rows: 20, columns: 10)
        board.grid[19] = [7, 6, 5, 4, 3, 2, 1, 7, 6, 5]
        board.grid[18] = [1, 1, 2, 2, 3, 3, 4, 4, 5, 5]
        board.grid[17] = [2, 3, 4, 5, 6, 0, 1, 2, 3, 4]
        board.grid[16] = [6, 7, 1, 2, 3, 4, 5, 6, 7, 1]
        board.grid[15] = [1, 2, 3, 4, 5, 6, 7, 1, 2, 3]
        board.grid[14] = [4, 4, 0, 5, 5, 7, 7, 0, 2, 3]
        board.grid[13] = [4, 4, 5, 5, 7, 7, 0, 2, 2, 3]
        board.grid[12] = [5, 5, 0, 0, 6, 0, 0, 7, 7, 0]
        board.grid[11] = [0, 5, 5, 0, 6, 6, 6, 0, 7, 7]
        board.grid[10] = [0, 0, 0, 0, 3, 3, 0, 2, 2, 0]
        board.grid[09] = [0, 0, 0, 3, 3, 0, 0, 2, 2, 0]
        board.grid[08] = [0, 0, 0, 0, 1, 1, 0, 0, 0, 0]
        board.grid[07] = [0, 0, 0, 0, 1, 1, 0, 0, 0, 0]
        return board
    }
}

struct TetrosTests {

    @MainActor @Test func testRemoveCompleteRows() async {
        let board = TetrisBoard.sample

        let rowsRemoved = board.removeCompleteRows()
        
        #expect(rowsRemoved == 4, "Expected 4 complete rows to be removed")

        #expect(board.grid[19] == [2, 3, 4, 5, 6, 0, 1, 2, 3, 4],
                "Bottom row should be the first incomplete row after clearing")

        #expect(board.grid[18] == [4, 4, 0, 5, 5, 7, 7, 0, 2, 3],
                "Second row should have fallen down correctly")

        #expect(board.grid[17] == [4, 4, 5, 5, 7, 7, 0, 2, 2, 3],
                "Third row should have fallen down correctly")
        
        for row in 0..<4 {
            let expectedEmptyRow = Array(repeating: 0, count: 10)
            #expect(board.grid[row] == expectedEmptyRow,
                    "Row \(row) should be empty after clearing 4 complete rows")
        }

        for (index, row) in board.grid.enumerated() {
            let isComplete = row.allSatisfy { $0 != 0 }
            #expect(!isComplete, "Row \(index) should not be complete after clearing")
        }
    }
}
