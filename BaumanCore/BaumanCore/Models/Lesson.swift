//
//  Lesson.swift
//  BaumanCore
//
//  Created by Иван Агошков on 22.11.2025.
//
import Foundation
import SwiftUI

struct Lesson: Identifiable {
    let id = UUID()
    let title: String
    let date: String
    let status: String
    let statusColor: Color
}


