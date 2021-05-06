//
//  RoomViewController.swift
//  Mediator
//
//  Created by Yao wang on 2021/5/5.
//

import UIKit

class RoomViewController: UIViewController {
    private let contentText: String

    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .blue
        return label
    }()

    deinit {
        print("👍👍👍 RoomViewController is released.")
    }

    init(contentText: String) {
        self.contentText = contentText
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Room"
        view.backgroundColor = .brown
        view.addSubview(contentLabel)
        contentLabel.text = contentText
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentLabel.sizeToFit()
        contentLabel.center = view.center
    }
}
