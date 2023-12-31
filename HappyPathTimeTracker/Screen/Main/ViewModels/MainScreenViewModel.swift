//
//  MainScreenViewModel.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 1.07.2023.
//

import Foundation
import DirectusGraphql
import Apollo
import Combine

enum HappyError: Error {
    case notFoundProject
    case errorFromBackend
}

final class MainScreenViewModel: ObservableObject {
    var networkManager: NetworkSource
    
    @Published private(set) var appState: AppState? = nil
    @Published var email: String = ""
    @Published var timers: [TimeEntry] = []
    @Published var projects: [Project] = []
    @Published var tasks: [ProjectTask] = []
    @Published var isLoading: Bool = false
    @Published var isTasksLoading = false
    @Published var selectedDate = Date.now
    @Published var isNewEntryModalShown = false
    @Published var editedTimerItemId: Int? = nil
    @Published var activeTimerSeconds: Double = 0.0
    @Published var todayTotalDurationWithActiveTimer: String = "00:00"
    @Published var thisWeekDurationWithActiveTimer: String = "00:00"
    @Published var thisMonthDurationWithActiveTimer: String = "00:00"
    @Published var totalDurationMap: [String: Int] = [:]
    @Published var stats: Stats? = nil
    @Published var isErrorShown = false
    let previousMonthLastWeekStartDate: Date
    
    private var timer: AnyCancellable? = nil
    var activeTimerId: Int? {
        return timers.first(where: {$0.endsAt == nil})?.id
    }
    
    init(networkSource: NetworkSource) {
        self.networkManager = networkSource
        // first monday of last month of last week
        let now = Date.now
        previousMonthLastWeekStartDate = (now
            .dateBySet([.month : now.month - 1])?
            .dateAtEndOf(.month)
            .dateAtStartOf(.weekOfMonth).date)!
    }
    
//    func logout() {
//        appState?.logout()
//    }
    
    func updateViewModel(appState: AppState) async {
        self.updateMainScreenVmProp(for: \.appState, newValue: appState)
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        do {
            async let tmpProjects = networkManager.fetchProjects(graphqlClient: appState.graphqlClient)
            async let tmpTimers: () = self.getTimers(client: appState.graphqlClient, date: selectedDate)
            async let tmpStats: () = self.getStats(client: appState.graphqlClient)
            async let tmpMe: () = self.me(client: appState.graphqlClient)
            
            let responses = try await [tmpProjects ?? [], tmpTimers, tmpStats, tmpMe] as [Any]
            
            self.updateMainScreenVmProp(for: \.projects, newValue: responses[0] as! [Project])
        } catch {
            self.parseError(for: error)
        }
    }
    
    //MARK: - Property Changers
    
    func showEditTimerModal(editedTimerId: Int) {
        self.updateMainScreenVmProp(for: \.isNewEntryModalShown, newValue: true)
        self.updateMainScreenVmProp(for: \.editedTimerItemId, newValue: editedTimerId)
    }
    
    func showNewEntryTimerModal() {
        self.updateMainScreenVmProp(for: \.isNewEntryModalShown, newValue: true)
        self.updateMainScreenVmProp(for: \.editedTimerItemId, newValue: nil)
    }
    
    func getEditedTimer() -> TimeEntry? {
        return self.timers.first(where: {$0.id == editedTimerItemId})
    }
    
    func updateMainScreenVmProp<T>(for keyPath: ReferenceWritableKeyPath<MainScreenViewModel, T>, newValue: T) {
        DispatchQueue.main.async { [weak self] in
            self?[keyPath: keyPath] = newValue
        }
    }
    
    //MARK: - Network Requests
    
    func me(client: GraphqlClient? = nil) async {
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        
        do {
            let res = try await networkManager.me(graphqlClient: appState?.graphqlClient ?? client)
            self.updateMainScreenVmProp(for: \.email, newValue: res?.email ?? "")
        } catch {
            self.parseError(for: error)
        }
        
        self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
    }
    
