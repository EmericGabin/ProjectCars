//
//  Car.swift
//  Cars
//
//  Created by emeric on 10/02/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct Car: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var marque: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case marque

      }
}
