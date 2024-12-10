//
//  ViewController.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit

class ContactListViewController: UIViewController {
    
    // Core Data context 객체를 가져와서 저장함
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        fetchContacts() // 연락처 데이터를 가져옴
        tableView.reloadData() // TableView 갱신
    }
    
    // UI 설정
    private func setupUI() {
        view.backgroundColor = .white
        title = "친구 목록"
        
        // 오른쪽 상단 버튼 추가
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
        
        // TableView 추가 및 레이아웃 설정
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // '추가' 버튼 클릭 시 실행되는 함수
    @objc private func didTapAddButton() {
        print("추가 버튼 눌림")
        let phoneBookVC = PhoneBookViewController()
        navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
    // Core Data에서 연락처 데이터를 가져오는 함수
    private func fetchContacts() {
        let repuest: NSFetchRequest<Contact> = Contact.fetchRequest() // 연락처 데이터 요청 객체 생성
        
        // 데이터를 이름 순으로 정렬
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        repuest.sortDescriptors = [sortDescriptor]
        
        do {
            contacts = try context.fetch(repuest) // 요청 실행 및 결과 저장
        } catch {
            print("\(error) 연락처 불러오기 실패") // 오류 발생 시 출력
        }
    }
}

// UITableViewDelegate 확장 - TableView의 셀 높이를 설정
extension ContactListViewController: UITableViewDelegate {
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
        cell.phoneNumberLable.text = contact.phoneNumber // 전화번호 설정
        // 프로필 이미지 처리
        if let date = contact.profileImage {
            let imageName = "profile_\(date.timeIntervalSince1970)"
            if let image = loadImageFromDocumentDirectory(imageName: imageName) {
                cell.profileImageView.image = image // 저장된 이미지를 셀에 설정
            } else {
                cell.profileImageView.image = UIImage(systemName: "person.circle.fill") // 기본 이미지 설정
            }
        } else {
            cell.profileImageView.image = UIImage(systemName: "person.circle.fill") // 기본 이미지 설정
        }
        return cell
    }
    
    // Documents 디렉토리에서 이미지를 불러오는 함수
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        let fileManager = FileManager.default // FileManager 객체
        // Documents 디렉토리 경로 가져오기
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let imageUrl = documentURL.appendingPathComponent(imageName) // 이미지 파일 경로 설정
        // 이미지 파일이 존재하면 해당 이미지 반환
        if fileManager.fileExists(atPath: imageUrl.path) {
            return UIImage(contentsOfFile: imageUrl.path)
        }
        return nil // 이미지 파일이 없으면 nil 반환
    }
}
