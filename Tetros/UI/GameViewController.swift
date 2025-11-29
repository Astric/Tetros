//
//  ViewController.swift
//  Tetros
//
//  Created by Kostas on 26/11/2025.
//

import UIKit
import TetrisEngine

class GameViewController: UIViewController {
    let engine = TetrisEngine(rows: 20, columns: 10)
    var displayLink: CADisplayLink?
    var lastUpdateTime: CFTimeInterval = 0
    var pendingAction: TetrisEngine.UserAction? = nil

    @IBOutlet var boardView: PlayfieldView!
    @IBOutlet var nextPieceView: PlayfieldView!
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    lazy var swipeLeftRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleSwipeLeft)
        )
        recognizer.direction = .left
        return recognizer
    }()

    lazy var swipeRightRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleSwipeRight)
        )
        recognizer.direction = .right
        return recognizer
    }()

    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleSingleTap)
        )

        return recognizer
    }()

    lazy var swipeDownRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleSwipeDown)
        )
        recognizer.direction = .down
        return recognizer
    }()

    lazy var overlayView: InGameOverlayView = {
        let overlayView = InGameOverlayView(frame: .zero)
        overlayView.delegate = self
        overlayView.alpha = 0
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        return overlayView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        startGameLoop()
    }

    func initializeUI() {
        boardView.translatesAutoresizingMaskIntoConstraints = false
        boardView.isUserInteractionEnabled = true
        boardView.addGestureRecognizer(swipeLeftRecognizer)
        boardView.addGestureRecognizer(swipeRightRecognizer)
        boardView.addGestureRecognizer(swipeDownRecognizer)
        boardView.addGestureRecognizer(tapGestureRecognizer)
        //boardView.layer.borderColor = UIColor.systemOrange.cgColor
        //boardView.layer.borderWidth = 1
        nextPieceView.showsGrid = false
    }

    func startGameLoop() {
        lastUpdateTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink?.add(to: .main, forMode: .common)
    }

    func stopGameLoop() {
        displayLink?.invalidate()
        displayLink = nil
    }

    deinit {
        stopGameLoop()
    }

    
    /// The display grid is a combination of the current active piece and the absorbed pieces
    @objc func gameLoop() {
        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - lastUpdateTime
        lastUpdateTime = currentTime

        engine.update(deltaTime: deltaTime, action: pendingAction)
        pendingAction = nil

        let displayGrid = engine.getDisplayGrid()
        boardView.update(grid: displayGrid)
        
        if let matrix = engine.nextPiece?.matrix {
            nextPieceView.update(grid: matrix)
        }

        levelLabel.text = "\(engine.level + 1)"
        scoreLabel.text = "\(engine.score)"
        
        if engine.isGameOver {
            stopGameLoop()
            showGameOver()
        }
    }

    @objc func showGameOver() {
        overlayView.titleText = "Game Over!"
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.widthAnchor.constraint(equalTo: view.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: view.heightAnchor),
            overlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 1
        }
    }

    func showPauseMenu() {
        overlayView.titleText = "Paused"
        view.addSubview(overlayView)

        NSLayoutConstraint.activate([
            overlayView.widthAnchor.constraint(equalTo: view.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: view.heightAnchor),
            overlayView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            overlayView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 1
        }
    }

    // MARK: User interactions

    @objc func handleSwipeLeft() {
        pendingAction = .moveLeft
    }

    @objc func handleSwipeRight() {
        pendingAction = .moveRight
    }

    @objc func handleSingleTap() {
        pendingAction = .rotate
    }

    @objc func handleSwipeDown() {
        pendingAction = .hardDrop
    }

    @IBAction func pauseButtonTapped() {
        engine.togglePause()

        if engine.isPaused {
            showPauseMenu()
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.overlayView.alpha = 0
            }) { _ in
                self.overlayView.removeFromSuperview()
            }
        }
    }
}

extension GameViewController: InGameOverlayViewDelegate {
    func inGameOverlayViewDidTapBack() {
        UIView.animate(withDuration: 0.2, animations: {
            self.overlayView.alpha = 0
        }) { _ in
            self.overlayView.removeFromSuperview()
        }

        if engine.isPaused {
            engine.togglePause()
        }
    }

    func inGameOverlayViewDidTapMainMenu() {
        navigationController?.popViewController(animated: true)
    }
}
