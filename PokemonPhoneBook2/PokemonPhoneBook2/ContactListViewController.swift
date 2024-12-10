//
//  ViewController.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit

class ContactListViewController: UIViewController {
    
    var contact: Contact?
    
    // 연락처 데이터를 담을 배열
    var contacts: [Contact] = []
    
    // TableView 초기화 및 설정
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // 화면 UI 설정
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contacts = CoreDataManager.shared.fetchContacts() // 연락처 데이터를 가져옴
        tableView.reloadData() // TableView 갱신
    }
    
    // UI 설정
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
    
    // '추가' 버튼 클릭 시 실행되는 함수
    @objc private func didTapAddButton() {
        print("추가 버튼 눌림")
        let phoneBookVC = PhoneBookViewController()
        
        phoneBookVC.contact = self.contact// 수정하려는 연락처 전달
        
        navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
}

// UITableViewDelegate 확장 - TableView의 셀 높이를 설정
extension ContactListViewController: UITableViewDelegate {
    // 셀 클릭 시 실행되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contacts[indexPath.row] // 클릭된 연락처를 가져옴
        
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.contact = contact // 수정할 연락처를 PhoneBookViewController에 전달
        navigationController?.pushViewController(phoneBookVC, animated: true) // 수정 화면으로 이동
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // 각 셀의 높이
    }
}



// UITableViewDataSource 확장 - TableView의 데이터 설정
extension ContactListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count // 연락처 개수만큼의 셀 반환
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TableView에서 셀 가져오기
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.id, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        // 현재 연락처 정보 가져오기
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.name // 이름 설정
        cell.phoneNumberLabel.text = contact.phoneNumber // 전화번호 설정
        
        // 프로필 이미지 처리
        if let imageData = contact.profileImage, let image = UIImage(data: imageData) {
            cell.profileImageView.image = image // 저장된 이미지를 셀에 설정
        } else {
            cell.profileImageView.image = UIImage(systemName: "person.circle.fill") // 기본 이미지 설정
        }
        
        return cell
    }
}
