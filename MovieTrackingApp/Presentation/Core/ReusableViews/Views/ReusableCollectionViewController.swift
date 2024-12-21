//
//  ReusableCollectionViewController.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 21.12.24.
//

import UIKit

class ReusableCollectionView: UICollectionView {
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        configureCollection()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        self.collectionViewLayout = layout
        self.backgroundColor = .clear
        self.showsHorizontalScrollIndicator = false
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
