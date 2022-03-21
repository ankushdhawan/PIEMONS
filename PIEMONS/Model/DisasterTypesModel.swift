//
//  disasterTypes.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/19/22.
//

import Foundation
class DisasterTypesModel{
    var type:DisasterTypes = .landslide
    var isSelected:Bool = false
    init(type:DisasterTypes){
        self.type = type
    }
}

enum DisasterTypes:String{
    case landslide = "Landslide"
    case flood = "Flood"
    case drought = "Drought"
    case earthquake = "Earthquake"
    case fire = "Fire"
    case others = "Others"
}
