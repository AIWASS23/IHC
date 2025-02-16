//
//  Course.swift
//  IHC
//
//  Created by Marcelo De Araújo on 16/02/25.
//

import SwiftUI

struct Course: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let duration: String
    let days: String
    let shift: String
    let workload: String
    let teacher: String
}
