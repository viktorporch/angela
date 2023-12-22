//
//  MessageModel.swift
//  FlashChat
//
//  Created by Victor on 22.12.2023..
//

import Foundation

enum MessageType: String {
    case income, outcome
}

struct MessageModel {
    let sender: String
    let body: String
    let type: MessageType
}
