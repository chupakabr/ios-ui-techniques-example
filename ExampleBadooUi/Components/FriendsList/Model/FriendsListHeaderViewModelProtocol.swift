//
//  FriendsListHeaderViewModelProtocol.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

protocol FriendsListHeaderViewModelProtocol {
    var friendsCountIcon: UIImage? { get }
    var closeButtonIcon: UIImage? { get }

    var friendsCount: Observable<String> { get }

    var onCloseAction: VoidBlock? { get set }
}
