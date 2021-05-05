//
//  ViewController.swift
//  Example
//
//  Created by yaowang on 05/05/2021.
//

import UIKit
import Mediator

class ViewController: UIViewController {
    // MARK: - Getters and Setters
    lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    lazy var dataSource = [
        "Home",
        "Moment",
        "Me"
    ]

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.frame = view.bounds
    }
}

// MARK: - Delegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc: UIViewController?

        switch indexPath.row {
        case 0: vc = Mediator.shared.buildHomeVC { print($0) }
        case 1: vc = Mediator.shared.buildMomentVC { print($0) }
        case 2: vc = Mediator.shared.buildMeVC { print($0) }
        default: break
        }

        if let nav = navigationController, let vc = vc {
            nav.pushViewController(vc, animated: true)
        }
    }
}
