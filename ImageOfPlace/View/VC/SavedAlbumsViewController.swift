//
//  SavedAlbumsViewController.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/14/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit

class SavedAlbumsViewController: UIViewController {
    private var requestService = DatabaseAlbumsRequestService.shared
    
    var titleView: UIView!
    var titleLabel: UILabel!
    
    var albumView: AlbumView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestService.attach(self)
        
        self.view.backgroundColor = .gray
        requestService.updateAlbums()
        setup()
    }
    
    //MARK: - Support Functions
    ///setup all views
    private func setup(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    private func initViews(){
        titleView = UIView()
        titleLabel = UILabel()
        titleLabel.text = "Saved Albums"
        titleLabel.textAlignment = .center
        titleLabel.textColor = .green
        
        albumView = AlbumView()
    }
}

//MARK: Layout
extension SavedAlbumsViewController{
    private func setupViews(){
        self.view.addSubview(titleView)
        self.view.addSubview(albumView)
        
        titleView.addSubview(titleLabel)
    }
    
    private func setupConstraints(){
        titleView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(64)
            $0.height.equalTo(48)
        })
        
        titleLabel.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(8)
        })
        
        albumView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(titleView.snp.bottom).offset(8)
            $0.bottom.equalToSuperview().inset(128)
        })
    }
}

extension SavedAlbumsViewController: RequestServiceObserver{
    func update(subject: AlbumsRequestServiceProtocol) {
        albumView.fillContent(from: requestService, action: .delete)
    }
}

