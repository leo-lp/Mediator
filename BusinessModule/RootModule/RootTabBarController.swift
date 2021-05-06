//
//  RootTabBarController.swift
//  BusinessModule
//
//  Created by 李鹏 on 2021/5/6.
//

import UIKit
import BasicComponents
import Mediator_BusinessModule

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = Mediator.shared.buildHomeVC { print($0) }
        let momentVC = Mediator.shared.buildMomentVC { print($0) }
        let meVC = Mediator.shared.buildMeVC { print($0) }
        let vcs = [homeVC!, momentVC!, meVC!]
        let items: [UITabBarItem.SystemItem] = [.bookmarks, .contacts, .more]
        
        for (idx, vc) in vcs.enumerated() {
            vc.tabBarItem = UITabBarItem(tabBarSystemItem: items[idx], tag: idx)
            //vc.tabBarItem.title = vc.title
        }
        viewControllers = vcs
    }
}
