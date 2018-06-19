//
//  FriendsListContainerViewModel.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import Foundation

typealias VoidBlock = () -> Void

protocol FriendsListContainerViewModelProtocol {
    var onOutsideContentTapAction: VoidBlock? { get set }
}

final class FriendsListContainerViewModel: FriendsListContainerViewModelProtocol {
    var onOutsideContentTapAction: VoidBlock?

    init(onOutsideContentTapAction: VoidBlock? = nil) {
        self.onOutsideContentTapAction = onOutsideContentTapAction
    }
}
