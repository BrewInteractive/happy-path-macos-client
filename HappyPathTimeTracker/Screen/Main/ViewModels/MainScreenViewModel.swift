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
    var appState: AppState? = nil
    @Published var timers: [TimeEntry] = []
    @Published var projects: [Project] = []
    @Published var tasks: [ProjectTask] = []
    @Published var isLoading: Bool = false
    @Published var isRefetching: Bool = false
    @Published var isTasksLoading = false
    init() {
    }
    
    func updateViewModel(appState: AppState) {
        self.appState = appState
        self.getProjects()
    }
    
    func getProjects() {
        appState?.graphqlClient?.client?
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
                    if let error = error as? Apollo.ResponseCodeInterceptor.ResponseCodeError {
                        switch error {
                        case .invalidResponseCode(let response, _):
                            if response?.statusCode == 403 {
                                self.appState?.updateIsLoggedIn(newValue: false)
                            }
                        }
                    }
                }
            }
    }
    
    func getTimers(date: Date, onFinish: (() -> Void)? = nil, cachePolicy: CachePolicy? = nil) {
        
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
        
        appState?.graphqlClient?.client?
            .fetch(query: GetTimersQuery(startsAt: date.startOfDayISO, endsAt: date.endOfDayISO), cachePolicy: cachePolicy ?? .default) { result in
            switch result {
            case .success(let data):
                let tmpTimers: [TimeEntry] = data.data?.timers?.compactMap({ timer in
                    guard let timer = timer,
                          let id = timer.id,
                          let projectId = timer.project?.id,
                          let taskId = timer.task?.id else {
                        return nil
                    }
                    
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
        DispatchQueue.main.async { [weak self] in
            self?.isTasksLoading = true
        }
        appState?.graphqlClient?.client?
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
                        self?.isTasksLoading = false
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async { [weak self] in
                        self?.isTasksLoading = false
                    }
                }
            }
    }
    
    func refetch(date: Date) {
        DispatchQueue.main.async { [weak self] in
            self?.isRefetching = true
        }
        invalidateDateAndRefetch(date: date)
    }
    
    func logTimer(projectTaskId: Int, duration: Int, notes: String, date: Date, onSuccess: @escaping () -> Void) {
        appState?.graphqlClient?.client?
            .perform(mutation: LogTimerMutation(projectTasktId: projectTaskId,
                                                duration: duration,
                                                notes: notes,
                                                startsAt: date.startOfDayISO,
                                                endsAt: date.endOfDayISO)) { result in
            switch result {
            case .success:
                self.invalidateDateAndRefetch(date: date)
                onSuccess()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func removeTimer(id: Int, selectedDate: Date) {
        isLoading = true
        appState?.graphqlClient?.client?
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
            self.appState?.graphqlClient?.client?.store.withinReadWriteTransaction { t in
                try t.removeObjects(matching: "timers(endsAt:\(date.endOfDayISO),startsAt:\(date.startOfDayISO)")
            }
            self.getTimers(date: date, cachePolicy: .fetchIgnoringCacheData)
        }
    }
}
