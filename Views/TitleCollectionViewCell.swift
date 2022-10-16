//
//  TitleCollectionViewCell.swift
//  YoutubeAPI
//
//  Created by FREESKIER on 11.10.2022.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewedCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.backgroundColor = CGColor(red: 0.11, green: 0.11, blue: 0.15, alpha: 1.00)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with imgString: String, title: String, viewCount: Int) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(imgString)") else {
            return
        }
        
        posterImageView.sd_setImage(with: url, completed: nil)
        viewedCountLabel.text = String(viewCount)
        authorLabel.text = title
    }
}
