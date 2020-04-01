//
//  Game.swift
//  tapping-game
//
//  Created by Kevin Alemi on 2020-03-31.
//  Copyright © 2020 Kevin Alemi. All rights reserved.
//

import Foundation


class Game {
    
    // MARK: Properties
    var usrName: String
    var points: Int
    var x: Double
    var y: Double
    
    init?(usrName: String, points: Int, x: Double, y: Double){
        
        guard points > 0 else {
            fatalError("Points are less than 0, not possible")
            return nil
        }
        
        self.usrName = usrName
        self.points = points
        self.x = x
        self.y = y
    }
    
}
