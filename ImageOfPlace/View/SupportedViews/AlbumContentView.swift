//
//  AlbumContentView.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/14/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import UIKit
import RealmSwift

enum AlbumAction{
    case save, delete
}

class AlbumContentView: UIView, RequestServiceObserver{
    private var requestService = NetworkRequestService.shared
    private let collectionLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private var realm: Realm?
    
    var buttonsView = UIView()
    var actionButton = UIButton()
    var titleLabel = UILabel()
    var closeButton = UIButton()
    var selectedImage = UIImageView()
    var imageCollection: UICollectionView?
    
    var album: Album?
    var images = [UIImage]()
    var actionType: AlbumAction?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        requestService.attach(self)
        imageCollection = UICollectionView(frame: CGRect(), collectionViewLayout: collectionLayout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Support Functions
    private func setup(){
        do {
            realm = try Realm()
        } catch let error as NSError {
            print("Database cannot initiate")
            print(error.localizedDescription)
        }
        initViews()
        setupViews()
        setupConstraints()
    }
    
    private func initViews(){
        self.backgroundColor = .gray
        imageCollection?.backgroundColor = .darkGray
        selectedImage.backgroundColor = .lightGray
        
        collectionLayout.scrollDirection = .horizontal
        imageCollection?.dataSource = self
        imageCollection?.delegate = self
        imageCollection?.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeContentView), for: .touchUpInside)
        
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    func fillContent(from album: Album, action: AlbumAction){
        requestService.updateImages(by: album.id)
        self.album = album
        self.actionType = action
        self.titleLabel.text = album.title
        switch action {
        case .save:
            actionButton.setImage(UIImage(named: "save-icon"), for: .normal)
        case .delete:
            actionButton.setImage(UIImage(named: "Remove-icon"), for: .normal)
        }
    }
    //MARK: - Event Handlers
    @objc private func closeContentView(){
        self.isHidden = true
        print("closeContentView")
    }
    
    @objc private func buttonAction(){
        switch actionType {
        case .save:
            saveAlbum()
        case .delete:
            removeAlbum()
        case .none:
            break
        }
    }
    
    //MARK: - RequestServiceProtocol methods
    func update(subject: AlbumsRequestServiceProtocol) {
        if let id = album?.id{
            if let imgs = subject.images[id]{
                images = imgs
                imageCollection?.reloadData()
                selectedImage.image = imgs[0]
            }
        }
    }
    
    func saveAlbum(){
        if let db = realm, let album = album?.toStore(){
            do {
                try db.write {
                    if db.objects(StorableAlbum.self).filter("id == \(album.id)").count == 0{
                        db.add(album)
                    }                    
                }
            } catch let error as NSError {
                print("Album cannot saved: \(error.localizedDescription)")
            }
        }else{
            print("DB not exist")
        }
    }
    
    func removeAlbum(){
        if let db = realm, let album = album?.toStore(){
            do {
                try db.write {
                    db.delete(album)
                }
            } catch let error as NSError {
                print("Album cannot saved: \(error.localizedDescription)")
            }
        }else{
            print("DB not exist")
        }
    }
    
}

//MARK: - CollectionViewDataSource & Delegate
extension AlbumContentView: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection!.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.fillContent(with: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage.image = images[indexPath.row]
    }
}


//MARK: - Layout
extension AlbumContentView{
    private func setupViews(){
        self.addSubview(selectedImage)
        self.addSubview(imageCollection!)
        self.addSubview(buttonsView)
        
        buttonsView.addSubview(closeButton)
        buttonsView.addSubview(titleLabel)
        buttonsView.addSubview(actionButton)
    }
    
    private func setupConstraints(){
        buttonsView.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(8)
            $0.height.equalTo(48)
        })
        
        actionButton.snp.makeConstraints({
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(actionButton.snp.height)
        })
        
        titleLabel.snp.makeConstraints({
            $0.leading.equalTo(actionButton.snp.trailing).offset(16)
            $0.trailing.equalTo(closeButton.snp.leading).offset(16)
            $0.top.bottom.equalToSuperview().inset(4)
        })
        
        closeButton.snp.makeConstraints({
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(4)
            $0.width.equalTo(64)
        })
        
        selectedImage.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.top.equalTo(buttonsView.snp.bottom).offset(8)
            $0.height.equalToSuperview().multipliedBy(0.6)
        })
        
        imageCollection!.snp.makeConstraints({
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(8)
            $0.top.equalTo(selectedImage.snp.bottom).offset(16)
        })
    }
}
