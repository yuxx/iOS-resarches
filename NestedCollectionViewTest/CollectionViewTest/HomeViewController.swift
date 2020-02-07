//
//  Created by yu++ on 2020/01/31.
//  Copyright © 2020 yu++. All rights reserved.
//

import UIKit


final class HomeViewController: UIViewController {

    let cellTypes: [(cellType: String, contents: [(labelText: String, bgColor: UIColor)])] = [
        ("Recommend", [
            ("1", .red),
            ("2", .magenta),
            ("3", .yellow),
            ("4", .darkGray),
            ("5", .green),
            ("6", .purple),
            ("7", .white),
            ("8", .cyan),
            ("9", .blue),
            ("10", .orange),
        ]),
        ("Recommend", [
            ("Mercedes", .cyan),
            ("Ferrari", .red),
            ("McLaren", .orange),
            ("RedBull", .purple),
            ("Williams", .white),
        ]),
        ("Recommend", [
            ("Imora", .green),
            ("Silverstone", .white),
            ("A1rink", .red),
        ]),
        ("Recommend", [
            ("Italy", .red),
            ("United Kingdom", .green),
            ("Austria", .white),
        ]),
    ]

    let mainCollectionView: UICollectionView = {
        let baseLayout = UICollectionViewFlowLayout()
        baseLayout.scrollDirection = .vertical
        baseLayout.minimumInteritemSpacing = 0
        baseLayout.minimumLineSpacing = 0

        let verticalCollectionView = UICollectionView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            ),
            collectionViewLayout: baseLayout
        )
        verticalCollectionView.backgroundColor = .systemBlue
        verticalCollectionView.showsVerticalScrollIndicator = false
        // Cellクラス登録
        verticalCollectionView.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: HorizontalCollectionViewCell.self))

        return verticalCollectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        NSLog("\(String(describing: Self.self))::\(#function)@line:\(#line)"
            + "\nUIScreen.main.bounds: \(UIScreen.main.bounds)"
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        view.addSubview(mainCollectionView)
    }
}

/// MARK: - コレクションビューのセル毎のデータ設定
extension HomeViewController: UICollectionViewDataSource {
    /// セル個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NSLog("\(String(describing: Self.self))::\(#function)@line:\(#line) section: \(section)")
        return cellTypes.count
    }

    /// セルのデータ設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HorizontalCollectionViewCell.self), for: indexPath) as? HorizontalCollectionViewCell else {
            NSLog("\(String(describing: Self.self))::\(#function)@line:\(#line) fatal")
            return UICollectionViewCell()
        }
        let currentCellType = cellTypes[indexPath.row]
        cell.contents = currentCellType.contents
        if indexPath.row % 2 == 0 {
            if let layout = cell.horizontalScrollCollectionView.collectionViewLayout.collectionView?.collectionViewLayout as? HorizontalScrollCollectionViewFlowLayout {
                layout.isNeedAdjustScrollToCenterRow = true
            }
        }

        return cell
    }
}

/// MARK: - コレクションビューのイベントに対する設定
extension HomeViewController: UICollectionViewDelegate {
}

/// MARK: - コレクションビューのレイアウト設定
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    /// セルの寸法を設定
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // todo: 一旦統一
        CGSize(width: UIScreen.main.bounds.width, height: HorizontalCollectionViewCell.defaultCellFrame.height)
    }
}
