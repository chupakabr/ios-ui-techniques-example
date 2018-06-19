//
//  FriendsListUserCell.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

final class FriendsListUserCell: UICollectionViewCell {

    struct ViewConfig {
        let avatarSize: CGSize = CGSize(width: 36, height: 36)
        let followingIconSize: CGSize = CGSize(width: 16, height: 16)
        let separatorHeight: CGFloat = 1

        let avatarCornerRadius: CGFloat
        let infoTextColor: UIColor
        let separatorColor: UIColor
    }

    static let reuseIdentifier = "FriendsListUserCell"

    private var avatarImageView: UIImageView!
    private var userInfoText: UILabel!
    private var separatorView: UIView!

    private var viewConfig: ViewConfig = .defaultConfig

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupAvatarView()
        self.setupUserInfoView()
        self.setupSeparatorView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupAvatarView() {
        let avatarImageView = UIImageView(frame: .zero)
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill

        self.contentView.addSubview(avatarImageView)
        self.avatarImageView = avatarImageView

        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: self.viewConfig.avatarSize.width).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: self.viewConfig.avatarSize.height).isActive = true
    }

    private func setupUserInfoView() {
        let userInfoText = UILabel(frame: .zero)

        self.contentView.addSubview(userInfoText)
        self.userInfoText = userInfoText

        userInfoText.translatesAutoresizingMaskIntoConstraints = false
        userInfoText.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        userInfoText.leadingAnchor.constraint(equalTo: self.avatarImageView.trailingAnchor, constant: 12).isActive = true
    }

    private func setupSeparatorView() {
        let separatorView = UIView(frame: .zero)

        self.contentView.addSubview(separatorView)
        self.separatorView = separatorView

        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: self.viewConfig.separatorHeight).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: self.userInfoText.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    }

    // MARK: - View lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateAppearance()
    }

    // MARK: - Configuration

    func configure(with item: FriendsListUserItemProtocol, viewConfig: ViewConfig) {
        self.viewConfig = viewConfig

        self.userInfoText.textColor = viewConfig.infoTextColor
        self.separatorView.backgroundColor = viewConfig.separatorColor

        if let avatarImage = item.avatarImage {
            self.avatarImageView.image = avatarImage
        } else {
            self.avatarImageView.image = item.avatarPlaceholderImage
        }

        self.userInfoText.text = item.name
    }

    private func updateAppearance() {
        self.avatarImageView.layer.cornerRadius = self.viewConfig.avatarCornerRadius
    }
}

extension FriendsListUserCell.ViewConfig {
    static var defaultConfig: FriendsListUserCell.ViewConfig {
        return FriendsListUserCell.ViewConfig(avatarCornerRadius: 4,
                                              infoTextColor: UIColor.black,
                                              separatorColor: UIColor.black.withAlphaComponent(0.05))
    }
}
