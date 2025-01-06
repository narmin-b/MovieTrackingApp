//
//  HomeLayouts.swift
//  MovieTrackingApp
//
//  Created by Narmin Baghirova on 27.12.24.
//

import Foundation
import UIKit

final class HomeCollectionLayout {
    func titlesSegmentSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(48)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 4,
            bottom: 0,
            trailing: 4
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 8,
            trailing: 0
        )
        section.orthogonalScrollingBehavior = .continuous

        return section
    }
        
    func trendingSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute((UIScreen.current.bounds.width) * 0.6),
            heightDimension: .absolute((UIScreen.current.bounds.width) * 0.6 + 48)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 4,
            leading: 8,
            bottom: 4,
            trailing: 4
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 4,
            leading: 8,
            bottom: 0,
            trailing: 8
        )
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(32)),
                elementKind: "UICollectionElementKindSectionHeader",
                alignment: .top
            ),
        ]
//        section.visibleItemsInvalidationHandler = { items, contentOffset, environment in
//            let center = contentOffset.x + environment.container.contentSize.width / 2
//            for item in items {
//                let distanceFromCenter = abs(item.frame.midX - center)
//                let scale = max(0.85, 1 - (distanceFromCenter / environment.container.contentSize.width))
//                item.transform = CGAffineTransform(scaleX: scale, y: scale)
//            }
//        }
        return section
    }
    
    func titlesSection()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute((UIScreen.main.bounds.width) * 0.35),
            heightDimension: .absolute((UIScreen.main.bounds.width) * 0.6)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 4,
            bottom: 4,
            trailing: 4
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 4,
            bottom: 4,
            trailing: 4
        )
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [
            .init(
                layoutSize: .init(widthDimension: .fractionalWidth(1),
                                  heightDimension: .absolute(32)),
                elementKind: "UICollectionElementKindSectionHeader",
                alignment: .top
            ),
        ]
        
        return section
    }
}
