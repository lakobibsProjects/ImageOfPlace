//
//  AlbumTableViewCell.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/13/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit
import SnapKit

class AlbumTableViewCell: UITableViewCell {
    var previewView = UIImageView()
    var title = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .lightGray
        self.layer.cornerRadius = 8
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///Configure content of cell
    ///
    /// - Parameter with: tupple with date of represent day and health balance
    func configureCell(with data: Album){
        title.text = data.title
        previewView.image = data.thumblnail
    }
    
    //MARK: - Support Functions
    ///setup all views
    private func setup(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    ///initialization and set default state for view and each subview
    private func initViews(){
        
    }
    
    ///setup hierarchy of views
    private func setupViews(){
        self.addSubview(previewView)
        self.addSubview(title)
    }
    
    ///set constraints for all views
    private func setupConstraints(){
        previewView.snp.makeConstraints({
            $0.leading.top.bottom.equalToSuperview().inset(4)
            $0.height.equalTo(48)
            $0.width.equalTo(previewView.snp.height)
        })
        
        title.snp.makeConstraints({
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalTo(previewView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
        })
    }
}
