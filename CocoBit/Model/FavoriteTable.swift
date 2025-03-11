//
//  FavoriteTable.swift
//  CocoBit
//
//  Created by Sebin Kwon on 3/11/25.
//

import Foundation
import RealmSwift

class FavoriteTable: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var symbol: String
    @Persisted var image: String
    
    convenience init(id: String, name: String, symbol: String, image: String) {
        self.init()
        self.id = id
        self.name = name
        self.symbol = symbol
        self.image = image
    }
}
