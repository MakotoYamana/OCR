//
//  RecognitionListTableViewCell.swift
//  OCR
//
//  Created by MakotoYamana on 2019/05/17.
//  Copyright © 2019 Makoto Yamana. All rights reserved.
//

import UIKit

class RecognitionListTableViewCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setItem(_ info: RecognitionInfo) {
        titleLabel.text = info.title
        if let date = info.date {
            dateLabel.text = dateFormat(date: date)
        }
    }
    
    private func dateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "ydMMM", options: 0, locale: Locale(identifier: "ja_JP"))
        return dateFormatter.string(from: date)
    }
    
}
