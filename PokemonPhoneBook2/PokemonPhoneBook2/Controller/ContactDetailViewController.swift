//
//  PhoneBookViewController.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit


class PhoneBookViewController: UIViewController {
    
    var contact: Contact? // 수정할 연락처를 저장할 프로퍼티
    var isEditingContact: Bool = false
    
    private var selectedImageData: Data?
    
    // 프로필 이미지
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    
    // 랜덤 이미지 버튼
    private let randomButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self,action: #selector(generateRandomImage),for: .touchUpInside)
        return button
    }()
    // 이름 텍스트 필드
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // 전화번호 텍스트 필드
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "번호를 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        existingContactEditing() // 기존 연락처
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = "연락처 추가"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "적용",
            style: .plain,
            target: self,
            action: #selector(applyButtonTapped)
        )
        
        // 레이아웃 설정
        [
            profileImageView,
            randomButton,
            nameTextField,
            phoneTextField
            
        ].forEach { view.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        randomButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(randomButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    // 기존 연락처 표시 로직
    private func existingContactEditing() {
        guard let contact = contact else { return }
        
        title = contact.name
        nameTextField.text = contact.name
        phoneTextField.text = contact.phoneNumber
        
        if let imageData = contact.profileImage, let image = UIImage(data: imageData) {
            profileImageView.image = image
        }
    }
    
    @objc private func generateRandomImage() {
        print("랜덤 이미지 버튼 눌림")
        
        fetchRandomPokemonImage { [weak self] image in
            guard let self = self, let image = image else { return }
            DispatchQueue.main.async {
                self.profileImageView.image = image
                // 이미지 데이터를 저장
                self.selectedImageData = image.pngData()
            }
        }
    }
    // 적용 버튼
    @objc private func applyButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty else {
            showAlert(message: "이름과 전화번호를 입력해주세요.")
            return
        }
        
        let currentDate = Date()
        var imageData: Data? = nil
        
        // 이미지 데이터를 별도로 저장
        if let image = profileImageView.image,
           let imageDataTemp = image.pngData() {
            imageData = imageDataTemp  // 프로필 이미지를 Data로 저장
            // 이미지 파일 이름 생성
            let imageName = "profile_\(currentDate.timeIntervalSince1970)"
            saveImageToDocumentDirectory(imageData: imageData!, imageName: imageName)
            
            // 확인을 위한 출력
            print("저장된 이미지 데이터: \(String(describing: imageData))")
        }
        
        // contact가 nil일 경우 새 연락처 추가, 아니면 수정
        if let existingContact = contact {
            // 기존 연락처 수정
            CoreDataManager.shared.updateContact(contact: existingContact, name: name, phoneNumber: phoneNumber, profileImage: imageData)
        } else {
            // 새 연락처 추가
            CoreDataManager.shared.addContact(name: name, phoneNumber: phoneNumber, profileImage: imageData)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // 이미지 저장하는 함수
    func saveImageToDocumentDirectory(imageData: Data, imageName: String) {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        let imageUrl = documentURL.appendingPathComponent(imageName)
        do {
            try imageData.write(to: imageUrl)
            print("이미지 저장 성공: \(imageUrl)")
        } catch {
            print("이미지 저장 실패: \(error)")
        }
    }
    // 이름과 번호 미입력 시 나오는 알림
    private func showAlert(message: String) { // private 추가
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert) // alert로 수정
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}