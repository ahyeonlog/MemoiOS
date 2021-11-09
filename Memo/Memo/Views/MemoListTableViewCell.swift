//
//  MemoListTableViewCell.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/09.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    static let identifier: String = "MemoListTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
