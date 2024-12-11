//
//  ViewController.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

//
//  ContactListViewController.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit

class ContactListViewController: UIViewController {
    
    // MARK: - Properties
    private var contacts: [Contact] = []

    // TableView 초기화 및 설정
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.id)
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContacts()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
    }

    private func setupNavigationBar() {
        title = "친구 목록"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Data Methods
    private func fetchContacts() {
        contacts = CoreDataManager.shared.fetchContacts()
        tableView.reloadData()
    }

    // MARK: - Actions
    @objc private func didTapAddButton() {
        navigateToPhoneBookViewController(for: nil)
    }

    private func navigateToPhoneBookViewController(for contact: Contact?) {
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.contact = contact
        navigationController?.pushViewController(phoneBookVC, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row]
        navigateToPhoneBookViewController(for: selectedContact)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UITableViewDataSource
extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.id, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }

        let contact = contacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }
}

// MARK: - ContactTableViewCell Extension
extension ContactTableViewCell {
    func configure(with contact: Contact) {
        nameLabel.text = contact.name
        phoneNumberLabel.text = contact.phoneNumber

        if let imageData = contact.profileImage, let image = UIImage(data: imageData) {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
}

