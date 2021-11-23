//
//  MemoListTableViewCell.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/09.
//

import UIKit

class MemoListTableViewCell: UITableViewCell {
    static let identifier: String = "MemoListTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont().titleStyle
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.font = UIFont().subscriptStyle
        }
    }
    @IBOutlet weak var contentLabel: UILabel! {
        didSet {
            contentLabel.font = UIFont().subscriptStyle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(row: Memo) {
        titleLabel.text = row.title
        let date = DateFormatter.makeString(date: row.createdAt)
        dateLabel.text = "\(date)"
        contentLabel.text = row.content
        titleLabel.textColor = .white
        contentLabel.textColor = .white
    }
    
    func setHighlightedLabel(searchText: String) {
        guard let contentText = self.contentLabel.text else {
            return
        }
        let contentAttributedString = NSMutableAttributedString(string: contentText)
        contentAttributedString.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: (contentText as NSString).range(of: searchText))
        self.contentLabel.attributedText = contentAttributedString
      
        guard let titleText = self.titleLabel.text else {
            return
        }
        let titleAttributedString = NSMutableAttributedString(string: titleText)
        titleAttributedString.addAttribute(.foregroundColor, value: UIColor.systemGreen, range: (titleText as NSString).range(of: searchText))
        self.titleLabel.attributedText = titleAttributedString
    }
}
