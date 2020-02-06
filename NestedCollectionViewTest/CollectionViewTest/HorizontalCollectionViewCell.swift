//
// Created by yu++ on 2020/02/05.
// Copyright (c) 2020 yu++. All rights reserved.
//

import UIKit

final class HorizontalCollectionViewCell: UICollectionViewCell {

    var contents = [(labelText: String, bgColor: UIColor)]()

    var scrollPosition: CGPoint = CGPoint(x: 0, y: 0)

    static let defaultCellFrame = CGRect(
        x: 0,
        y: 0,
        width: UIScreen.main.bounds.width,
        height: 500
    )
    static let defaultCellDimensions = CGSize(
        width: defaultCellFrame.width * 0.8,
        height: defaultCellFrame.height
    )

    let horizontalScrollCollectionView: UICollectionView = {

        let horizontalCollectionView = UICollectionView(
            frame: defaultCellFrame,
            collectionViewLayout: HorizontalScrollCollectionViewFlowLayout()
        )
        horizontalCollectionView.backgroundColor = .systemGreen
        horizontalCollectionView.showsHorizontalScrollIndicator = false
        horizontalCollectionView.decelerationRate = .fast
        // Cellクラス登録
        horizontalCollectionView.register(CommonCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CommonCollectionViewCell.self))

        return horizontalCollectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        horizontalScrollCollectionView.delegate = self
        horizontalScrollCollectionView.dataSource = self
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addSubview(horizontalScrollCollectionView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

extension HorizontalCollectionViewCell: UICollectionViewDataSource {
    /// セル個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NSLog("\(String(describing: Self.self))::\(#function)@line:\(#line) section: \(section)")
        return contents.count
    }

    /// セルのデータ設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        NSLog("\(String(describing: Self.self))::\(#function)@line:\(#line) indexPath: \(indexPath)")
        guard let cell = horizontalScrollCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CommonCollectionViewCell.self), for: indexPath) as? CommonCollectionViewCell else {
            NSLog("\(String(describing: Self.self))::\(#function)@line:\(#line) fatal")
            return UICollectionViewCell()
        }
        cell.centerLabel?.text = contents[indexPath.row].labelText
        cell.centerLabel?.backgroundColor = contents[indexPath.row].bgColor

        return cell
    }
}

extension HorizontalCollectionViewCell: UICollectionViewDelegate {
}

extension HorizontalCollectionViewCell: UICollectionViewDelegateFlowLayout {
    /// セルの寸法を設定
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        NSLog("\(String(describing: Self.self))::\(#function)@line:\(#line) Self.defaultCellDimensions: \(Self.defaultCellDimensions)")
        return Self.defaultCellDimensions
    }
}

