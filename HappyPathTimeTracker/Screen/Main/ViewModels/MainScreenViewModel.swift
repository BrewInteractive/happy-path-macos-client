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
    case updateError
}

@MainActor
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
    @Published var stats: Stats? = nil
    @Published var isErrorShown = false
    
//    func readAllLogs() {
//        do {
//            try HappyLogger.readLogs()
//        } catch {
//            print("error occured while reading logs : ", error.localizedDescription)
//        }
//    }
    
    let previousMonthLastWeekStartDate: Date
    private var timer: Timer? = nil
    
    
    init(networkSource: NetworkSource) {
        self.networkManager = networkSource
        // first monday of last month of last week
        let now = Date.now
        previousMonthLastWeekStartDate = (now
            .dateBySet([.month : now.month - 1])?
            .dateAtEndOf(.month)
            .dateAtStartOf(.weekOfMonth).date)!
    }
    
    var groupedTimers: [Int: [TimeEntry]] {
        Dictionary(grouping: timers, by: { $0.projectId })
    }
    
    func updateViewModel(appState: AppState) async {
        self.appState = appState
        HappyLogger.logger.log("update view model is loading true")
        isLoading = true
        await fetchAllData()
        isLoading = false
        HappyLogger.logger.log("update view model is loading false")
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { timer in
            Task.detached { [weak self] in
                await self?.fetchAllData()
            }
        }
    }
    
    //MARK: - Property Changers
    
    func showEditTimerModal(editedTimerId: Int) {
        isNewEntryModalShown = true
        editedTimerItemId = editedTimerId
    }
    
    @MainActor
    func showNewEntryTimerModal() {
        isNewEntryModalShown = true
        editedTimerItemId = nil
    }
    
    @MainActor
    func hideNewEntryTimerModal() {
        isNewEntryModalShown = false
    }
    
    func getEditedTimer() -> TimeEntry? {
        return self.timers.first(where: {$0.id == editedTimerItemId})
    }
    
    //MARK: - Network Requests
    
    func me(client: GraphqlClient? = nil) async {
        do {
            let res = try await networkManager.me(graphqlClient: appState?.graphqlClient ?? client)
            email = res?.email ?? ""
            HappyLogger.logger.log("Me fetched successfully")
        } catch {
            HappyLogger.logger.error("Error occured while fetching Me")
            self.parseError(for: error)
        }
    }
    
    func getStats(client: GraphqlClient? = nil) async {
        do {
            stats = try await networkManager.fetchStats(graphqlClient: appState?.graphqlClient ?? client,
                                                               date: selectedDate)
            HappyLogger.logger.log("Stats fetched successfully")
        } catch {
            HappyLogger.logger.error("Error occured while fetching Stats")
            self.parseError(for: error)
        }
    }
    
    func getTimers(client: GraphqlClient? = nil, date: Date, onFinish: (() -> Void)? = nil) async {
        do {
            timers = try await networkManager.fetchTimers(graphqlClient: appState?.graphqlClient ?? client, date: date) ?? []
            DispatchQueue.main.async {
                onFinish?()
            }
            HappyLogger.logger.log("Timers fetched successfully")
        } catch {
            DispatchQueue.main.async {
                onFinish?()
            }
            HappyLogger.logger.error("Error occured while fetching Timers")
            self.parseError(for: error)
        }
    }
    
    func getJustTimers(date: Date) async {
        HappyLogger.logger.log("getJustTimers is loading true")
        isLoading = true
        await getTimers(date: date)
        await getStats()
        isLoading = false
        HappyLogger.logger.log("getJustTimers is loading false")
    }
    
    func getTasks(projectId: Int) async {
        isTasksLoading = true
        
        do {
            tasks = try await networkManager.fetchTasks(graphqlClient: appState?.graphqlClient, projectId: projectId) ?? []
            HappyLogger.logger.log("Tasks fetched successfully")
        } catch {
            HappyLogger.logger.error("Error occured while fetching Tasks")
            self.parseError(for: error)
        }
        
        isTasksLoading = false
    }
    
    func refetch(date: Date) async {
        HappyLogger.logger.log("refetch is loading true")
        isLoading = true
        await fetchAllData()
        isLoading = false
        HappyLogger.logger.log("refetch is loading false")
    }
    
    func logTimer(projectId: Int, projectTaskId: Int, duration: Int, notes: String, date: Date, relations: [String]?) async {
        HappyLogger.logger.log("logTimer is loading true")
        isLoading = true
        
        // the 2 lines below, try to show a demand time with current second
        let now = Date.now
        let loggedDate = Date(year: date.year, month: date.month, day: date.day, hour: now.hour, minute: now.minute, second: now.second)
        
        do {
            let loggedTimerInfo = try await networkManager.logTimer(graphqlClient: appState?.graphqlClient,
                                                                    projectTaskId: projectTaskId,
                                                                    duration: duration,
                                                                    notes: notes,
                                                                    date: loggedDate,
                                                                    relations: relations)
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
                                        duration: duration,
                                        relations: relations,
                                        totalDuration: duration)
            self.timers.append(tmpNewTimer)
            try? await Task.sleep(for: .seconds(1))
            await self.getStats()
            HappyLogger.logger.log("Log timer successfully with id: \(loggedTimerId)")
        } catch {
            HappyLogger.logger.error("Error occured while logging Timer with projectId: \(projectId), projectTaskId: \(projectTaskId)")
            self.parseError(for: error)
        }
        
        isLoading = false
        isNewEntryModalShown = false
        HappyLogger.logger.log("logTimer is loading false")
    }
    
    func updateTimer(projectTaskId: Int,
                     duration: Int,
                     notes: String,
                     startsAt: String,
                     endsAt: String,
                     relations: [String]?) async {
        
        guard let editedTimerItemId = editedTimerItemId else {
            return
        }
        HappyLogger.logger.log("updateTimer is loading true")
        isLoading = true
        do {
            let updatedTimerInfo = try await networkManager.updateTimer(graphqlClient: appState?.graphqlClient,
                                                                        editedTimerItemId: editedTimerItemId,
                                                                        projectTaskId: projectTaskId,
                                                                        duration: duration,
                                                                        notes: notes,
                                                                        startsAt: startsAt,
                                                                        endsAt: endsAt,
                                                                        relations: relations)
            
            guard let updatedTimerInfo = updatedTimerInfo,
                  let updatedTimerId = updatedTimerInfo.id else {
                throw HappyError.updateError
            }
            
            guard let tmpUpdatedTimerIndex = self.timers.firstIndex(where: {$0.id == updatedTimerId}) else {
                throw HappyError.notFoundProject
            }
            
            try? await Task.sleep(for: .seconds(1))
            await self.getStats()

            // update timer in timers data
            self.timers[tmpUpdatedTimerIndex].notes = notes
            self.timers[tmpUpdatedTimerIndex].totalDuration = duration
            self.timers[tmpUpdatedTimerIndex].endsAt = updatedTimerInfo.endsAt
            self.timers[tmpUpdatedTimerIndex].startsAt = updatedTimerInfo.startsAt
            self.timers[tmpUpdatedTimerIndex].relations = relations
            HappyLogger.logger.log("Update timer successfully with id: \(editedTimerItemId)")
        } catch {
            HappyLogger.logger.error("Error occured while updating Timer with id: \(editedTimerItemId)")
            self.parseError(for: error)
        }
        isLoading = false
        isNewEntryModalShown = false
        HappyLogger.logger.log("updateTimer is loading false")
    }
    
    func removeTimer(id: Int, selectedDate: Date) async {
        HappyLogger.logger.log("removeTimer is loading true")
        isLoading = true
        do {
            let removedTimerId = try await networkManager.removeTimer(graphqlClient: appState?.graphqlClient, id: id, selectedDate: selectedDate)
            try? await Task.sleep(for: .seconds(1))
            await self.getStats()
            if removedTimerId != nil {
                guard let removedTimerIndex = self.timers.firstIndex(where: {$0.id == removedTimerId}) else {
                    throw HappyError.notFoundProject
                }
                self.timers.remove(at: removedTimerIndex)
            }
            HappyLogger.logger.log("Remove timer successfully with id: \(id)")
        } catch {
            HappyLogger.logger.error("Error occured while removing Timer with id: \(id)")
            self.parseError(for: error)
        }
        isLoading = false
        HappyLogger.logger.log("removeTimer is loading false")
    }
    
    func startTimer(projectId: Int, projectTaskId: Int, notes: String, relations: [String]?) async {
        HappyLogger.logger.log("startTimer is loading true")
        isLoading = true
        do {
            let startedTimerInfo = try await networkManager.startTimer(graphqlClient: appState?.graphqlClient,
                                                                       projectTaskId: projectTaskId,
                                                                       notes: notes,
                                                                       relations: nil)
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
                                            duration: 0,
                                            relations: relations,
                                            totalDuration: 0)
            self.timers.append(tmpStartedTimer)
            HappyLogger.logger.log("Start timer successfully with id: \(startedTimerId)")
        } catch {
            HappyLogger.logger.error("Error occured while starting Timer with projectId: \(projectId), projectTaskId: \(projectTaskId)")
            self.parseError(for: error)
        }
        isNewEntryModalShown = false
        isLoading = false
        HappyLogger.logger.log("startTimer is loading false")
    }
    
    func stopTimer(for id: Int) async {
        HappyLogger.logger.log("stopTimer is loading true")
        isLoading = true
        do {
            let stoppedTimerInfo = try await networkManager.stopTimer(graphqlClient: appState?.graphqlClient, for: id)
            guard let stoppedTimerTotalDuration = stoppedTimerInfo?.totalDuration,
                  let endsAt = stoppedTimerInfo?.endsAt,
                  let stoppedTimerIndex = self.timers.firstIndex(where: {$0.id == id}) else {
                return
            }
            
            try? await Task.sleep(for: .seconds(1))
            await self.getStats()
            
            var tmpStoppedTimer = timers[stoppedTimerIndex]
            tmpStoppedTimer.endsAt = endsAt
            tmpStoppedTimer.totalDuration = stoppedTimerTotalDuration
            
            timers[stoppedTimerIndex] = tmpStoppedTimer
            HappyLogger.logger.log("Stop timer successfully with id: \(id)")
        } catch {
            HappyLogger.logger.error("Error occured while stopping Timer with id: \(id)")
            self.parseError(for: error)
        }
        isLoading = false
        HappyLogger.logger.log("stopTimer is loading false")
    }
    
    func restartTimer(for id: Int) async {
        HappyLogger.logger.log("restartTimer is loading true")
        isLoading = true
        do {
            let restartedTimerInfo = try await networkManager.restartTimer(graphqlClient: appState?.graphqlClient, for: id)
            guard let restartedTimerId = restartedTimerInfo?.id,
                  let tmpRestartedTimeEntryIndex = self.timers.firstIndex(where: {$0.id == restartedTimerId}) else {
                isLoading = false
                return
            }
            var tmpRestartedTimer = self.timers[tmpRestartedTimeEntryIndex]
            tmpRestartedTimer.endsAt = nil
            
            timers[tmpRestartedTimeEntryIndex] = tmpRestartedTimer
            HappyLogger.logger.log("Restart timer successfully with id: \(id)")
        } catch {
            HappyLogger.logger.error("Error occured while stopping Timer with id: \(id)")
            self.parseError(for: error)
        }
        
        isLoading = false
        HappyLogger.logger.log("restartTimer is loading false")
    }
    
    func getTotalDurationMinuteOfDayAsString(date: Date) -> String {
        return stats?.byDate.first(where: {$0.date == date.startOfDayISO})?.totalDuration.minuteToHours ?? "00:00"
    }
    
    private func fetchAllData() async {
        if appState?.graphqlClient == nil {
            HappyLogger.logger.log("fetch all data graphql client nil")
            return
        }
        do {
            async let tmpProjects = networkManager.fetchProjects(graphqlClient: appState?.graphqlClient)
            async let tmpTimers: () = self.getTimers(date: selectedDate)
            async let tmpStats: () = self.getStats()
            async let tmpMe: () = self.me()
            
            let responses = try await [tmpProjects ?? [], tmpTimers, tmpStats, tmpMe] as [Any]
            projects = responses[0] as! [Project]
            HappyLogger.logger.log("Fetched all data successfully")
        } catch {
            HappyLogger.logger.error("Error occured while fetching all data")
            self.parseError(for: error)
        }
    }
    
    private func parseError(for error: Error) {
        if let error = error as? Apollo.ResponseCodeInterceptor.ResponseCodeError {
            switch error {
            case .invalidResponseCode(let response, _):
                if response?.statusCode == 403 {
                    HappyLogger.logger.error("403 Error occured: \(error.localizedDescription)")
                    self.appState?.isLoggedIn = false
                } else if response?.statusCode == 504 {
                    HappyLogger.logger.error("504 Error occured: \(error.localizedDescription)")
                }
            }
        } else {
            HappyLogger.logger.error("Undefined error occured: \(error.localizedDescription)")
            // show error popup
            isErrorShown = true
        }
    }
}