    func getStats(client: GraphqlClient? = nil) async {
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        do {
            let tmpStats = try await networkManager.fetchStats(graphqlClient: appState?.graphqlClient ?? client,
                                                               date: selectedDate)
            self.updateMainScreenVmProp(for: \.stats, newValue: tmpStats)
            // update today total duration with active timer
            let todayTotalStats = tmpStats?.byDate.first(where: {$0.date.toDate()?.isToday ?? false})
            let tmpTodayTotalDuration = todayTotalStats?.totalDuration ?? 0
            self.updateMainScreenVmProp(for: \.todayTotalDurationWithActiveTimer, newValue: tmpTodayTotalDuration.minuteToHours)
            
            // update this week total duration with active timer
            let tmpThisWeekTotalDuration = tmpStats?.byDate
                .reduce(0, { partialResult, statByDate in
                    return statByDate.totalDuration + partialResult
                }) ?? 0
                
            self.updateMainScreenVmProp(for: \.thisWeekDurationWithActiveTimer, newValue: tmpThisWeekTotalDuration.minuteToHours)
            
            // update this month total duration with active timer
            let tmpThisMonthStats = tmpStats?.byInterval
                .filter({$0.type == IntervalType.Month.rawValue})
                .first(where: {$0.startsAt.toDate()?.compare(.isThisMonth) ?? false})
            let tmpThisMonthTotalDuration = tmpThisMonthStats?.totalDuration ?? 0
            self.updateMainScreenVmProp(for: \.thisMonthDurationWithActiveTimer, newValue: tmpThisMonthTotalDuration.minuteToHours)
        } catch {
            self.parseError(for: error)
        }
        self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
    }
    
    func getTimers(client: GraphqlClient? = nil, date: Date, onFinish: (() -> Void)? = nil) async {
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        do {
            let tmpTimers = try await networkManager.fetchTimers(graphqlClient: appState?.graphqlClient ?? client, date: date) ?? []
            self.updateMainScreenVmProp(for: \.timers, newValue: tmpTimers)
            self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
            self.updateMainScreenVmProp(for: \.totalDurationMap[date.startOfDayISO],
                                        newValue: tmpTimers.reduce(0, { partialResult, timeEntry in
                return partialResult + timeEntry.totalDuration
            }))
            DispatchQueue.main.async {
                onFinish?()
            }
            if let startedTimeEntry = tmpTimers.first(where: {$0.endsAt == nil || ($0.endsAt != nil && $0.endsAt!.isEmpty)}) {
                self.startLocalTimerForEntry(timerEntry: startedTimeEntry)
            }
            
        } catch {
            DispatchQueue.main.async {
                onFinish?()
            }
            self.parseError(for: error)
            self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
        }
    }
    
    func getTasks(projectId: Int) async {
        self.updateMainScreenVmProp(for: \.isTasksLoading, newValue: true)
        
        do {
            let tmpTasks = try await networkManager.fetchTasks(graphqlClient: appState?.graphqlClient, projectId: projectId) ?? []
            self.updateMainScreenVmProp(for: \.tasks, newValue: tmpTasks)
            self.updateMainScreenVmProp(for: \.isTasksLoading, newValue: false)
        } catch {
            self.parseError(for: error)
            self.updateMainScreenVmProp(for: \.isTasksLoading, newValue: false)
        }
    }
    
    func refetch(date: Date) async {
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        self.timer?.cancel()
        do {
            async let tmpProjects = networkManager.fetchProjects(graphqlClient: appState?.graphqlClient)
            async let tmpTimers: () = self.getTimers(date: selectedDate)
            async let tmpStats: () = self.getStats()
            async let tmpMe: () = self.me()
            
            let responses = try await [tmpProjects ?? [], tmpTimers, tmpStats, tmpMe] as [Any]
            self.updateMainScreenVmProp(for: \.projects, newValue: responses[0] as! [Project])
        } catch {
            self.parseError(for: error)
        }
    }
    
    func logTimer(projectId: Int, projectTaskId: Int, duration: String, notes: String, date: Date) async {
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        
        // the 2 lines below, try to show a demand time with current second
        let now = Date.now
        let loggedDate = Date(year: date.year, month: date.month, day: date.day, hour: now.hour, minute: now.minute, second: now.second)
        
        do {
            let loggedTimerInfo = try await networkManager.logTimer(graphqlClient: appState?.graphqlClient,
                                              projectTaskId: projectTaskId,
                                              duration: duration,
                                              notes: notes,
                                              date: loggedDate)
            guard let loggedTimerId = loggedTimerInfo?.id, let loggedStartsAt = loggedTimerInfo?.startsAt else {
                return
            }
            guard let task = self.tasks.first(where: {$0.id == projectTaskId}),
               let project = self.projects.first(where: {$0.id == projectId}) else {
                throw HappyError.notFoundProject
            }
            let tmpNewTimer = TimeEntry(id: Int(loggedTimerId)!,
                      projectId: projectId,
                      projectName: project.name,
                      taskId: projectTaskId,
                      taskName: task.name,
                      notes: notes,
                      startsAt: loggedStartsAt,
                      endsAt: loggedTimerInfo?.endsAt,
                      duration: duration.toMinute,
                      totalDuration: duration.toMinute)
            
            DispatchQueue.main.async {
                self.timers.append(tmpNewTimer)
            }
            await self.getStats()
        } catch {
            self.parseError(for: error)
        }
        self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
        self.updateMainScreenVmProp(for: \.isNewEntryModalShown, newValue: false)
    }
    
