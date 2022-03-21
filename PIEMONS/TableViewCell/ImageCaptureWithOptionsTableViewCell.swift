//
//  ImageCaptureWithOptionsTableViewCell.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/19/22.
//

import UIKit

class ImageCaptureWithOptionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var checkBoxImage:UIImageView!
    static let cellIdentifier = "ImageCaptureWithOptionsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupUI(with disasterData:DisasterTypesModel){
        titleLabel.text = disasterData.type.rawValue
        checkBoxImage.image = disasterData.isSelected ? UIImage(named: "selectedCheckbox") : UIImage(named: "emptyCheckbox")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
