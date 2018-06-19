//
//  FriendsListContainerViewController.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

final class FriendsListContainerViewController: UIViewController {

    struct ViewConfig {
        enum VisualEffect {
            case blur(style: UIBlurEffectStyle)
            case color(fillColor: UIColor)
        }

        let contentInsets: UIEdgeInsets
        let visualEffect: VisualEffect

        init(contentInsets: UIEdgeInsets, visualEffect: VisualEffect) {
            self.contentInsets = contentInsets
            self.visualEffect = visualEffect
        }
    }

    private let contentViewController: UIViewController
    private let viewModel: FriendsListContainerViewModelProtocol
    private let viewConfig: ViewConfig

    private var maskView: UIVisualEffectView!

    init(contentViewController: UIViewController,
         viewModel: FriendsListContainerViewModelProtocol,
         viewConfig: ViewConfig) {
        self.contentViewController = contentViewController
        self.viewModel = viewModel
        self.viewConfig = viewConfig
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupContainer()
        self.setupMaskEffect()
        self.setupContent()

        self.setupTapOutsideGesture()
    }

    private func setupContainer() {
        self.view.backgroundColor = .clear
    }

    private func setupMaskEffect() {
        switch self.viewConfig.visualEffect {
        case .blur(let style):
            let effect = UIBlurEffect(style: style)
            self.maskView = UIVisualEffectView(effect: effect)
        case .color(let fillColor):
            self.maskView = UIVisualEffectView(effect: nil)
            self.maskView.backgroundColor = fillColor
        }
        self.maskView.frame = self.view.bounds

        self.view.insertSubview(self.maskView, at: 0)
    }

    private func setupContent() {
        let containerSize = self.view.bounds.size
        let contentSize = CGSize(width: containerSize.width - self.viewConfig.contentInsets.horizontalInset,
                                 height: containerSize.height - self.viewConfig.contentInsets.verticalInset)
        let contentOrigin = CGPoint(x: self.viewConfig.contentInsets.left,
                                    y: self.viewConfig.contentInsets.top)
        let contentFrame = CGRect(origin: contentOrigin, size: contentSize)
        self.contentViewController.view.frame = contentFrame

        self.addChildViewController(self.contentViewController)
        self.contentViewController.didMove(toParentViewController: self)
        self.view.addSubview(self.contentViewController.view)
    }

    private func setupTapOutsideGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapOutside))
        self.maskView.addGestureRecognizer(tapGesture)
    }

    @objc
    private func onTapOutside(gesture: UIGestureRecognizer) {
        self.viewModel.onOutsideContentTapAction?()
    }
}

extension FriendsListContainerViewController.ViewConfig {
    static var defaultConfig: FriendsListContainerViewController.ViewConfig {
        let insets = UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)
        let visualEffect: VisualEffect = .color(fillColor: UIColor.black.withAlphaComponent(0.7))
        return FriendsListContainerViewController.ViewConfig(contentInsets: insets,
                                                             visualEffect: visualEffect)
    }
}

extension UIEdgeInsets {
    var verticalInset: CGFloat {
        return self.bottom + self.top
    }

    var horizontalInset: CGFloat {
        return self.left + self.right
    }
}
