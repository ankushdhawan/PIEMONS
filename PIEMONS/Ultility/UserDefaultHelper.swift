//
//  UserDefaultHelper.swift
//  Rider
//
//  Created by Mac mini on 10/5/18.
//  Copyright © 2018 Mac mini. All rights reserved.
//

import UIKit

private enum Defaults: String {
   
    case userToken = "token"
}

final class UserDefaultHelper {
    
    static var userToken: String? {
        set{
            _set(value: newValue, key: .userToken)
        } get {
            return _get(valueForKay: .userToken) as? String
        }
    }
    
    
    private static func _set(value: Any?, key: Defaults) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }
    
    private static func _get(valueForKay key: Defaults)-> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
    
    private static func _delete(valueForKay key: Defaults) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
   
    
    
}


