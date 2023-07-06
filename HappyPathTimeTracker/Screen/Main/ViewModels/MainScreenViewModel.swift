//
//  MainScreenViewModel.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import Foundation
import DirectusGraphql

class MainScreenViewModel: ObservableObject {
    let client = GraphqlClient()
    @Published var timers: [TimeEntry] = []
    @Published var isLoading: Bool = false
    
    init() {
    }
    
    func fetch(date: Date) {
        let startsAt = date.dateAtStartOf(.day).date.toISO()
        let endsAt = date.dateAtEndOf(.day).date.toISO()
        let userId = "U02HJ0V77QU"
        
        isLoading = true
        client.getClient()
            .fetch(query: GetTimersQuery(startsAt: startsAt, endsAt: endsAt, userId: userId)) { result in
            switch result {
            case .success(let data):
                let tmpTimers: [TimeEntry] = data.data?.timers?.compactMap({ timer in
                    guard let timer = timer,
                          let id = timer.id,
                          let projectId = timer.project?.id,
                          let taskId = timer.task?.id else {
                        return nil
                    }
                    //TODO: total duration ve duration neye denk geliyor. Bu degerleri anlayarak elapsedTime i guncelle
                    return TimeEntry(id: id,
                                     projectId: projectId,
                                     projectName: timer.project?.name ?? "",
                                     taskId: taskId,
                                     taskName: timer.task?.name ?? "",
                                     notes: timer.notes ?? "",
                                     elapsedTime: 0)
                }) ?? []
                
                DispatchQueue.main.async { [weak self] in
                    self?.timers = tmpTimers
                    self?.isLoading = false
                }
            case .failure(let error):
                print("error: \(error)")
                DispatchQueue.main.async { [weak self] in
                    self?.timers = []
                    self?.isLoading = false
                }
            }
        }
    }
}
