//
// Created by yu++ on 2020/02/05.
// Copyright (c) 2020 yu++. All rights reserved.
//

import UIKit

class HorizontalScrollCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

    var isNeedAdjustScrollToCenterRow = false
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        NSLog(
            "\n------------------------------------------"
                + "\n\(String(describing: Self.self))::\(#function)@line:\(#line)"
                + "\nproposedContentOffset: \(proposedContentOffset)"
                + "\nvelocity: \(velocity)"
                + "\ncollectionViewContentSize: \(collectionViewContentSize)"
        )

        guard isNeedAdjustScrollToCenterRow else {
            return proposedContentOffset
        }

        let halfScreenWidth = UIScreen.main.bounds.width / 2
        let halfCellWidth = HorizontalCollectionViewCell.defaultCellDimensions.width / 2
        // half-screen-width - half-cell-width = margin-left
        let marginLeft = halfScreenWidth - halfCellWidth
        // floor((scroll-offset-x + half-screen-width) / cell-width) = index
        let moveTargetIndex = Int(floor((proposedContentOffset.x + halfScreenWidth) / HorizontalCollectionViewCell.defaultCellDimensions.width))
        NSLog("\(String(describing: Self.self))::\(#function)@line:\(#line)"
            + "\n(\(proposedContentOffset.x) + \(halfScreenWidth)) / "
            + "\(HorizontalCollectionViewCell.defaultCellDimensions.width) = "
            + "\n\(moveTargetIndex)"
        )
        // index * cell-width - margin-left = target-position-x
        let targetPositionX = CGFloat(moveTargetIndex) * HorizontalCollectionViewCell.defaultCellDimensions.width - marginLeft

        return CGPoint(x: targetPositionX, y: 0)
    }
}
