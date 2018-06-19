//
//  FriendsListViewController.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

final class FriendsListViewController: UIViewController {

    struct ViewConfig {
        let backgroundColor: UIColor
        let cornerRadius: CGFloat
    }

    private var infoView: FriendsListView!

    private let viewModel: FriendsListViewModelProtocol
    private let viewConfig: ViewConfig

    init(viewModel: FriendsListViewModelProtocol, viewConfig: ViewConfig) {
        self.viewModel = viewModel
        self.viewConfig = viewConfig
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupContainerView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.updateAppearance()
    }

    private func setupContainerView() {
        self.view.backgroundColor = self.viewConfig.backgroundColor

        let infoView = FriendsListView(frame: .zero,
                                       viewModel: self.viewModel,
                                       viewConfig: .defaultConfig)
        infoView.backgroundColor = self.viewConfig.backgroundColor

        self.view.addSubview(infoView)
        self.infoView = infoView

        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        infoView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        infoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }

    private func updateAppearance() {
        self.view.layer.cornerRadius = self.viewConfig.cornerRadius
    }
}

extension FriendsListViewController.ViewConfig {
    static var defaultConfig: FriendsListViewController.ViewConfig {
        return FriendsListViewController.ViewConfig(backgroundColor: .white,
                                                    cornerRadius: 16)
    }
}
