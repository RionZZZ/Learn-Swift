//
//  MineFirstSectionCell.swift
//  News
//
//  Created by Rion on 2019/2/15.
//  Copyright © 2019年 Rion. All rights reserved.
//

import UIKit
import Kingfisher

class MineFirstSectionCell: UITableViewCell, RegisterCellOrNib {

    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    
    var concerns = [MineConcernModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var mineCell : MineCellModel? {
        didSet {
            self.leftLabel.text = mineCell?.text
            self.rightLabel.text = mineCell?.grey_text
        }
    }
    var mineConcern : MineConcernModel? {
        didSet {
            self.rightLabel.text = mineConcern?.name
            self.rightImage.kf.setImage(with: URL(string: (mineConcern?.icon)!))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.collectionViewLayout = MineConcernFlowLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView._registerCell(cell: MineConcernCell.self)
        
        leftLabel.theme_textColor = "colors.black"
        rightLabel.theme_textColor = "colors.cellRightTextColor"
        arrowImage.theme_image = "images.cellArrow"
        separator.theme_backgroundColor = "colors.separatorColor"
        topView.theme_backgroundColor = "colors.cellBackgroundColor"
        collectionView.theme_backgroundColor = "colors.cellBackgroundColor"
        theme_backgroundColor = "colors.cellBackgroundColor"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MineFirstSectionCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return concerns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView._dequeueReusableCell(indexPath: indexPath) as MineConcernCell
        cell.mineConcern = concerns[indexPath.item]
        return cell
    }
    
    
}

class MineConcernFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        itemSize = CGSize(width: 58, height: 74)//cell大小
        minimumLineSpacing = 0//横向间距
        minimumInteritemSpacing = 0//纵向间距
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)//cell四边间距
        scrollDirection = .horizontal//水平滚动
    }
}
