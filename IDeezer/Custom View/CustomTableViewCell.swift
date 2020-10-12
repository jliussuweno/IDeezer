//
//  CustomTableViewCell.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//

import UIKit

protocol CustomTableViewCellDelegate: class {
    func libraryButtonPressed()
}

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumCover: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var delegate: CustomTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        delegate?.libraryButtonPressed()
    }
}
