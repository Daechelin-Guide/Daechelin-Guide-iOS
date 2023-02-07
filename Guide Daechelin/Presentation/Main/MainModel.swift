//
//  MainModel.swift
//  Guide Daechelin
//
//  Created by 이민규 on 2023/02/07.
//

import Foundation

struct MealData: Decodable {
    var data: Data
}

struct Data: Decodable {
    var date: String
    var breakfast: String?
    var dinner: String?
    var lunch: String?
}
