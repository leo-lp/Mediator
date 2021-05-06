//
//  HomeViewController.swift
//  Mediator
//
//  Created by Yao wang on 2021/5/5.
//

import UIKit
import BasicComponents
import Mediator_BusinessModule

class HomeViewController: UIViewController {
    // MARK: - Getters and Setters
    private lazy var pushBViewControllerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Enter the room to watch the live broadcast", for: .normal)
        button.addTarget(self, action: #selector(enterRoomButtonClicked(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .orange
        view.addSubview(pushBViewControllerButton)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        pushBViewControllerButton.sizeToFit()
        pushBViewControllerButton.center = view.center
    }
}

extension HomeViewController {
    // MARK: - Actions
    @objc private func enterRoomButtonClicked(_ sender: UIButton) {
        let vc = Mediator.shared.buildRoomVC("Hello, is this lady good-looking! ! !") { print($0) }
        present(vc!, animated: true, completion: nil)
    }
}
