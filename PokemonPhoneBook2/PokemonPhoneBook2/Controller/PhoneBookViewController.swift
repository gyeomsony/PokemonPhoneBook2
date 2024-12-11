//
//  PhoneBookViewController.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit

// 연락처 추가/수정 화면을 담당하는 뷰 컨트롤러
class PhoneBookViewController: UIViewController {
    
    // MARK: - 속성
    var contact: Contact? // 현재 편집 중인 연락처
    var isEditingContact: Bool = false // 기존 연락처 편집 여부
    private var selectedImageData: Data? // 선택된 이미지 데이터
    
    // 연락처 세부 정보를 입력하는 커스텀 뷰
    private let detailView = ContactDetailView()
    
    // MARK: - 생명주기 메서드
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // UI 설정
        existingContactEditing() // 기존 연락처 정보 표시
        setupActions() // 버튼 액션 설정
    }
    
    // MARK: - UI 설정 메서드
    // 기본 UI를 설정하는 메서드
    private func setupUI() {
        view.backgroundColor = .white
        title = "연락처 추가"
        // 오른쪽 상단 '적용' 버튼 생성
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "적용",
            style: .plain,
            target: self,
            action: #selector(applyButtonTapped)
        )
        
        // 커스텀 뷰를 화면에 추가
        view.addSubview(detailView)
        detailView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    // 버튼 액션을 설정하는 메서드
    private func setupActions() {
        // 랜덤 이미지 생성 버튼 액션
        detailView.randomButton.addTarget(self, action: #selector(generateRandomImage), for: .touchUpInside)
        // 삭제 버튼 액션
        detailView.deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - 데이터 바인딩 메서드
    // 기존 연락처 정보를 화면에 표시하는 메서드
    private func existingContactEditing() {
        guard let contact = contact else { return }
        
        title = contact.name // 화면 제목을 연락처 이름으로 변경
        detailView.nameTextField.text = contact.name
        detailView.phoneTextField.text = contact.phoneNumber
        
        // 프로필 이미지 설정
        if let imageData = contact.profileImage, let image = UIImage(data: imageData) {
            detailView.profileImageView.image = image
        }
    }
    
    // 연락처 삭제 메서드
    @objc private func deleteButtonTapped() {
        print("삭제 버튼 눌림")
        
        guard let contact = contact else { return }
        
        // CoreData에서 연락처 삭제
        CoreDataManager.shared.deleteContact(contact: contact)
        
        // 이전 화면으로 돌아가기
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 액션 메서드
    // 랜덤 포켓몬 이미지를 생성하는 메서드
    @objc private func generateRandomImage() {
        print("랜덤 이미지 버튼 눌림")
        
        fetchRandomPokemonImage { [weak self] image in
            guard let self = self, let image = image else { return }
            DispatchQueue.main.async {
                self.detailView.profileImageView.image = image
                self.selectedImageData = image.pngData()
            }
        }
    }
    
    // 연락처 저장/수정 메서드
    @objc private func applyButtonTapped() {
        // 이름과 전화번호 유효성 검사
        guard let name = detailView.nameTextField.text, !name.isEmpty,
              let phoneNumber = detailView.phoneTextField.text, !phoneNumber.isEmpty else {
            showAlert(message: "이름과 전화번호를 입력해주세요.")
            return
        }
        
        let currentDate = Date()
        var imageData: Data? = nil
        
        // 이미지 저장 로직
        if let image = detailView.profileImageView.image,
           let imageDataTemp = image.pngData() {
            imageData = imageDataTemp
            let imageName = "profile_\(currentDate.timeIntervalSince1970)"
            saveImageToDocumentDirectory(imageData: imageData!, imageName: imageName)
        }
        
        // 기존 연락처 수정 또는 새 연락처 추가
        if let existingContact = contact {
            CoreDataManager.shared.updateContact(contact: existingContact, name: name, phoneNumber: phoneNumber, profileImage: imageData)
        } else {
            CoreDataManager.shared.addContact(name: name, phoneNumber: phoneNumber, profileImage: imageData)
        }
        
        // 이전 화면으로 돌아가기
        navigationController?.popViewController(animated: true)
    }
    
    // 경고창을 표시하는 메서드
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // 이미지를 문서 디렉토리에 저장하는 메서드
    private func saveImageToDocumentDirectory(imageData: Data, imageName: String) {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imageUrl = documentURL.appendingPathComponent(imageName)
        do {
            try imageData.write(to: imageUrl)
            print("이미지 저장 성공: \(imageUrl)")
        } catch {
            print("이미지 저장 실패: \(error)")
        }
    }
}