    func updateTimer(projectTaskId: Int,
                     duration: String,
                     notes: String,
                     startsAt: String,
                     endsAt: String) async {
        
        guard let editedTimeItemId = editedTimerItemId else {
            return
        }
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        do {
            let updatedTimerInfo = try await networkManager.updateTimer(graphqlClient: appState?.graphqlClient,
                                                 editedTimeItemId: editedTimeItemId,
                                                 projectTaskId: projectTaskId,
                                                 duration: duration,
                                                 notes: notes,
                                                 startsAt: startsAt,
                                                 endsAt: endsAt)
            
            guard let updatedTimerInfo = updatedTimerInfo,
                  let updatedTimerId = updatedTimerInfo.id,
                  let totalDuration = updatedTimerInfo.totalDuration,
                      totalDuration != 0 else {
                await self.getTimers(date: selectedDate)
                      self.updateMainScreenVmProp(for: \.isNewEntryModalShown, newValue: false)
                return
            }
            
            guard let tmpUpdatedTimerIndex = self.timers.firstIndex(where: {$0.id == updatedTimerId}) else {
                throw HappyError.notFoundProject
            }
            
            DispatchQueue.main.async {
                // update timer in timers data
                self.timers[tmpUpdatedTimerIndex].notes = notes
                self.timers[tmpUpdatedTimerIndex].totalDuration = totalDuration
                self.timers[tmpUpdatedTimerIndex].endsAt = updatedTimerInfo.endsAt
                self.timers[tmpUpdatedTimerIndex].startsAt = updatedTimerInfo.startsAt
            }
            await self.getStats()
        } catch {
            self.parseError(for: error)
        }
        self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
        self.updateMainScreenVmProp(for: \.isNewEntryModalShown, newValue: false)
    }
    
    func removeTimer(id: Int, selectedDate: Date) async {
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        do {
            let removedTimerId = try await networkManager.removeTimer(graphqlClient: appState?.graphqlClient, id: id, selectedDate: selectedDate)
            if removedTimerId != nil {
                guard let removedTimerIndex = self.timers.firstIndex(where: {$0.id == removedTimerId}) else {
                    throw HappyError.notFoundProject
                }
                DispatchQueue.main.async {
                    self.timers.remove(at: removedTimerIndex)
                }
            }
            await self.getStats()
        } catch {
            self.parseError(for: error)
            self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
        }
    }
    
    func startTimer(projectId: Int, projectTaskId: Int, notes: String) async {
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        do {
            let startedTimerInfo = try await networkManager.startTimer(graphqlClient: appState?.graphqlClient,
                                                projectTaskId: projectTaskId,
                                                notes: notes)
            guard let startedTimerId = startedTimerInfo?.id,
                  let task = self.tasks.first(where: {$0.id == projectTaskId}),
                  let project = self.projects.first(where: {$0.id == projectId}) else {
                return
            }
            let tmpStartedTimer = TimeEntry(id: Int(startedTimerId)!,
                                            projectId: project.id,
                                            projectName: project.name,
                                            taskId: projectTaskId,
                                            taskName: task.name,
                                            notes: notes,
                                            startsAt: startedTimerInfo?.startsAt ?? Date().toISO(),
                                            endsAt: startedTimerInfo?.endsAt,
                                            duration: nil,
                                            totalDuration: 0)
            DispatchQueue.main.async {
                self.timers.append(tmpStartedTimer)
            }
            self.startLocalTimerForEntry(timerEntry: tmpStartedTimer)
        } catch {
            self.parseError(for: error)
        }
        self.updateMainScreenVmProp(for: \.isNewEntryModalShown, newValue: false)
        self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
    }
    
    func stopTimer(for id: Int) async {
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        self.updateMainScreenVmProp(for: \.activeTimerSeconds, newValue: 0.0)
        do {
            timer?.cancel()
            let stoppedTimerInfo = try await networkManager.stopTimer(graphqlClient: appState?.graphqlClient, for: id)
            guard let stoppedTimerTotalDuration = stoppedTimerInfo?.totalDuration,
                  let endsAt = stoppedTimerInfo?.endsAt,
                  let stoppedTimerIndex = self.timers.firstIndex(where: {$0.id == id}) else {
                return
            }
            var tmpStoppedTimer = timers[stoppedTimerIndex]
            tmpStoppedTimer.endsAt = endsAt
            tmpStoppedTimer.totalDuration = stoppedTimerTotalDuration
            
            updateMainScreenVmProp(for: \.timers[stoppedTimerIndex], newValue: tmpStoppedTimer)
            updateMainScreenVmProp(for: \.activeTimerSeconds, newValue: 0.0)
            await self.getStats()
        } catch {
            self.parseError(for: error)
        }
        self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
    }
    
