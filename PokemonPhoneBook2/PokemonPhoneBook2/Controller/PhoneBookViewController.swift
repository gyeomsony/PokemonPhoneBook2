//
//  PhoneBookViewController.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit

class PhoneBookViewController: UIViewController {
    
    // MARK: - Properties
    var contact: Contact?
    var isEditingContact: Bool = false
    private var selectedImageData: Data?
    
    private let detailView = ContactDetailView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        existingContactEditing()
        setupActions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        title = "연락처 추가"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "적용",
            style: .plain,
            target: self,
            action: #selector(applyButtonTapped)
        )
        
        view.addSubview(detailView)
        detailView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupActions() {
        detailView.randomButton.addTarget(self, action: #selector(generateRandomImage), for: .touchUpInside)
    }
    
    // MARK: - Data Binding
    private func existingContactEditing() {
        guard let contact = contact else { return }
        
        title = contact.name
        detailView.nameTextField.text = contact.name
        detailView.phoneTextField.text = contact.phoneNumber
        
        if let imageData = contact.profileImage, let image = UIImage(data: imageData) {
            detailView.profileImageView.image = image
        }
    }
    
    // MARK: - Actions
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
    
    @objc private func applyButtonTapped() {
        guard let name = detailView.nameTextField.text, !name.isEmpty,
              let phoneNumber = detailView.phoneTextField.text, !phoneNumber.isEmpty else {
            showAlert(message: "이름과 전화번호를 입력해주세요.")
            return
        }
        
        let currentDate = Date()
        var imageData: Data? = nil
        
        if let image = detailView.profileImageView.image,
           let imageDataTemp = image.pngData() {
            imageData = imageDataTemp
            let imageName = "profile_\(currentDate.timeIntervalSince1970)"
            saveImageToDocumentDirectory(imageData: imageData!, imageName: imageName)
        }
        
        if let existingContact = contact {
            CoreDataManager.shared.updateContact(contact: existingContact, name: name, phoneNumber: phoneNumber, profileImage: imageData)
        } else {
            CoreDataManager.shared.addContact(name: name, phoneNumber: phoneNumber, profileImage: imageData)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
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
