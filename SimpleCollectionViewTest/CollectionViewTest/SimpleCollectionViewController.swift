//
//  ViewController.swift
//  CollectionViewTest
//
//  Created by yu++ on 2020/01/31.
//  Copyright © 2020 yu++. All rights reserved.
//

import UIKit


final class SimpleCollectionViewController: UIViewController {

    let contents: [(labelText: String, backgroundColor: UIColor)] = [
        ("Ferrari", .red),
        ("McLaren", .orange),
        ("RedBull", .systemIndigo),
    ]

    let mainCollectionView: UICollectionView = {
        let baseLayout = UICollectionViewFlowLayout()
        baseLayout.scrollDirection = .vertical
        baseLayout.minimumInteritemSpacing = 0
        baseLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: UIScreen.main.bounds.height
            ),
            collectionViewLayout: baseLayout
        )
        collectionView.backgroundColor = .darkGray
        // Cellクラス登録
        collectionView.register(CommonCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: CommonCollectionViewCell.self))

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self

        view.addSubview(mainCollectionView)
    }
}

/// MARK: - コレクションビューのセル毎のデータ設定
extension SimpleCollectionViewController: UICollectionViewDataSource {
    /// 個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        contents.count
    }

    /// セルのデータ設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        NSLog("\(String(describing: self))::\(#function)@line:\(#line) indexPath: \(indexPath)")
        let content = contents[indexPath.row]
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CommonCollectionViewCell.self), for: indexPath) as? CommonCollectionViewCell else {
            NSLog("\(String(describing: self))::\(#function)@line:\(#line) fatal")
            return UICollectionViewCell()
        }
        cell.centerLabel?.text = content.labelText
        cell.centerLabel?.backgroundColor = content.backgroundColor

        return cell
    }
}

/// MARK: - コレクションビューのイベントに対する設定
extension SimpleCollectionViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

/// MARK: - コレクションビューのレイアウト設定
extension SimpleCollectionViewController: UICollectionViewDelegateFlowLayout {
    /// セルの寸法を設定
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
