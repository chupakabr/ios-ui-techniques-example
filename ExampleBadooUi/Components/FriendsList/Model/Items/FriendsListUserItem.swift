//
//  FriendsListUserItem.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

protocol FriendsListUserItemProtocol: FriendsListItemProtocol {
    var avatarImage: UIImage? { get }
    var avatarPlaceholderImage: UIImage? { get }
    var name: String { get }
}

class FriendsListUserItem: FriendsListUserItemProtocol {
    let uid: String
    let avatarImage: UIImage?
    let avatarPlaceholderImage: UIImage?
    let name: String

    init(uid: String, avatarImage: UIImage?, avatarPlaceholderImage: UIImage?, name: String) {
        self.uid = uid
        self.avatarImage = avatarImage
        self.avatarPlaceholderImage = avatarPlaceholderImage
        self.name = name
    }
}
