//
//  HighScoreManager.swift
//  Tetros
//
//  Created by Kostas on 30/11/2025.
//

import Foundation

struct HighScore: Codable {
    let score: Int
    let level: Int
    let linesCleared: Int
    let date: Date
}

class HighScoreManager {
    let userDefaultsKey = "tetros.highscores"
    
    static let shared = HighScoreManager()
    
    var highScores: [HighScore] {
        if let storedData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let decoder = JSONDecoder()
            if let storedArray = try? decoder.decode([HighScore].self, from: storedData) {
                return storedArray
            }
        }
        return []
    }

    // Stores the top 20 only
    func saveToPersistence(highScore: HighScore) {
        var highscoreArray = highScores
        highscoreArray.append(highScore)
        
        let sortedScores = Array(highscoreArray.sorted(by: { $0.score > $1.score }).prefix(20))
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(sortedScores) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func generateRandomScores() {
        for _ in 0..<30 {
            let randomScore = Int.random(in: 100...9999)
            let randomLevel = Int.random(in: 1...20)
            let randomLines = Int.random(in: 10...500)
            
            // Random date within the last 90 days
            let randomDaysAgo = TimeInterval.random(in: 0...(90 * 24 * 60 * 60))
            let randomDate = Date().addingTimeInterval(-randomDaysAgo)
            
            let highScore = HighScore(
                score: randomScore,
                level: randomLevel,
                linesCleared: randomLines,
                date: randomDate
            )
            
            saveToPersistence(highScore: highScore)
        }
    }
}
