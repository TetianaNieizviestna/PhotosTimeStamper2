//
//  NewsTableViewCell.swift
//  ViVNewsApp
//
//  Created by Tetiana Nieizviestna on 20.03.2021.
//

import UIKit

class StampedImageTableViewCell: UITableViewCell {
    struct Props {
        let imageData: StampedImageModel
        
        let onSelect: Command
        
        static let initial: Props = .init(
            imageData: StampedImageModel.initial,
            onSelect: .nop
        )
    }

    @IBOutlet private var bgView: UIView!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var loadedImageView: UIImageView!
    @IBOutlet private var imageViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        loadedImageView.image = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
    }
    
    private func setupUI() {
        loadedImageView.setCornersRadius(6)
        bgView.setCornersRadius(6)
    }
    
    func render(_ props: Props) {
        descriptionLabel.text = props.imageData.title
        dateLabel.text = props.imageData.stamp

        loadedImageView.image = props.imageData.image
    }
}
