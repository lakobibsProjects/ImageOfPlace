//
//  ImageCollectionViewCell.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/18/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    var imageVIew = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fillContent(with image: UIImage){
        imageVIew.image = image
    }
    
    private func setup(){
        self.addSubview(imageVIew)
        imageVIew.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}
