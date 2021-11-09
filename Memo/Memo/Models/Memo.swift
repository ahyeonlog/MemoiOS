//
//  Memo.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/09.
//

import Foundation
import RealmSwift

class Memo: Object {
    @Persisted var title: String
    @Persisted var content: String
    @Persisted var createdAt: Date
    @Persisted(primaryKey: true) var _id: ObjectId
    
    convenience init(title: String, content: String) {
        self.init()
        self.title = title
        self.content = content
        self.createdAt = Date()
    }
}
