//
//  MainScreenVm.swift
//  BHappyWatch Watch App
//
//  Created by Gorkem Sevim on 23.06.2024.
//

import Foundation
import SwiftUI

final class MainScreenVm: ObservableObject {
    @Published var timers: [Timer] = []
    @Published var isLoading = false
    
    func getTimers(token: String) async {
        do {
            isLoading = true
            print("loading true")
            if let response = try await Requests.getTimers(token: token) {
                timers = response.data.timers
            }
            isLoading = false
            print("loading false")
            
        } catch {
            print("Error: \(error)")
        }
    }
}
