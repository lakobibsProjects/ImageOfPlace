//
//  RequestService.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/13/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class NetworkRequestService: AlbumsRequestServiceProtocol{
    private let albumsStringURL = "https://jsonplaceholder.typicode.com/albums"
    private let imagesPrefixStringURL = "https://jsonplaceholder.typicode.com/photos?albumId="
    private var thread = DispatchQueue.global(qos: .userInitiated)
    private lazy var observers = [RequestServiceObserver]()
    private var albumsIsLoaded: Bool {
        didSet{
            thread.async {
                self.addThumbnails()
            }
        }
    }
    var albums: Albums
    var images = Dictionary<Int, [UIImage]>()
    
    static var shared: NetworkRequestService = {
        let instance = NetworkRequestService()
        return instance
    }()
    
    
    private init() {
        albums = Albums()
        albumsIsLoaded = false
    }
    
    //MARK: - AlbumsRequestServiceProtocol methods
    func updateAlbums(){
        let request = AF.request(albumsStringURL)
        thread.async{
            request.responseJSON(completionHandler: { response in
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let albumRequest = try decoder.decode(Albums.self, from: data)
                    self.albums = albumRequest
                    DispatchQueue.main.async {
                        self.albumsIsLoaded = true
                        self.notify()
                    }
                    
                } catch let error {
                    print(error)
                }
            })
        }
    }
    
    func updateImages(by id: Int){
        if images[id] == nil{
            self.images[id] = []
            thread.async{
                let request = AF.request("\(self.imagesPrefixStringURL)\((id))")
                request.responseJSON(completionHandler: { response in
                    guard let data = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let imageRequest = try decoder.decode(Images.self, from: data)
                        for image in imageRequest{
                            if let url = URL(string: image.url){
                                if let data = try? Data(contentsOf: url) {
                                    if let image = UIImage(data: data) {
                                        self.images[id]?.append(image)
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.notify()
                        }
                    } catch let error {
                        print(error)
                    }
                })
                
            }
        }
    }
    
    //MARK: - Support Functions
    //TODO: fix holding application
    private func addThumbnails(){
        thread.async {
            for i in 0..<self.albums.count{
                let thumbnailRequest = AF.request("\(self.imagesPrefixStringURL)\((self.albums[i].id))")
                thumbnailRequest.responseJSON(completionHandler: { response in
                    guard let data = response.data else { return }
                    do {
                        let decoder = JSONDecoder()
                        let imagesRequest = try decoder.decode(Images.self, from: data)
                        if let url = URL(string: imagesRequest[0].thumbnailURL){
                            if let data = try? Data(contentsOf: url) {
                                if let image = UIImage(data: data) {
                                    self.albums[i].thumblnail = image
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.notify()
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                })
                
            }
        }
        
    }
}

//MARK: - Observable
extension NetworkRequestService: RequestServiceObservable{
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


