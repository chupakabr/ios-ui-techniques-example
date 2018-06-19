//
//  FriendsListContentDemoViewModel.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 31/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

final class FriendsListContentDemoViewModel: FriendsListContentViewModelProtocol {
    private typealias Class = FriendsListContentDemoViewModel

    var hasMoreData: Bool {
        return false
    }

    let isLoading = Observable(false)

    let error: Observable<Error?> = Observable(nil)

    lazy var items: Observable<[FriendsListItemProtocol]> = {
        var items: [FriendsListItemProtocol] = []
        for i in 0..<20 {
            items.append(Class.createItem(userId: "\(i)"))
        }
        return Observable(items)
    }()

    func item(at indexPath: IndexPath) -> FriendsListItemProtocol? {
        guard indexPath.row < self.items.value.count else { return nil }
        return self.items.value[indexPath.row]
    }

    func onItemSelected(_ item: FriendsListItemProtocol, at indexPath: IndexPath) {
        print("did select item at \(indexPath): \(item)")
    }

    func loadMore() {
    }

    // MARK: - Helpers

    private class func createItem(userId: String) -> FriendsListUserItem {
        return FriendsListUserItem(uid: userId,
                                   avatarImage: Class.randomAvatarImage,
                                   avatarPlaceholderImage: Class.avatarPlaceholderImage,
                                   name: Class.randomName)
    }

    private static var randomAvatarImage: UIImage? {
        let images = [
            "photo1",
            "photo2",
            "photo3",
            "photo4"
        ]
        let imageIndex = Int.random(min: 0, max: images.count - 1)
        return UIImage(named: images[imageIndex])
    }

    private static var randomName: String {
        let names = [
            "Pliskin",
            "Tanaka",
            "Ronaldinho",
            "Mila"
        ]
        let nameIndex = Int.random(min: 0, max: names.count - 1)
        return names[nameIndex]
    }

    private static var avatarPlaceholderImage: UIImage? {
        return UIImage(named: "avatar-placeholder")
    }
}
