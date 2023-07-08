//
//  MainScreenViewModel.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import Foundation
import DirectusGraphql
import Apollo

class MainScreenViewModel: ObservableObject {
    let client = GraphqlClient()
    @Published var timers: [TimeEntry] = []
    @Published var isLoading: Bool = false
    
    init() {
    }
    
    func fetch(date: Date) {
        let startsAt = date.dateAtStartOf(.day).date.toISO()
        let endsAt = date.dateAtEndOf(.day).date.toISO()
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
        
        client.getClient()
            .fetch(query: GetTimersQuery(startsAt: startsAt, endsAt: endsAt)) { result in
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
    
    func refetch(date: Date) {
        let startsAt = date.dateAtStartOf(.day).date.toISO()
        let endsAt = date.dateAtEndOf(.day).date.toISO()
        
        DispatchQueue.global().async {
            self.client.getClient().store.withinReadWriteTransaction { t in
                try t.removeObjects(matching: "QUERY_ROOT.timers(endsAt:\(endsAt),startsAt:\(startsAt)")
            }
            self.fetch(date: date)
        }
    }
    
    func removeTimer(id: Int, selectedDate: Date) {
        let startsAt = selectedDate.dateAtStartOf(.day).date.toISO()
        let endsAt = selectedDate.dateAtEndOf(.day).date.toISO()
        
        isLoading = true
        client.getClient()
            .perform(mutation: RemoveTimerMutation(removeId: id)) { [weak self] result in
                switch result {
                case .success:
                    self?.timers = self?.timers.filter{$0.id != id} ?? []
                    self?.isLoading = false
                case .failure(let error):
                    print(error)
                    self?.isLoading = false
                }
            }
        DispatchQueue.global().async {
            self.client.getClient().store.withinReadWriteTransaction { t in
                try t.removeObjects(matching: "QUERY_ROOT.timers(endsAt:\(endsAt),startsAt:\(startsAt)")
            }
            self.fetch(date: selectedDate)
        }
        
    }
}
