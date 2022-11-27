//
//  ContentHandlers.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/25/22.
//

import Foundation


//removes nil string from seperating 
func customSep (str:String,sepBy:String) -> Array<String>{
    var res = str.components(separatedBy: sepBy)
    for (idx,el) in res.enumerated() {
        if el.count == 0 || el == "nil" {
            res.remove(at: idx)
        }
    }
    return res
}


