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
    @Published var isNewEntryModalShown = false
    @Published var editedTimerItemId: Int? = nil
    
    func updateViewModel(appState: AppState) {
        self.appState = appState
        self.getProjects()
    }
    
    func getProjects() {
        appState?.graphqlClient?.client?
            .fetch(query: GetProjectsQuery()) { [weak self] result in
                switch result {
                case .success(let res):
                    let tmpProjects = self?.parseProjects(from: res) ?? []
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.projects = tmpProjects
                    }
                case .failure(let error):
                    self?.parseError(for: error)
                }
            }
    }
    
    func getTimers(date: Date, cachePolicy: CachePolicy = .default, onFinish: (() -> Void)? = nil) {
        self.isLoading = true
        
        appState?.graphqlClient?.client?
            .fetch(query: GetTimersQuery(startsAt: date.startOfDayISO, endsAt: date.endOfDayISO), cachePolicy: cachePolicy) { [weak self] result in
            switch result {
            case .success(let res):
                let tmpTimers = self?.parseTimers(from: res) ?? []
                
                DispatchQueue.main.async { [weak self] in
                    self?.timers = tmpTimers
                    self?.isLoading = false
                    onFinish?()
                }
            case .failure(let error):
                self?.parseError(for: error)
                DispatchQueue.main.async { [weak self] in
                    self?.timers = []
                    self?.isLoading = false
                    onFinish?()
                }
            }
        }
    }
    
    func getTasks(projectId: Int) {
        self.isTasksLoading = true
        appState?.graphqlClient?.client?
            .fetch(query: GetTasksQuery(projectId: projectId)) { [weak self] result in
                switch result {
                case .success(let res):
                    let tmpTasks = self?.parseTasks(from: res)
                    DispatchQueue.main.async { [weak self] in
                        self?.tasks = tmpTasks ?? []
                        self?.isTasksLoading = false
                    }
                case .failure(let error):
                    self?.parseError(for: error)
                    DispatchQueue.main.async { [weak self] in
                        self?.isTasksLoading = false
                    }
                }
            }
    }
    
    func refetch(date: Date) {
        self.isRefetching = true
        self.getTimers(date: date, cachePolicy: .fetchIgnoringCacheData)
    }
    
    func logTimer(projectTaskId: Int, duration: Int, notes: String, date: Date, onSuccess: @escaping () -> Void) {
        self.isLoading = true
        appState?.graphqlClient?.client?
            .perform(mutation: LogTimerMutation(projectTasktId: projectTaskId,
                                                duration: duration,
                                                notes: notes,
                                                startsAt: date.startOfDayISO,
                                                endsAt: date.startOfDayISO)) { [weak self] result in
            switch result {
            case .success:
                self?.getTimers(date: date, cachePolicy: .fetchIgnoringCacheData)
                onSuccess()
            case .failure(let error):
                self?.parseError(for: error)
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
    }
    
    func updateTimer(projectTaskId: Int,
                     duration: Int,
                     notes: String,
                     startsAt: String,
                     endsAt: String,
                     onSuccess: @escaping () -> Void) {
        
        guard let date = startsAt.toISODate()?.date, let editedTimeItemId = editedTimerItemId else {
            return
        }
        self.isLoading = true
        appState?.graphqlClient?.client?
            .perform(mutation: UpdateTimerMutation(timerId: editedTimeItemId,
                                                   duration: GraphQLNullable<Int>(integerLiteral: duration),
                                                   startsAt: .some(startsAt),
                                                   endsAt: .some(endsAt),
                                                   notes: .some(notes))) { [weak self] result in
            switch result {
            case .success:
                self?.getTimers(date: date, cachePolicy: .fetchIgnoringCacheData)
                onSuccess()
            case .failure(let error):
                self?.parseError(for: error)
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
    }
    
    func removeTimer(id: Int, selectedDate: Date) {
        self.isLoading = true
        appState?.graphqlClient?.client?
            .perform(mutation: RemoveTimerMutation(removeId: id)) { [weak self] result in
                switch result {
                case .success:
                    self?.timers = self?.timers.filter{$0.id != id} ?? []
                    DispatchQueue.main.async {
                        self?.isLoading = false
                    }
                case .failure(let error):
                    self?.parseError(for: error)
                    DispatchQueue.main.async {
                        self?.isLoading = false
                    }
                }
            }
        self.getTimers(date: selectedDate, cachePolicy: .fetchIgnoringCacheData)
    }
    
    func showEditTimerModal(editedTimerId: Int) {
        self.isNewEntryModalShown = true
        self.editedTimerItemId = editedTimerId
    }
    
    func showNewEntryTimerModal() {
        self.isNewEntryModalShown = true
        self.editedTimerItemId = nil
    }
    
    func getEditedTimer() -> TimeEntry? {
        return self.timers.first(where: {$0.id == editedTimerItemId})
    }
    
    private func parseError(for error: Error) {
        print(error)
        if let error = error as? Apollo.ResponseCodeInterceptor.ResponseCodeError {
            switch error {
            case .invalidResponseCode(let response, _):
                if response?.statusCode == 403 {
                    self.appState?.updateIsLoggedIn(newValue: false)
                }
            }
        }
    }
    
    private func parseTasks(from res: GraphQLResult<GetTasksQuery.Data>) -> [ProjectTask] {
        return res.data?.tasks?.compactMap({ task in
            guard let id = task?.id, let name = task?.taskName else {
                return nil
            }
            return ProjectTask(id: Int(id)!, name: name)
        }) ?? []
    }
    
    private func parseProjects(from res: GraphQLResult<GetProjectsQuery.Data>) -> [Project] {
        return res.data?.projects?.compactMap({ project in
            guard let id = project?.id, let name = project?.projectName else {
                return nil
            }
            
            return Project(id: Int(id)!, name: name)
        }) ?? []
    }
    
    private func parseTimers(from res: GraphQLResult<GetTimersQuery.Data>) -> [TimeEntry] {
        return res.data?.timers?.compactMap({ timer in
            guard let timer = timer,
                  let id = timer.id,
                  let projectId = timer.project?.id,
                  let taskId = timer.task?.id,
                  let startsAt = timer.startsAt,
                  let endsAt = timer.endsAt else {
                return nil
            }
            
            return TimeEntry(id: id,
                             projectId: projectId,
                             projectName: timer.project?.name ?? "",
                             taskId: taskId,
                             taskName: timer.task?.name ?? "",
                             notes: timer.notes ?? "",
                             startsAt: startsAt,
                             endsAt: endsAt,
                             totalDuration: timer.totalDuration ?? 0)
        }) ?? []
    }
}
