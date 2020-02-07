//
// Created by yu++ on 2020/01/31.
// Copyright (c) 2020 yu++. All rights reserved.
//

import UIKit

class CommonCollectionViewCell: UICollectionViewCell {
    var centerLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
        initLabel(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func initLayout() {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 3.0
    }

    private func initLabel(frame: CGRect) {
        NSLog("\(String(describing: self))::\(#function)@line:\(#line) frame: \(frame)")
        centerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        centerLabel?.text = ""
        centerLabel?.backgroundColor = .white
        centerLabel?.textAlignment = .center

        contentView.addSubview(centerLabel!)
    }
}
