//
//  ContactListViewController.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit

// 연락처 목록을 보여주는 메인 뷰 컨트롤러
class ContactListViewController: UIViewController {
    
    // MARK: - 속성
    // 연락처 데이터를 저장하는 배열
    private var contacts: [Contact] = []

    // 테이블 뷰를 생성하고 설정하는 지연 초기화된 속성
    // UITableView를 코드로 직접 생성하고 구성
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white // 배경색 흰색으로 설정
        tableView.dataSource = self // 데이터 소스 위임
        tableView.delegate = self // 델리게이트 위임
        // 커스텀 셀 등록
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.id)
        return tableView
    }()

    // MARK: - 생명주기 메서드
    // 뷰가 메모리에 로드될 때 호출되는 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // UI 설정 메서드 호출
    }

    // 뷰가 화면에 나타나기 직전에 호출되는 메서드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContacts() // 연락처 다시 불러오기
    }

    // MARK: - UI 설정 메서드
    // 전체 UI를 설정하는 메서드
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationBar() // 네비게이션 바 설정
        setupTableView() // 테이블 뷰 설정
    }

    // 네비게이션 바를 설정하는 메서드
    private func setupNavigationBar() {
        title = "친구 목록" // 화면 제목 설정
        // 오른쪽 상단 '추가' 버튼 생성
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
    }

    // 테이블 뷰를 화면에 추가하고 제약 조건을 설정하는 메서드
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 전체 뷰에 꽉 차도록 설정
        }
    }

    // MARK: - 데이터 메서드
    // CoreData에서 연락처를 불러오는 메서드
    private func fetchContacts() {
        contacts = CoreDataManager.shared.fetchContacts()
        tableView.reloadData() // 테이블 뷰 갱신
    }

    // MARK: - 액션 메서드
    // '추가' 버튼을 눌렀을 때 호출되는 메서드
    @objc private func didTapAddButton() {
        navigateToPhoneBookViewController(for: nil)
    }

    // 연락처 상세/추가 화면으로 이동하는 메서드
    private func navigateToPhoneBookViewController(for contact: Contact?) {
        let phoneBookVC = PhoneBookViewController()
        phoneBookVC.contact = contact
        navigationController?.pushViewController(phoneBookVC, animated: true)
    }
}

// MARK: - UITableViewDelegate 확장
extension ContactListViewController: UITableViewDelegate {
    // 테이블 뷰의 특정 행을 선택했을 때 호출되는 메서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedContact = contacts[indexPath.row]
        navigateToPhoneBookViewController(for: selectedContact)
    }

    // 각 행의 높이를 설정하는 메서드
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // 각 행의 높이를 80으로 고정
    }
}

// MARK: - UITableViewDataSource 확장
extension ContactListViewController: UITableViewDataSource {
    // 테이블 뷰의 행 개수를 반환하는 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    // 각 행에 대한 셀을 구성하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 커스텀 셀을 디큐 및 캐스팅
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.id, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }

        let contact = contacts[indexPath.row]
        cell.configure(with: contact) // 셀에 연락처 정보 구성
        return cell
    }
}

// MARK: - ContactTableViewCell 확장
// 셀에 연락처 정보를 구성하는 메서드를 추가
extension ContactTableViewCell {
    func configure(with contact: Contact) {
        nameLabel.text = contact.name // 이름 설정
        phoneNumberLabel.text = contact.phoneNumber // 전화번호 설정

        // 프로필 이미지 설정
        if let imageData = contact.profileImage, let image = UIImage(data: imageData) {
            profileImageView.image = image
        } else {
            // 이미지가 없는 경우 기본 시스템 아이콘 사용
            profileImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
}
