//
//  FriendsListView.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

class FriendsListView: UIView {

    struct ViewConfig {
        let headerHeight: CGFloat
        let separatorHeight: CGFloat
        let separatorColor: UIColor
    }

    private var headerView: FriendsListHeaderView!
    private var contentView: FriendsListContentView!
    private var separatorView: UIView!

    private let viewModel: FriendsListViewModelProtocol
    private let viewConfig: ViewConfig

    init(frame: CGRect, viewModel: FriendsListViewModelProtocol, viewConfig: ViewConfig) {
        self.viewModel = viewModel
        self.viewConfig = viewConfig

        super.init(frame: frame)

        self.setupHeaderView()
        self.setupSeparatorView()
        self.setupContentView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupHeaderView() {
        let view = FriendsListHeaderView(frame: .zero,
                                         viewModel: self.viewModel.headerViewModel,
                                         viewConfig: .defaultConfig)

        self.addSubview(view)
        self.headerView = view

        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: self.viewConfig.headerHeight).isActive = true
    }

    private func setupSeparatorView() {
        let view = UIView(frame: .zero)
        view.backgroundColor = self.viewConfig.separatorColor

        self.addSubview(view)
        self.separatorView = view

        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.headerView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: self.viewConfig.separatorHeight).isActive = true
    }

    private func setupContentView() {
        let view = FriendsListContentView(frame: .zero,
                                          viewModel: self.viewModel.contentViewModel,
                                          viewConfig: .defaultConfig)

        self.addSubview(view)
        self.contentView = view

        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.separatorView.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

extension FriendsListView.ViewConfig {
    static var defaultConfig: FriendsListView.ViewConfig {
        return FriendsListView.ViewConfig(headerHeight: 48,
                                          separatorHeight: 1,
                                          separatorColor: UIColor.black.withAlphaComponent(0.05))
    }
}
