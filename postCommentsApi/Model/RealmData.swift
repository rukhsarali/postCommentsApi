//
//  RealmData.swift
//  postCommentsApi
//
//  Created by Rukhsar on 26/08/2020.
//  Copyright © 2020 Rukhsar. All rights reserved.
//

import Foundation
import RealmSwift

class RealmData : Object {
    @objc dynamic var realmPostTitle : String = ""
    @objc dynamic var realmPostBody : String = ""
}

class RealmCommentData: Object {
    @objc dynamic var realmCommentBody : String = ""
}
