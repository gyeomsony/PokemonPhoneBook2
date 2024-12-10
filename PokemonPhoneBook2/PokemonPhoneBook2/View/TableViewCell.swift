//
//  TableViewCell.swift
//  PokemonPhoneBook2
//
//  Created by 손겸 on 12/10/24.
//


import UIKit
import SnapKit

class ContactTableViewCell: UITableViewCell {
    
    static let id = "tableViewCell"
    
    // 프로필 이미지
    public let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    // 이름 레이블
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    // 전화번호 레이블
    public let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        contentView.backgroundColor = .white
        [
            profileImageView,
            nameLabel,
            phoneNumberLabel
            
        ].forEach { contentView.addSubview($0) }
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
    }
}


