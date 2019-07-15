//
//  Petition.swift
//  Project7
//
//  Created by Thiago Alves on 7/17/19.
//  Copyright © 2019 Thiago Alves. All rights reserved.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
