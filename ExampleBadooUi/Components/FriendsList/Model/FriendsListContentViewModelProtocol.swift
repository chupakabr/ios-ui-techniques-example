//
//  FriendsListContentViewModelProtocol.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

typealias FriendsListItemActionBlock = (_ position: IndexPath, _ item: FriendsListItemProtocol) -> Void

protocol FriendsListContentViewModelProtocol {
    var error: Observable<Error?> { get }
    var items: Observable<[FriendsListItemProtocol]> { get }
    var isLoading: Observable<Bool> { get }
    var hasMoreData: Bool { get }

    func loadMore()

    func item(at indexPath: IndexPath) -> FriendsListItemProtocol?
    func onItemSelected(_ item: FriendsListItemProtocol, at indexPath: IndexPath)
}
