//
//  ControllerView.swift
//  Tetros
//
//  Created by Kostas on 30/11/2025.
//

// https://tetris.wiki/DAS

import UIKit

@objc
protocol ControllerViewDelegate {
    func didPressLeft()
    func didPressRight()
    func didPressDown()
    func didPressA()
    func didPressB()
}

class ControllerView: UIView {
    weak var delegate: ControllerViewDelegate?

    let leftRightButtonWidth: CGFloat = 100
    let aButtonWidth: CGFloat = 120
    let bButtonWidth: CGFloat = 120
    let buttonMargin: CGFloat = 8

    let initialDelay: TimeInterval = 0.25
    let repeatInterval: TimeInterval = 0.05

    let buttonOpacity: CGFloat = 0.0
    
    private let leftButton = UIButton(type: .system)
    private let rightButton = UIButton(type: .system)
    private let downButton = UIButton(type: .system)
    private let aButton = UIButton(type: .system)
    private let bButton = UIButton(type: .system)

    private var leftRepeatTimer: Timer?
    private var rightRepeatTimer: Timer?
    private var downRepeatTimer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear

        leftButton.backgroundColor = UIColor.gray.withAlphaComponent(buttonOpacity)
//        leftButton.setTitle("L", for: .normal)
        leftButton.addTarget(self, action: #selector(leftButtonPressed), for: .touchDown)
        leftButton.addTarget(self, action: #selector(leftButtonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        addSubview(leftButton)

        rightButton.backgroundColor = UIColor.gray.withAlphaComponent(buttonOpacity)
//        rightButton.setTitle("R", for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonPressed), for: .touchDown)
        rightButton.addTarget(self, action: #selector(rightButtonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        addSubview(rightButton)

        downButton.backgroundColor = UIColor.gray.withAlphaComponent(buttonOpacity)
//        downButton.setTitle("D", for: .normal)
        downButton.addTarget(self, action: #selector(downButtonPressed), for: .touchDown)
        downButton.addTarget(self, action: #selector(downButtonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        addSubview(downButton)

        aButton.backgroundColor = UIColor.blue.withAlphaComponent(buttonOpacity)
//        aButton.setTitle("A", for: .normal)
        aButton.addTarget(self, action: #selector(aButtonTapped), for: .touchUpInside)
        addSubview(aButton)

        bButton.backgroundColor = UIColor.red.withAlphaComponent(buttonOpacity)
//        bButton.setTitle("B", for: .normal)
        bButton.addTarget(self, action: #selector(bButtonTapped), for: .touchUpInside)
        addSubview(bButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let abButtonHeight = max(aButtonWidth, bButtonWidth)

        leftButton.frame = CGRect(
            x: buttonMargin,
            y: buttonMargin,
            width: leftRightButtonWidth,
            height: bounds.height - abButtonHeight - buttonMargin * 2
        )

        rightButton.frame = CGRect(
            x: bounds.width - leftRightButtonWidth - buttonMargin,
            y: buttonMargin,
            width: leftRightButtonWidth,
            height: bounds.height - abButtonHeight - buttonMargin * 2
        )

        aButton.frame = CGRect(
            x: buttonMargin,
            y: bounds.height - abButtonHeight - buttonMargin,
            width: aButtonWidth,
            height: abButtonHeight
        )

        bButton.frame = CGRect(
            x: bounds.width - bButtonWidth - buttonMargin,
            y: bounds.height - abButtonHeight - buttonMargin,
            width: bButtonWidth,
            height: abButtonHeight
        )

        downButton.frame = CGRect(
            x: aButtonWidth + buttonMargin * 2,
            y: bounds.height - abButtonHeight - buttonMargin,
            width: bounds.width - aButtonWidth - bButtonWidth - buttonMargin * 4,
            height: abButtonHeight
        )
    }

    @objc private func leftButtonPressed() {
        delegate?.didPressLeft()

        // Schedule repeat after initial delay
        leftRepeatTimer = Timer.scheduledTimer(withTimeInterval: initialDelay, repeats: false) { [weak self] _ in
            self?.startLeftRepeat()
        }
    }

    private func startLeftRepeat() {
        leftRepeatTimer?.invalidate()
        leftRepeatTimer = Timer.scheduledTimer(withTimeInterval: repeatInterval, repeats: true) { [weak self] _ in
            self?.delegate?.didPressLeft()
        }
    }

    @objc private func leftButtonReleased() {
        leftRepeatTimer?.invalidate()
        leftRepeatTimer = nil
    }

    @objc private func rightButtonPressed() {
        delegate?.didPressRight()

        // Schedule repeat after initial delay
        rightRepeatTimer = Timer.scheduledTimer(withTimeInterval: initialDelay, repeats: false) { [weak self] _ in
            self?.startRightRepeat()
        }
    }

    private func startRightRepeat() {
        rightRepeatTimer?.invalidate()
        rightRepeatTimer = Timer.scheduledTimer(withTimeInterval: repeatInterval, repeats: true) { [weak self] _ in
            self?.delegate?.didPressRight()
        }
    }

    @objc private func rightButtonReleased() {
        rightRepeatTimer?.invalidate()
        rightRepeatTimer = nil
    }

    @objc private func downButtonPressed() {
        delegate?.didPressDown()

        // Schedule repeat after initial delay
        downRepeatTimer = Timer.scheduledTimer(withTimeInterval: initialDelay, repeats: false) { [weak self] _ in
            self?.startDownRepeat()
        }
    }

    private func startDownRepeat() {
        downRepeatTimer?.invalidate()
        downRepeatTimer = Timer.scheduledTimer(withTimeInterval: repeatInterval, repeats: true) { [weak self] _ in
            self?.delegate?.didPressDown()
        }
    }

    @objc private func downButtonReleased() {
        downRepeatTimer?.invalidate()
        downRepeatTimer = nil
    }

    @objc private func aButtonTapped() {
        delegate?.didPressA()
    }

    @objc private func bButtonTapped() {
        delegate?.didPressB()
    }

    deinit {
        leftRepeatTimer?.invalidate()
        rightRepeatTimer?.invalidate()
        downRepeatTimer?.invalidate()
    }
}
