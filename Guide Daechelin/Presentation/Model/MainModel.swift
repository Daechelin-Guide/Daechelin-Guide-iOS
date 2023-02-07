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

struct MenuData: Decodable {
    var breakfast: String?
    var lunch: String?
    var dinner: String?
}

struct StarData: Decodable {
    var star: Int?
    var menu: String?
    var date: String?
}
