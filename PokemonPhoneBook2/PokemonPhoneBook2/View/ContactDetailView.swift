//
//  ContactDetailView.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit
import SnapKit

class ContactDetailView: UIView {

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "번호를 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("연락처 삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    private func configureUI() {
        [
            profileImageView,
            randomButton,
            nameTextField,
            phoneTextField,
            deleteButton
            
        ].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
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
        
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(60)
            $0.centerX.equalToSuperview()
        }
    }
}

