//
//  ParsingStructs.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/13/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol ImageProtocol{
    var albumID: Int { get }
    var id: Int {get set}
    var title: String  {get}
    var url : String  {get}
    var thumbnailURL: String  {get}
}

//use for decode from newtwork
class Image: ImageProtocol, Decodable {
    var albumID: Int = 0
    var id: Int = 0
    var title: String = ""
    var url : String = ""
    var thumbnailURL: String = ""
    
    init(albumID: Int, id: Int, title: String, url: String, thumbnailURL: String){
        self.albumID = albumID
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailURL = thumbnailURL
    }
    
    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id, title, url
        case thumbnailURL = "thumbnailUrl"
    }
    
    func toStore() -> StoableImage{
        return StoableImage(albumID: albumID, id: id, title: title, url: url, thumbnailURL: thumbnailURL)
    }
}

//use to store in db
class StoableImage: Object, ImageProtocol{
    @objc dynamic var albumID: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var url : String = ""
    @objc dynamic var thumbnailURL: String = ""
    
    override init(){
        super.init()
    }
    
    init(albumID: Int, id: Int, title: String, url: String, thumbnailURL: String){
        self.albumID = albumID
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailURL = thumbnailURL
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toWeb() -> Image{
        return Image(albumID: albumID, id: id, title: title, url: url, thumbnailURL: thumbnailURL)
    }
}

typealias Albums = [Album]
typealias Images = [Image]



