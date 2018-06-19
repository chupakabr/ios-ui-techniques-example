//
//  FriendsListHeaderDemoViewModel.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 31/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

final class FriendsListHeaderDemoViewModel: FriendsListHeaderViewModelProtocol {
    var friendsCountIcon: UIImage? = UIImage(named: "ic_friends_count")
    var closeButtonIcon: UIImage? = UIImage(named: "ic_close_cross")

    var friendsCount: Observable<String>
    var onCloseAction: VoidBlock?

    init() {
        let friendsCountString = "\(Int.random(min: 1, max: 5000))"
        self.friendsCount = Observable(friendsCountString)

        self.setupUpdates()
    }

    private var updateDataTimer: Timer?

    private func setupUpdates() {
        self.updateDataTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] (_) in
            guard let sSelf = self, let currentValue = Int(sSelf.friendsCount.value) else { return }
            let newValue = currentValue > 9999 ? currentValue / 2 : currentValue + Int.random(n: 5)
            sSelf.friendsCount.value = "\(newValue)"
        }
    }
}

extension Int {
    static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }

    static func random(min: Int, max: Int) -> Int {
        return Int.random(n: max - min + 1) + min
    }
}
