//
//  FriendsListPresenter.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

protocol FriendsListPresenterProtocol {
    func presentFriendsList(from presentingViewController: UIViewController)
}

final class FriendsListPresenter: FriendsListPresenterProtocol {

    private typealias Class = FriendsListPresenter

    private let headerViewModel: FriendsListHeaderViewModelProtocol
    private let contentViewModel: FriendsListContentViewModelProtocol

    weak var presentingViewController: UIViewController?

    init(headerViewModel: FriendsListHeaderViewModelProtocol,
         contentViewModel: FriendsListContentViewModelProtocol) {
        self.headerViewModel = headerViewModel
        self.contentViewModel = contentViewModel
    }

    // MARK: - FriendsListPresenterProtocol

    func presentFriendsList(from presentingViewController: UIViewController) {
        let controller = Class.createFriendsListViewController(presentingViewController: presentingViewController,
                                                               headerViewModel: self.headerViewModel,
                                                               contentViewModel: self.contentViewModel)
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve

        presentingViewController.present(controller, animated: true, completion: nil)
    }

    // MARK: - Helpers

    private class func createFriendsListViewController(presentingViewController: UIViewController,
                                                       headerViewModel: FriendsListHeaderViewModelProtocol,
                                                       contentViewModel: FriendsListContentViewModelProtocol) -> FriendsListContainerViewController {
        let dismissViewControllerBlock: VoidBlock = { [weak presentingViewController] in
            presentingViewController?.dismiss(animated: true, completion: nil)
        }

        let infoViewModel = FriendsListViewModel(headerViewModel: headerViewModel,
                                                           contentViewModel: contentViewModel)
        let containerViewModel = FriendsListContainerViewModel(onOutsideContentTapAction: dismissViewControllerBlock)

        let friendsListViewController = FriendsListViewController(viewModel: infoViewModel,
                                                                  viewConfig: .defaultConfig)
        let controller = FriendsListContainerViewController(contentViewController: friendsListViewController,
                                                            viewModel: containerViewModel,
                                                            viewConfig: .defaultConfig)
        return controller
    }
}
