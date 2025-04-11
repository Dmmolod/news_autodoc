//
//  NewsShortView.swift
//  Appstore
//
//  Created by Дмитрий Молодецкий on 11.04.2025.
//

import UIKit
import Combine


struct NewsShortViewBindings: CellModelProtocol, Equatable {
    var identity: AnyHashable
    var equatable: AnyEquatable { AnyEquatable(self) }
    
    let image: AnyPublisher<UIImage?, Never>
    let title: String
    let description: String
    let date: String
    
    let showDetail: () -> ()
    
    static func == (lhs: NewsShortViewBindings, rhs: NewsShortViewBindings) -> Bool {
        lhs.title == rhs.title
        && lhs.description == rhs.description
        && lhs.date == rhs.date
    }
}

final class NewsShortView: CommonInitView, CombineConfiguringView {
    private var containerView: UIView!
    private var iconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var dateLabel: UILabel!
    private var detailButton: UIButton!
    
    private var showDetailAction: () -> () = {}
    
    func configure(with model: NewsShortViewBindings) -> Cancellable {
        iconImageView.image = nil
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        dateLabel.text = model.date
        showDetailAction = model.showDetail
        
        return [
            model.image
                .receive(on: DispatchQueue.main)
                .assign(to: \.iconImageView.image, on: self),
        ]
    }
    
    override func commonInit() {
        super.commonInit()
        
        setupUI()
    }
    
    private func setupUI() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        iconImageView = UIImageView()
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFill
        
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        
        descriptionLabel = UILabel()
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        
        dateLabel = UILabel()
        dateLabel.textColor = .black.withAlphaComponent(0.5)
        dateLabel.textAlignment = .right
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        detailButton = UIButton()
        detailButton.addAction(
            UIAction(handler: { [weak self] _ in self?.showDetailAction() }),
            for: .touchUpInside
        )
        
        containerView = UIView()
        containerView.backgroundColor = .black.withAlphaComponent(0.02)
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        containerView.layer.borderWidth = 0.8
        containerView.clipsToBounds = true
    }
    
    private func setupConstraints() {
        let descriptionStack = UIStackView(arrangedSubviews: [descriptionLabel])
        descriptionStack.axis = .horizontal
        descriptionStack.alignment = .top
        
        let readingContentVStack = UIStackView(arrangedSubviews: [
            descriptionStack,
            dateLabel
        ])
        
        readingContentVStack.spacing = 4
        readingContentVStack.axis = .vertical
        readingContentVStack.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        let topHStack = UIStackView(arrangedSubviews: [
            iconImageView,
            titleLabel,
        ])
        
        topHStack.axis = .horizontal
        topHStack.spacing = 8
        topHStack.alignment = .top
        
        let mainVStack = UIStackView(arrangedSubviews: [
            topHStack,
            readingContentVStack
        ])
        
        mainVStack.spacing = 4
        mainVStack.axis = .vertical
        
        addSubview(containerView)
        containerView.addSubview(mainVStack)
        containerView.addSubview(detailButton)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        mainVStack.translatesAutoresizingMaskIntoConstraints = false
        topHStack.translatesAutoresizingMaskIntoConstraints = false
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            
            topHStack.heightAnchor.constraint(equalTo: iconImageView.heightAnchor),
            
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            mainVStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            mainVStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            mainVStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            mainVStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            detailButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            detailButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            detailButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            detailButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
}
