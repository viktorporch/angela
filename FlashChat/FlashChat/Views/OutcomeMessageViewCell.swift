//
//  MessageViewCell.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023.
//

import UIKit

class OutcomeMessageViewCell: UITableViewCell {

    static let identifier = "OutcomeMessageViewCell"
    
    private let messageView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.brandPurple
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = Constants.Images.meAvatar
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - Methods
extension OutcomeMessageViewCell {
    private func setupViews() {
        backgroundColor = .white
        messageView.layer.cornerRadius = 15
        
        contentView.addSubview(messageView)
        messageView.addSubview(messageLabel)
        contentView.addSubview(avatarImageView)
        
        avatarImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        
        messageView.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView)
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.bottom.greaterThanOrEqualTo(avatarImageView)
            make.trailing.equalTo(avatarImageView.snp.leading).offset(-20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
    }
    
    func configure(messageText: String?) {
        messageLabel.text = messageText
    }
}
