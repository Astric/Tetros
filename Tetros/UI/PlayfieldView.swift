//
//  PlayfieldView.swift
//  Tetros
//
//  Created by Kostas on 28/11/2025.
//

import UIKit
import TetrisEngine

class PlayfieldView: UIView {
    private var grid: Matrix = []
    let gridThickness: CGFloat = 1

    var rows: Int { grid.count }
    var columns: Int { grid.first?.count ?? 0 }
    
    var showsGrid = true {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var blockSide: CGFloat {
        let blockSideA = bounds.height / CGFloat(rows)
        let blockSideB = bounds.width / CGFloat(columns)

        return min(blockSideA, blockSideB)
    }

    func update(grid: Matrix) {
        self.grid = grid
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }

        context.setFillColor(UIColor.systemBackground.cgColor)
        context.fill(bounds)

        let rows = self.rows
        let columns = self.columns
        let blockSide = self.blockSide

        // Offsets to center the thing (one of these always zero)
        let xOffset = (bounds.width - blockSide * CGFloat(columns)) / 2
        let yOffset = (bounds.height - blockSide * CGFloat(rows)) / 2

        if showsGrid {
            context.setStrokeColor(UIColor.secondarySystemFill.cgColor)
            context.setLineWidth(gridThickness)
            
            for i in 0..<rows+1 {
                context.move(
                    to: CGPoint(
                        x: 0 + xOffset,
                        y: CGFloat(i) * blockSide + yOffset
                    )
                )
                context.addLine(
                    to: CGPoint(
                        x: CGFloat(columns) * blockSide + xOffset,
                        y: CGFloat(i) * blockSide + yOffset
                    )
                )
            }
            
            for i in 0..<columns+1 {
                context.move(
                    to: CGPoint(
                        x: CGFloat(i) * blockSide + xOffset,
                        y: 0 + yOffset
                    )
                )
                context.addLine(
                    to: CGPoint(
                        x: CGFloat(i) * blockSide + xOffset,
                        y: CGFloat(rows) * blockSide + yOffset
                    )
                )
            }
            
            context.strokePath()
        }
        
        for i in 0..<rows {
            for j in 0..<columns {
                let val = grid[i][j]
                guard let baseColor = ColorConfig.blockColors[val] else { continue }

                if baseColor == UIColor.clear.cgColor {
                    continue
                }

                let rect = frameOfBlock(at: j, y: i)
                    .offsetBy(dx: xOffset, dy: yOffset)
                    .offsetBy(dx: -gridThickness / 2, dy: -gridThickness / 2)

                let bevelWidth: CGFloat = 2
                let innerRect = rect.insetBy(dx: bevelWidth, dy: bevelWidth)

                context.setFillColor(baseColor)
                context.fill(innerRect)

                let highlightColor = UIColor(cgColor: baseColor).lighter(by: 0.3).cgColor

                // Top edge
                context.setFillColor(highlightColor)
                let topHighlight = CGRect(
                    x: rect.minX,
                    y: rect.minY,
                    width: rect.width,
                    height: bevelWidth
                )
                context.fill(topHighlight)

                // Left edge
                let leftHighlight = CGRect(
                    x: rect.minX,
                    y: rect.minY,
                    width: bevelWidth,
                    height: rect.height
                )
                context.fill(leftHighlight)

                // Shadow for bottom and right edges
                let shadowColor = UIColor(cgColor: baseColor).darker(by: 0.3).cgColor

                // Bottom edge
                context.setFillColor(shadowColor)
                let bottomShadow = CGRect(
                    x: rect.minX,
                    y: rect.maxY - bevelWidth,
                    width: rect.width,
                    height: bevelWidth
                )
                context.fill(bottomShadow)

                // Right edge
                let rightShadow = CGRect(
                    x: rect.maxX - bevelWidth,
                    y: rect.minY,
                    width: bevelWidth,
                    height: rect.height
                )
                context.fill(rightShadow)
            }
        }
    }
}

extension PlayfieldView {
    func originOfBlock(at x: Int, y: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(x) * blockSide,
            y: CGFloat(y) * blockSide
        )
    }

    func centerOfBlock(at x: Int, y: Int) -> CGPoint {
        let origin = originOfBlock(at: x, y: y)
        return CGPoint(
            x: origin.x + blockSide / 2,
            y: origin.y + blockSide / 2
        )
    }

    func frameOfBlock(at x: Int, y: Int) -> CGRect {
        let origin = originOfBlock(at: x, y: y)
        return CGRect(
            x: origin.x,
            y: origin.y,
            width: blockSide,
            height: blockSide
        ).insetBy(dx: gridThickness, dy: gridThickness)
    }
}
