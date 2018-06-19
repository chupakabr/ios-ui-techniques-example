//
//  FriendsListDataProvider.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 31/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import Foundation

typealias FriendsListDataLoadingCompletion = (_ newItems: [FriendsListItemProtocol], _ error: Error?) -> Void

protocol FriendsListDataProviderProtocol {
    var totalItemsCount: Observable<Int> { get }
    var hasMoreData: Bool { get }
    var items: [FriendsListItemProtocol] { get }

    func loadMore(completion: FriendsListDataLoadingCompletion?)
}

final class FriendsListDataProvider: FriendsListDataProviderProtocol {

    private let itemFactory: FriendsListItemFactoryProtocol

    init(itemFactory: FriendsListItemFactoryProtocol) {
        self.itemFactory = itemFactory
    }

    let totalItemsCount: Observable<Int> = Observable(0)
    private(set) var hasMoreData: Bool = true
    private(set) var items: [FriendsListItemProtocol] = []

    func loadMore(completion: FriendsListDataLoadingCompletion?) {
        guard self.hasMoreData else {
            completion?(self.items, nil)
            return
        }

        self.simulateDataLoading { [weak self] (hasMore, totalUsersCount, allUsers, error) in
            guard let sSelf = self else {
                completion?([], nil)
                return
            }

            sSelf.totalItemsCount.value = totalUsersCount
            sSelf.hasMoreData = hasMore
            sSelf.items = sSelf.makeItems(from: allUsers)
            completion?(sSelf.items, error)
        }
    }

    private func makeItems(from users: [UserModel]) -> [FriendsListUserItem] {
        return users.map { self.itemFactory.makeItem(from: $0) }
    }

    // MARK: - Real data loading immitation

    private var currentPage: Int = 0
    private let itemsPerPage = 20
    private lazy var inMemoryUsers: [UserModel] = {
        let availableAvatars = [
            "photo1",
            "photo2",
            "photo3",
            "photo4"
        ]
        let availableNames = [
            "Pliskin",
            "Tanaka",
            "Ronaldinho",
            "Mila",
            "Tania",
            "Megaman",
            "Yoshi"
        ]
        let availableInfos = [
            "I'm the rockstar",
            "Party man",
            "I prefer to hide my bio",
        ]

        let randomItemOrNil: ([String]) -> String? = { collection in
            let index = Int.random(min: 0, max: collection.count + 1)
            return index < collection.count ? collection[index] : nil
        }
        let randomItem: ([String]) -> String = { collection in
            let index = Int.random(min: 0, max: collection.count - 1)
            return collection[index]
        }

        let totalCount = 80
        return (1..<totalCount+1).map { userIndex in
            let avatarImageName = randomItemOrNil(availableAvatars)
            let name = "#\(userIndex)/\(totalCount) - \(randomItem(availableNames))"
            let info = randomItemOrNil(availableInfos)
            let age = 18 + Int.random(n: 50)

            return UserModel(userId: "uid\(userIndex)",
                             avatarImageName: avatarImageName,
                             name: name,
                             age: age,
                             info: info,
                             whateverField: nil)
        }
    }()

    private func simulateDataLoading(completion: @escaping (_ hasMore: Bool, _ totalUsersCount: Int, _ allUsers: [UserModel], _ error: Error?) -> Void) {

        DispatchQueue.global(qos: .background).async { [weak self] in
            sleep(UInt32(Int.random(min: 1, max: 3)))

            DispatchQueue.main.async { [weak self] in
                guard let sSelf = self else {
                    completion(false, 0, [], nil)
                    return
                }

                sSelf.currentPage += 1

                let itemsToLoad = sSelf.currentPage * sSelf.itemsPerPage
                let totalCount = sSelf.inMemoryUsers.count
                let users = Array(sSelf.inMemoryUsers.prefix(itemsToLoad))
                let hasMoreData = users.count != sSelf.inMemoryUsers.count

                completion(hasMoreData, totalCount, users, nil)
            }
        }
    }
}
