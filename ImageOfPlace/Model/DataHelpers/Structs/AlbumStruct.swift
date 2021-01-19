//
//  AlbumStruct.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/19/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

protocol AlbumProtocol {
    var userID: Int { get }
    var id: Int {get set}
    var title: String { get }
    var thumblnail: UIImage? {get set}
}

//use to decode ferom network
class Album:  AlbumProtocol, Decodable {
    var userID: Int
    var id: Int
    var title: String
    var thumblnail: UIImage?
    
    init(userId: Int, id: Int, title:  String, thumblnail: UIImage?){
        self.userID = userId
        self.id = id
        self.title = title
        self.thumblnail = thumblnail
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title
    }
    
    func toStore() -> StorableAlbum{
        return StorableAlbum(userId: userID, id: id, title: title, thumblnail: thumblnail)
    }
}

//use to store in db
class StorableAlbum: Object, AlbumProtocol{
    @objc dynamic var userID: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    var thumblnail: UIImage?
    
    override init(){
        super.init()
    }
    
    init(userId: Int, id: Int, title:  String, thumblnail: UIImage?){
        self.userID = userId
        self.id = id
        self.title = title
        self.thumblnail = thumblnail
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func toWeb() -> Album{
        return Album(userId: userID, id: id, title: title, thumblnail: thumblnail)
    }
}
