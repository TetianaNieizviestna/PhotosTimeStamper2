//
//  MenuTableViewCell.swift
//  PhotosTimeStamper
//
//  Created by Тетяна Нєізвєстна on 23.10.2022.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    struct Props {
        let itemType: MenuItem
        
        let onSelect: Command
        
        static let initial: Props = .init(
            itemType: .initial,
            onSelect: .nop
        )
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        iconImageView.image = nil
        titleLabel.text = nil
    }
    
    private func setupUI() {

    }
    
    func render(_ props: Props) {
        titleLabel.text = props.itemType.title
        iconImageView.image = props.itemType.icon?.withTintColor(Style.Color.menuIconColor, renderingMode: .alwaysOriginal)
    }
}
