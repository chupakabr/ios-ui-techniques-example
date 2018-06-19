//
//  FriendsListItemFactory.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 31/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

protocol FriendsListItemFactoryProtocol {
    func makeItem(from user: UserModel) -> FriendsListUserItem
}

final class FriendsListItemFactory: FriendsListItemFactoryProtocol {

    private let avatarPlaceholderImage: UIImage?

    init(avatarPlaceholderImage: UIImage?) {
        self.avatarPlaceholderImage = avatarPlaceholderImage
    }

    func makeItem(from user: UserModel) -> FriendsListUserItem {
        let avatarImage: UIImage?
        if let avatarImageName = user.avatarImageName {
            avatarImage = UIImage(named: avatarImageName)
        } else {
            avatarImage = nil
        }

        return FriendsListUserItem(uid: user.userId,
                                   avatarImage: avatarImage,
                                   avatarPlaceholderImage: self.avatarPlaceholderImage,
                                   name: user.name)
    }
}
