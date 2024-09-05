//
//  Types.swift
//  Listify
//

import Foundation
import UIKit

struct ListInfo:Identifiable, Codable, Hashable{
    static func == (lhs: ListInfo, rhs: ListInfo) -> Bool {
        return lhs.documentId == rhs.documentId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.documentId?.hashValue)
    }
    
    var id:String = "\(UUID())"
    var name:String
    var category: String
    var items: [ListItem]?
    var date: Int?
    
    init(name: String, category:String, items: [ListItem]? = nil, date: Int? = nil){
        self.name = name
        self.category = category
        self.items = items
        self.date = date
    }
  
    
    var documentId: String?

    
     init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.category = try container.decode(String.self, forKey: .category)
        self.items = (try? container.decodeIfPresent([ListItem].self, forKey: .items)) ?? []
        self.date = try? container.decodeIfPresent(Int.self, forKey: .date)
        self.documentId = try container.decodeIfPresent(String.self, forKey: .documentId)
    }
    
    enum CodingKeys: CodingKey {
        case name
        case category
        case items
        case date
        case documentId
    }
}

struct ListItem: Identifiable, Codable{
    var id:String = "\(UUID())"
    var imageUrl: String?
    var image: UIImage?
    var title: String
    var quantity: Int
//    var documentId: String?
    
    enum CodingKeys: CodingKey {
        case id
        case imageUrl
        case title
        case quantity
//        case documentId
    }
}
