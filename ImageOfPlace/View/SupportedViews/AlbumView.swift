//
//  AlbumView.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/14/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit
import SnapKit


class AlbumView: UIView {
    private var albums: Albums = []
    private var albumAction: AlbumAction?
    
    var albumsList: UITableView!
    var albumContent: AlbumContentView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Support Functions
    private func setup(){
        initViews()
        setupViews()
        setupConstraints()
    }
    
    private func initViews(){
        self.backgroundColor = .gray
        
        albumsList = UITableView()
        albumsList.dataSource = self
        albumsList.delegate = self
        albumsList.register(AlbumTableViewCell.self, forCellReuseIdentifier: "AlbumTableViewCell")
        albumsList.backgroundColor = .gray
        
        albumContent = AlbumContentView()
        albumContent.isHidden = true
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
    }
    
    func fillContent(from dataSource: AlbumsRequestServiceProtocol, action: AlbumAction){
        self.albums = dataSource.albums
        albumsList.reloadData()
        self.albumAction = action
    }   
}


extension AlbumView{
    private func setupViews(){
        self.addSubview(albumsList)
        self.addSubview(albumContent)
    }
    
    private func setupConstraints(){
        albumsList.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.top.equalToSuperview()
        })
        
        albumContent.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
}

//MARK: - UITableViewDelegate & DataSource
extension AlbumView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumsList.dequeueReusableCell(withIdentifier: "AlbumTableViewCell") as! AlbumTableViewCell
        cell.configureCell(with: albums[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        albumContent.fillContent(from: albums[indexPath.row], action: self.albumAction ?? .save)
        albumContent.isHidden = false
        albumsList.deselectRow(at: indexPath, animated: true)
    }
}
