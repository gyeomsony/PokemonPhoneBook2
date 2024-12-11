//
//  TableViewCell.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//

import UIKit
import SnapKit

// 연락처 목록에 사용되는 커스텀 테이블 뷰 셀
class ContactTableViewCell: UITableViewCell {
    
    // 셀의 재사용 식별자
    static let id = "tableViewCell"
    
    // 프로필 이미지뷰 생성
    public let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 30 // 원형 이미지뷰
        return imageView
    }()
    
    // 이름 레이블 생성
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    // 전화번호 레이블 생성
    public let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    // 셀의 초기화 메서드 (코드로 생성할 때)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI() // UI 구성 메서드 호출
    }
    
    // 스토리보드에서 사용하는 초기화 메서드 (필수 구현)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // UI 구성 메서드
    private func configureUI() {
        contentView.backgroundColor = .white
        
        // 모든 UI 컴포넌트를 셀의 콘텐츠 뷰에 추가
        [
            profileImageView,
            nameLabel,
            phoneNumberLabel
        ].forEach { contentView.addSubview($0) }
        
        // 프로필 이미지뷰 제약 조건
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        // 이름 레이블 제약 조건
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        
        // 전화번호 레이블 제약 조건
        phoneNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
    }
}
