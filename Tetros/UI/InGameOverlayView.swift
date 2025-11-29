//
//  InGameOverlayView.swift
//  Tetros
//
//  Created by Kostas on 29/11/2025.
//

import UIKit

@objc protocol InGameOverlayViewDelegate {
    func inGameOverlayViewDidTapBack()
    func inGameOverlayViewDidTapMainMenu()
}

class InGameOverlayView: UIView {
    weak var delegate: InGameOverlayViewDelegate?

    var titleText: String = "Paused" {
        didSet {
            titleLabel.text = titleText
        }
    }

    private lazy var backButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Back"
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var mainMenuButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Main Menu"
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(mainMenuButtonTapped), for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var containerView: UIView = {
        let containerView = UIView(frame: .zero)
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1;
        containerView.layer.borderColor = UIColor.tertiarySystemFill.cgColor
//        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = titleText
        label.font = UIFont(name: "MarkerFelt-Wide", size: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, backButton, mainMenuButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("Init only programatically")
    }

    func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)

        containerView.addSubview(stackView)
        addSubview(containerView)

        stackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        containerView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        containerView.center = center
        stackView.center = CGPoint(x: 100, y: 100)
    }

    @objc func backButtonTapped() {
        delegate?.inGameOverlayViewDidTapBack()
    }

    @objc func mainMenuButtonTapped() {
        delegate?.inGameOverlayViewDidTapMainMenu()
    }

}