    func restartTimer(for id: Int) async {
        self.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        do {
            let restartedTimerInfo = try await networkManager.restartTimer(graphqlClient: appState?.graphqlClient, for: id)
            guard let restartedTimerId = restartedTimerInfo?.id,
                  let startsAt = restartedTimerInfo?.startsAt,
                  let totalDuration = restartedTimerInfo?.totalDuration,
                  let tmpRestartedTimeEntryIndex = self.timers.firstIndex(where: {$0.id == restartedTimerId}) else {
                self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
                return
            }
            var tmpRestartedTimer = self.timers[tmpRestartedTimeEntryIndex]
            tmpRestartedTimer.startsAt = startsAt
            tmpRestartedTimer.endsAt = nil
            tmpRestartedTimer.totalDuration = totalDuration
            
            updateMainScreenVmProp(for: \.timers[tmpRestartedTimeEntryIndex], newValue: tmpRestartedTimer)
            self.startLocalTimerForEntry(timerEntry: tmpRestartedTimer)
        } catch {
            self.parseError(for: error)
        }
        self.updateMainScreenVmProp(for: \.isLoading, newValue: false)
    }
    
    func getTotalDurationMinuteOfDayAsString(date: Date) -> String {
        if date.isToday {
            return todayTotalDurationWithActiveTimer
        }
        return stats?.byDate.first(where: {$0.date == date.startOfDayISO})?.totalDuration.minuteToHours ?? "00:00"
    }
    
    private func parseError(for error: Error) {
        print(error)
        if let error = error as? Apollo.ResponseCodeInterceptor.ResponseCodeError {
            switch error {
            case .invalidResponseCode(let response, _):
                if response?.statusCode == 403 {
                    self.appState?.updateAppStateProp(for: \.isLoggedIn, newValue: false)
                } else if response?.statusCode == 504 {
//                    self.appState?.updateAppStateProp(for: \.isError, newValue: true)
                }
            }
        } else {
            // show error popup
            updateMainScreenVmProp(for: \.isErrorShown, newValue: true)
        }
    }
    
    private func startLocalTimerForEntry(timerEntry: TimeEntry) {
        if timer != nil {
            timer?.cancel()
        }
        guard timerEntry.startsAt != nil else { return }
        
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] timer in
                let timeInSeconds = timer.timeIntervalSince1970 - timerEntry.startsAt!.toISODate()!.date.timeIntervalSince1970
                self?.updateMainScreenVmProp(for: \.activeTimerSeconds, newValue: timeInSeconds + Double(timerEntry.totalDurationAsSeconds))
                let tmpActiveTimerDiff = (Int(timeInSeconds) / 60)
                
                // update today total duration with active timer
                let todayTotalStats = self?.stats?.byDate.first(where: {$0.date.toDate()?.isToday ?? false})
                let tmpTodayTotalDuration = todayTotalStats?.totalDuration ?? 0
                let tmpTodayTotalDurationWithActiveTimerDuration = tmpTodayTotalDuration + tmpActiveTimerDiff
                self?.updateMainScreenVmProp(for: \.todayTotalDurationWithActiveTimer, newValue: tmpTodayTotalDurationWithActiveTimerDuration.minuteToHours)
                
                // update this week total duration with active timer
                let tmpThisWeekTotalDuration = self?.stats?.byDate
                    .reduce(0, { partialResult, statByDate in
                        return statByDate.totalDuration + partialResult
                    }) ?? 0
                let tmpThisWeekTotalDurationWithActiveTimerDuration = tmpThisWeekTotalDuration + tmpActiveTimerDiff
                self?.updateMainScreenVmProp(for: \.thisWeekDurationWithActiveTimer, newValue: tmpThisWeekTotalDurationWithActiveTimerDuration.minuteToHours)
                
                // update this month total duration with active timer
                let tmpThisMonthStats = self?.stats?.byInterval.first(where: {$0.type == IntervalType.Month.rawValue})
                let tmpThisMonthTotalDuration = tmpThisMonthStats?.totalDuration ?? 0
                let tmpThisMonthTotalDurationWithActiveTimerDuration = tmpThisMonthTotalDuration + tmpActiveTimerDiff
                self?.updateMainScreenVmProp(for: \.thisMonthDurationWithActiveTimer, newValue: tmpThisMonthTotalDurationWithActiveTimerDuration.minuteToHours)
            }
    }
}
