//
//  ScoresViewController.swift
//  Tetros
//
//  Created by Kostas on 30/11/2025.
//

import UIKit
import SwiftUI

class ScoresViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    func setup() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
    }
    @IBAction func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ScoresViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HighScoreManager.shared.highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let highScore = HighScoreManager.shared.highScores[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration {
            HStack {
                Text("#\(indexPath.row + 1)")
                Spacer()
                Text("\(highScore.score)")
                    .foregroundStyle(.green)
                Spacer()
                Text(highScore.date, format: Date.FormatStyle(date: .abbreviated, time: .omitted))
            }
            .font(Font(UIFont(name: "MarkerFelt-Wide", size: 17) ?? .systemFont(ofSize: 17)))
        }
        return cell
    }
    
    
}
