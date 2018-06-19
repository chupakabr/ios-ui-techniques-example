//
//  EntryPointViewController.swift
//  ExampleBadooUi
//
//  Created by Valerii Chevtaev on 30/05/2018.
//  Copyright © 2018 Badoo. All rights reserved.
//

import UIKit

class EntryPointViewController: UIViewController {

    private typealias Class = EntryPointViewController

    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTextView()
        self.setupActionButtons()
    }

    private func setupTextView() {
        self.view.backgroundColor = .white

        let textView = UITextView(frame: self.view.bounds)
        textView.text = Class.demoText
        textView.isEditable = false

        self.view.addSubview(textView)
    }

    private func setupActionButtons() {
        let containerView = UIStackView(frame: .zero)
        containerView.axis = .vertical
        containerView.backgroundColor = .clear
        containerView.spacing = 8

        self.view.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true

        self.addShowDemoUseCaseButton(to: containerView)
        self.addShowRealUseCaseButton(to: containerView)
    }

    private func addShowDemoUseCaseButton(to containerView: UIStackView) {
        let button = self.createActionButton()
        button.setTitle("Show demo use-case", for: .normal)
        button.addTarget(self, action: #selector(presentDemoFriendsList), for: .touchUpInside)

        containerView.addArrangedSubview(button)
    }

    private func addShowRealUseCaseButton(to containerView: UIStackView) {
        let button = self.createActionButton()
        button.setTitle("Show real app use-case", for: .normal)
        button.addTarget(self, action: #selector(presentRealFriendsList), for: .touchUpInside)

        containerView.addArrangedSubview(button)
    }

    private func createActionButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.layer.cornerRadius = 4
        return button
    }

    // MARK: - Helpers

    @objc
    private func onClosePressed(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    private func presentDemoFriendsList(sender: Any) {
        let headerViewModel = FriendsListHeaderDemoViewModel()
        headerViewModel.onCloseAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }

        let contentViewModel = FriendsListContentDemoViewModel()
        let presenter = FriendsListPresenter(headerViewModel: headerViewModel,
                                             contentViewModel: contentViewModel)
        presenter.presentFriendsList(from: self)
    }

    @objc
    private func presentRealFriendsList(sender: Any) {
        let avatarPlaceholderImage = UIImage(named: "avatar-placeholder")
        let itemFactory = FriendsListItemFactory(avatarPlaceholderImage: avatarPlaceholderImage)
        let dataProvider = FriendsListDataProvider(itemFactory: itemFactory)
        let viewModelFactory = FriendsListViewModelFactory(dataProvider: dataProvider)

        var headerViewModel = viewModelFactory.makeHeaderViewModel()
        headerViewModel.onCloseAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }

        let contentViewModel = viewModelFactory.makeContentViewModel()
        let presenter = FriendsListPresenter(headerViewModel: headerViewModel,
                                             contentViewModel: contentViewModel)
        presenter.presentFriendsList(from: self)
    }

    private static var demoText: String {
        return """
        What is Lorem Ipsum?
        Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

        Why do we use it?
        It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).


        Where does it come from?
        Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

        The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.

        Where can I get some?
        There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.
        """
    }
}

