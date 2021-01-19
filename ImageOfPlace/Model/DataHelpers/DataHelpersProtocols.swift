//
//  DataHelpersProtocols.swift
//  ImageOfPlace
//
//  Created by user166683 on 1/19/21.
//  Copyright © 2021 Lakobib. All rights reserved.
//

import Foundation
import UIKit

protocol AlbumsRequestServiceProtocol: RequestServiceObservable{
    var albums: Albums {get}
    var images: Dictionary<Int, [UIImage]>{get}
    
    func updateImages(by id: Int)
    func updateAlbums()
}

protocol RequestServiceObservable{
    func attach(_ observer: RequestServiceObserver)
    
    func detach(subscriber filter: (RequestServiceObserver) -> (Bool))
}

protocol RequestServiceObserver{
    func update(subject: AlbumsRequestServiceProtocol)
}
