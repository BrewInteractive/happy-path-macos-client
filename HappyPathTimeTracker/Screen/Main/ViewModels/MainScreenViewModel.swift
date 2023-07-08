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
    @Published var projects: [Project] = []
    @Published var tasks: [ProjectTask] = []
    @Published var isLoading: Bool = false
    @Published var isRefetching: Bool = false
    
    init() {
        getProjects()
    }
    
    func getProjects() {
        client.getClient()
            .fetch(query: GetProjectsQuery()) { result in
                switch result {
                case .success(let res):
                    let tmpProjects: [Project] = res.data?.projects?.compactMap({ project in
                        guard let id = project?.id, let name = project?.projectName else {
                            return nil
                        }
                        
                        return Project(id: Int(id)!, name: name)
                    }) ?? []
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.projects = tmpProjects
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func getTimers(date: Date, onFinish: (() -> Void)? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
        
        client.getClient()
            .fetch(query: GetTimersQuery(startsAt: date.startOfDayISO, endsAt: date.endOfDayISO)) { result in
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
                                     totalDuration: timer.totalDuration ?? 0)
                }) ?? []
                
                DispatchQueue.main.async { [weak self] in
                    self?.timers = tmpTimers
                    self?.isLoading = false
                    onFinish?()
                }
            case .failure(let error):
                print("error: \(error)")
                DispatchQueue.main.async { [weak self] in
                    self?.timers = []
                    self?.isLoading = false
                    onFinish?()
                }
            }
        }
    }
    
    func getTasks(projectId: Int) {
        client.getClient()
            .fetch(query: GetTasksQuery(projectId: projectId)) { result in
                switch result {
                case .success(let res):
                    let tmpTasks: [ProjectTask] = res.data?.tasks?.compactMap({ task in
                        guard let id = task?.id, let name = task?.taskName else {
                            return nil
                        }
                        return ProjectTask(id: Int(id)!, name: name)
                    }) ?? []
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.tasks = tmpTasks
                    }
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func refetch(date: Date) {
        DispatchQueue.main.async { [weak self] in
            self?.isRefetching = true
        }
        invalidateDateAndRefetch(date: date)
        self.getTimers(date: date) {
            self.isRefetching = false
        }
    }
    
    func logTimer(projectTaskId: Int, duration: Int, notes: String, date: Date) {
        client.getClient()
            .perform(mutation: LogTimerMutation(projectTasktId: projectTaskId,
                                                duration: duration,
                                                notes: notes,
                                                startsAt: date.startOfDayISO,
                                                endsAt: date.endOfDayISO)) { result in
            switch result {
            case .success:
                self.invalidateDateAndRefetch(date: date)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeTimer(id: Int, selectedDate: Date) {
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
        invalidateDateAndRefetch(date: selectedDate)
    }
    
    private func invalidateDateAndRefetch(date: Date) {
        
        DispatchQueue.global().async {
            self.client.getClient().store.withinReadWriteTransaction { t in
                try t.removeObjects(matching: "QUERY_ROOT.timers(endsAt:\(date.endOfDayISO),startsAt:\(date.startOfDayISO)")
            }
            self.getTimers(date: date)
        }
    }
}
