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
    var week: String?
}

struct MenuData: Decodable {
    var breakfast: String?
    var lunch: String?
    var dinner: String?
}

struct StarData: Decodable {
    var star: Double?
    var menu: String?
    var date: String?
}

struct CommentData: Decodable {
    var commentId: Int?
    var message: String?
    var date: String?
    var menu: String?
    var createdDate: String?
}

