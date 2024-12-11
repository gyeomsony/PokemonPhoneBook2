//
//  ContactDetailView.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit
import SnapKit

// 연락처 세부 정보를 입력하는 커스텀 뷰
class ContactDetailView: UIView {

    // 프로필 이미지뷰 생성
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 75 // 원형 이미지뷰
        return imageView
    }()
    
    // 랜덤 이미지 생성 버튼
    let randomButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return button
    }()
    
    // 이름 입력 텍스트 필드
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // 전화번호 입력 텍스트 필드
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "번호를 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // 연락처 삭제 버튼
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("연락처 삭제", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 8.0
        
        return button
    }()
    
    // 뷰의 초기화 메서드 (코드로 생성할 때)
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI() // UI 구성 메서드 호출
    }
    
    // 스토리보드에서 사용하는 초기화 메서드 (필수 구현)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // UI 구성 메서드
    private func configureUI() {
        // 모든 UI 컴포넌트를 뷰에 추가
        [
            profileImageView,
            randomButton,
            nameTextField,
            phoneTextField,
            deleteButton
            
        ].forEach { addSubview($0) }
        
        // 프로필 이미지뷰 제약 조건
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(150)
        }
        
        // 랜덤 이미지 버튼 제약 조건
        randomButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        // 이름 텍스트 필드 제약 조건
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(randomButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 전화번호 텍스트 필드 제약 조건
        phoneTextField.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        // 삭제 버튼 제약 조건
        deleteButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(60)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(20)
        }
    }
}
