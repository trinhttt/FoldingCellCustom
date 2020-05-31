//
//  FoldingCardTableViewCell.swift
//  Zooo_FoldingCard
//
//  Created by Trinh Thai on 5/31/20.
//  Copyright © 2020 Trinh Thai. All rights reserved.
//

import UIKit

class FoldingCardTableViewCell: FoldingCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2, 0.2, 0.2, 0.2,  0.2, 0.2, 0.2,  0.2, 0.2]
        return durations[itemIndex]
    }
}
