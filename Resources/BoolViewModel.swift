//
//  BoolViewModel.swift
//  Unibell
//
//  Created by hyunsuh ham on 7/27/24.
//

import Foundation

class BoolViewModel: ObservableObject {
    @Published var showMessage = false
    @Published var showTasks = false
    
    init() {}
    
}
