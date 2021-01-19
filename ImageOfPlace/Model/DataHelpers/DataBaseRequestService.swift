//
//  DataBaseRequestService.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/19/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class DatabaseAlbumsRequestService: AlbumsRequestServiceProtocol{
    var albums: Albums
    var images: Dictionary<Int, [UIImage]>
    private var db: Realm?
    private lazy var observers = [RequestServiceObserver]()
    
    static var shared: DatabaseAlbumsRequestService = {
        let instance = DatabaseAlbumsRequestService()
        return instance
    }()
    
    
    private init() {
        albums = []
        images = [:]
        do {
            db = try Realm()
        } catch let error as NSError {
            print("Database cannot initiate")
            print(error.localizedDescription)
        }
    }
    
    func updateImages(by id: Int) {
        print("not supported yet")
    }
    
    func updateAlbums() {
        if let data = self.db?.objects(StorableAlbum.self){
            for album in data{
                self.albums.append(album.toWeb())
            }
            print("Check: \(self.albums)")
        }
        DispatchQueue.main.async {
            self.notify()
        }        
    }
}



//MARK: - Observable
extension DatabaseAlbumsRequestService: RequestServiceObservable{
    ///Add subscriber
    ///
    /// - Parameter _: subscriber to add
    func attach(_ observer: RequestServiceObserver) {
        observers.append(observer)
    }
    
    ///Remove subscriber
    ///
    /// - Parameter subscriber: subscriber to remove
    func detach(subscriber filter: (RequestServiceObserver) -> (Bool)) {
        guard let index = observers.firstIndex(where: filter) else { return }
        observers.remove(at: index)
    }
    
    ///Notify all observers about changes
    func notify() {
        observers.forEach({ $0.update(subject: self)})
    }
}
