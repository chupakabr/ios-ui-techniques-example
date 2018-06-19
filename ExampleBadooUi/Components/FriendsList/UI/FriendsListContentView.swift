//
//  FriendsListContentView.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

final class FriendsListContentView: UIView {

    struct ViewConfig {
        let itemHeight: CGFloat
        let backgroundColor: UIColor
        let loadingIndicatorColor: UIColor
        let contentInsets: UIEdgeInsets
        let itemsSpacing: CGFloat
    }

    private enum State {
        enum ZeroCase {
            case empty
            case failure(error: Error)
        }

        case loading
        case normal
        case zeroCase(type: ZeroCase)
    }

    private var collectionView: UICollectionView!
    private var loadingIndicatorLabel: UILabel!

    private let viewModel: FriendsListContentViewModelProtocol
    private let viewConfig: ViewConfig

    private var observers: [ObserverProtocol] = []

    private var state: State = .loading {
        didSet {
            switch state {
            case .loading:
                self.moveToLoadingState()
            case .normal:
                self.moveToNormalState()
            case .zeroCase(let type):
                self.moveToZeroCaseState(type: type)
            }
        }
    }

    init(frame: CGRect, viewModel: FriendsListContentViewModelProtocol, viewConfig: ViewConfig) {
        self.viewModel = viewModel
        self.viewConfig = viewConfig

        super.init(frame: frame)

        self.setupContainerView()
        self.setupCollectionView()
        self.setupLoadingIndicator()
        self.setupErrorHandling()
        self.setupData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupContainerView() {
        self.backgroundColor = self.viewConfig.backgroundColor
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = self.viewConfig.itemsSpacing
        layout.sectionInset = self.viewConfig.contentInsets

        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.backgroundColor = self.viewConfig.backgroundColor

        collectionView.register(FriendsListUserCell.self,
                                forCellWithReuseIdentifier: FriendsListUserCell.reuseIdentifier)

        self.addSubview(collectionView)
        self.collectionView = collectionView

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    private func setupLoadingIndicator() {
        let loadingIndicatorLabel = UILabel(frame: .zero)
        loadingIndicatorLabel.textColor = self.viewConfig.loadingIndicatorColor
        loadingIndicatorLabel.text = "Loading friends..."

        self.addSubview(loadingIndicatorLabel)
        self.loadingIndicatorLabel = loadingIndicatorLabel

        self.loadingIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.loadingIndicatorLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.loadingIndicatorLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.observers.append(self.viewModel.isLoading.observeNewAndCall { [weak self] (isLoading) in
            guard let sSelf = self else { return }
            let hasItems = !sSelf.viewModel.items.value.isEmpty
            sSelf.state = isLoading && !hasItems ? .loading : (hasItems ? .normal : .zeroCase(type: .empty))
        })
    }

    private func setupErrorHandling() {
        self.observers.append(self.viewModel.error.observe { [weak self] (_, error) in
            if let error = error {
                self?.state = .zeroCase(type: .failure(error: error))
            }
        })
    }

    private func setupData() {
        self.observers.append(self.viewModel.items.observe { [weak self] (_, newItems) in
            self?.state = newItems.isEmpty ? .zeroCase(type: .empty) : .normal
            self?.collectionView.reloadSections(IndexSet(integer: 0))
        })
        self.viewModel.loadMore()
    }

    // MARK: - States

    private func moveToLoadingState() {
        self.collectionView.isHidden = true
        self.loadingIndicatorLabel.isHidden = false

        self.removeZeroCaseView()
    }

    private func moveToNormalState() {
        self.collectionView.isHidden = false
        self.loadingIndicatorLabel.isHidden = true

        self.removeZeroCaseView()
    }

    private func moveToZeroCaseState(type: State.ZeroCase) {
        self.collectionView.isHidden = true
        self.loadingIndicatorLabel.isHidden = true

        self.addZeroCaseView(for: type)
    }

    // MARK: - Zero cases

    private var zeroCaseView: UIView?

    private func removeZeroCaseView() {
        self.zeroCaseView?.removeFromSuperview()
        self.zeroCaseView = nil
    }

    private func addZeroCaseView(for zeroCaseType: State.ZeroCase) {
        self.removeZeroCaseView()
        self.zeroCaseView = self.attachZeroCaseView(for: zeroCaseType)
    }

    private func attachZeroCaseView(for zeroCaseType: State.ZeroCase) -> UIView {
        let zeroCaseView = UIView(frame: .zero)
        self.addSubview(zeroCaseView)

        zeroCaseView.translatesAutoresizingMaskIntoConstraints = false
        zeroCaseView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        zeroCaseView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        let label = UILabel(frame: .zero)
        zeroCaseView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: zeroCaseView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: zeroCaseView.centerYAnchor).isActive = true

        switch zeroCaseType {
        case .empty:
            label.text = "No friends to show"
        case .failure(let error):
            label.text = "Oops! \(error.localizedDescription)"
        }

        return zeroCaseView
    }
}

// MARK: - Scrolling
extension FriendsListContentView {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.isScrolledToBottom(scrollView: scrollView) {
            self.viewModel.loadMore()
        }
    }

    private func isScrolledToBottom(scrollView: UIScrollView) -> Bool {
        let lastItemIndexPath = IndexPath(item: self.viewModel.items.value.count - 1, section: 0)
        return nil != self.collectionView.indexPathsForVisibleItems.first { $0 == lastItemIndexPath }
    }
}

// MARK: - UICollectionViewDelegate
extension FriendsListContentView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = self.viewModel.item(at: indexPath) {
            self.viewModel.onItemSelected(item, at: indexPath)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension FriendsListContentView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.items.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsListUserCell.reuseIdentifier, for: indexPath)
        guard let infoCell = cell as? FriendsListUserCell else {
            assertionFailure("Unexpected cell type at \(indexPath): \(type(of: cell))")
            return cell
        }

        let item = self.viewModel.item(at: indexPath)
        guard let userItem = item as? FriendsListUserItem else {
            assertionFailure("Unexpected item type at \(indexPath): \(type(of: item))")
            return infoCell
        }

        infoCell.configure(with: userItem, viewConfig: .defaultConfig)
        return infoCell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FriendsListContentView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.viewConfig.itemHeight)
    }
}

extension FriendsListContentView.ViewConfig {
    static var defaultConfig: FriendsListContentView.ViewConfig {
        return FriendsListContentView.ViewConfig(itemHeight: 52,
                                                 backgroundColor: .white,
                                                 loadingIndicatorColor: .gray,
                                                 contentInsets: UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0),
                                                 itemsSpacing: 0)
    }
}
