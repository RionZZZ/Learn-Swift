//
//  Calculate.swift
//  News
//
//  Created by Rion on 2019/2/26.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit

protocol Calculatable {
    
    static func collectionViewWidth(_ count: Int) -> CGFloat
    
    static func collectionViewHeight(_ count: Int) -> CGFloat
    
    static func collectionCellSize(_ count: Int) -> CGSize
    
}

struct Calculate: Calculatable { }

extension Calculate {
    
    static func collectionViewWidth(_ count: Int) -> CGFloat {
        switch count {
        case 1:
            return image1Width
        case 2:
            return (image2Width + 5) * 2
        case 3,5...9:
            return screenWidth - 30
        case 4:
            return (image3Width + 5) * 2
        default:
            return 0
        }
    }
    
    static func collectionViewHeight(_ count: Int) -> CGFloat {
        switch count {
        case 1:
            return image1Width
        case 2:
            return image2Width
        case 3:
            return image3Width + 5
        case 4...6:
            return (image3Width + 5) * 2
        case 7...9:
            return (image3Width + 5) * 3
        default:
            return 0
        }
    }
    
    static func collectionCellSize(_ count: Int) -> CGSize {
        switch count {
        case 1:
            return CGSize(width: image1Width, height: image1Width)
        case 2:
            return CGSize(width: image2Width, height: image2Width)
        case 3...9:
            return CGSize(width: image3Width, height: image3Width)
        default:
            return .zero
        }
    }
    
    
}
