//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by Fai Wu on 10/26/17.
//  Copyright © 2017 Fai Wu. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void){
    DispatchQueue.main.async {
        updates()
    }
}
