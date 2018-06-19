//
//  FriendsListHeaderView.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

final class FriendsListHeaderView: UIView {

    struct ViewConfig {
        let containerColor: UIColor
        let infoIconSize: CGSize
        let infoTextColor: UIColor
        let infoItemSpacing: CGFloat
        let infoItemInnerSpacing: CGFloat
        let closeButtonSize: CGSize
    }

    private var closeButton: UIButton!
    private var infoStackView: UIStackView!
    private var friendsCountTextView: UILabel!

    private let viewModel: FriendsListHeaderViewModelProtocol
    private let viewConfig: ViewConfig
    private var observers: [ObserverProtocol] = []

    init(frame: CGRect, viewModel: FriendsListHeaderViewModelProtocol, viewConfig: ViewConfig) {
        self.viewModel = viewModel
        self.viewConfig = viewConfig

        super.init(frame: frame)

        self.setupContainerView()
        self.setupCloseButton()
        self.setupInfoViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContainerView() {
        self.backgroundColor = self.viewConfig.containerColor
    }

    private func setupCloseButton() {
        let button = UIButton(type: .custom)
        button.setImage(self.viewModel.closeButtonIcon, for: .normal)
        button.addTarget(self, action: #selector(onCloseButtonTapped), for: .touchUpInside)

        self.addSubview(button)
        self.closeButton = button

        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        button.widthAnchor.constraint(equalToConstant: self.viewConfig.closeButtonSize.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: self.viewConfig.closeButtonSize.height).isActive = true
    }

    private func setupInfoViews() {
        let (friendsCountView, friendsCountTextView) = self.createItemView(icon: self.viewModel.friendsCountIcon)
        self.friendsCountTextView = friendsCountTextView
        self.observers.append(self.viewModel.friendsCount.observeNewAndCall { [weak self] (newValue) in
            self?.friendsCountTextView.text = newValue
        })

        let innerViews = [friendsCountView]
        let stackView = UIStackView(arrangedSubviews: innerViews)
        stackView.distribution = .equalSpacing
        stackView.spacing = self.viewConfig.infoItemSpacing

        self.addSubview(stackView)
        self.infoStackView = stackView

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(lessThanOrEqualTo: self.closeButton.leadingAnchor).isActive = true
    }

    private func createItemView(icon: UIImage?) -> (UIStackView, UILabel) {
        let textView = UILabel(frame: .zero)
        textView.textColor = self.viewConfig.infoTextColor

        let iconView = UIImageView(image: icon)
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalToConstant: self.viewConfig.infoIconSize.width).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: self.viewConfig.infoIconSize.height).isActive = true

        let containerStackView = UIStackView(arrangedSubviews: [iconView, textView])
        containerStackView.distribution = .equalSpacing
        containerStackView.spacing = self.viewConfig.infoItemInnerSpacing

        return (containerStackView, textView)
    }

    // MARK: - Actions

    @objc
    private func onCloseButtonTapped() {
        self.viewModel.onCloseAction?()
    }
}

extension FriendsListHeaderView.ViewConfig {
    static var defaultConfig: FriendsListHeaderView.ViewConfig {
        return FriendsListHeaderView.ViewConfig(containerColor: .white,
                                                infoIconSize: CGSize(width: 16, height: 16),
                                                infoTextColor: .black,
                                                infoItemSpacing: 20,
                                                infoItemInnerSpacing: 4,
                                                closeButtonSize: CGSize(width: 24, height: 24))
    }
}
