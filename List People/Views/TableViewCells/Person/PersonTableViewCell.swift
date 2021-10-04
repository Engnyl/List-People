//
//  PersonTableViewCell.swift
//  List People
//
//  Created by Engin Yildiz on 4.10.2021.
//

import UIKit

final class PersonTableViewCell: UITableViewCell {
    @IBOutlet weak var fullNameLabel: UILabel!
    
    var cellViewModel: PersonCellViewModel? {
        didSet {
            fullNameLabel.text = "\(cellViewModel?.personFullName ?? "") (\(cellViewModel?.personId ?? ""))"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
