//
//  FileManager - Document.swift
//  BucketList
//
//  Created by tuananhdo on 02/10/2023.
//

import Foundation


extension FileManager {
    
    static var Documentdirectory : URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
        
    }
    
}
