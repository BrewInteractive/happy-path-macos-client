//
//  NetworkManager.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 18.07.2023.
//

import Foundation
import Apollo
import DirectusGraphql

protocol NetworkSource {
    func me(graphqlClient: GraphqlClient?) async throws -> MeQuery.Data.Me?
    func fetchStats(graphqlClient: GraphqlClient?, date: String) async throws -> Stats?
    func fetchProjects(graphqlClient: GraphqlClient?) async throws -> [Project]?
    func fetchTimers(graphqlClient: GraphqlClient?, date: Date) async throws -> [TimeEntry]?
    func fetchTasks(graphqlClient: GraphqlClient?, projectId: Int) async throws -> [ProjectTask]?
    func logTimer(graphqlClient: GraphqlClient?, projectTaskId: Int, duration: String, notes: String, date: Date) async throws -> LogTimerMutation.Data.Log?
    func updateTimer(graphqlClient: GraphqlClient?, editedTimeItemId: Int, projectTaskId: Int, duration: String, notes: String, startsAt: String, endsAt: String) async throws -> UpdateTimerMutation.Data.Update?
    func removeTimer(graphqlClient: GraphqlClient?, id: Int, selectedDate: Date) async throws -> Int?
    func startTimer(graphqlClient: GraphqlClient?, projectTaskId: Int, notes: String) async throws -> StartTimerMutation.Data.Start?
    func stopTimer(graphqlClient: GraphqlClient?, for id: Int) async throws -> StopTimerMutation.Data.Stop?
    func restartTimer(graphqlClient: GraphqlClient?, for id: Int) async throws -> RestartTimerMutation.Data.Restart?
}

final class NetworkManager: NetworkSource {
    
    func me(graphqlClient: GraphqlClient?) async throws -> MeQuery.Data.Me? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?.client?.fetch(query: MeQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
                switch result {
                case .success(let res):
                    if res.data != nil {
                        continuation.resume(returning: res.data?.me)
                    } else {
                        continuation.resume(throwing: HappyError.errorFromBackend)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
    func fetchStats(graphqlClient: GraphqlClient?, date: String) async throws -> Stats? {
        guard let startOfDate = date.toDate()?.date.startOfDayISO else {
            return nil
        }
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?.client?.fetch(query: StatsQuery(date: startOfDate), cachePolicy: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case .success(let res):
                    if res.data != nil {
                        let stats = self?.parseStats(from: res)
                        continuation.resume(returning: stats)
                    } else {
                        continuation.resume(throwing: HappyError.errorFromBackend)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
    func fetchProjects(graphqlClient: GraphqlClient? = nil) async throws -> [Project]? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?.client?.fetch(query: GetProjectsQuery(), cachePolicy: .fetchIgnoringCacheData) { [weak self] result in
                switch result {
                case .success(let res):
                    if res.data != nil {
                        let tmpProjects = self?.parseProjects(from: res) ?? []
                        continuation.resume(returning: tmpProjects)
                    } else {
                        continuation.resume(throwing: HappyError.errorFromBackend)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
    func fetchTimers(graphqlClient: GraphqlClient?, date: Date) async throws -> [TimeEntry]? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?.client?
                .fetch(query: GetTimersQuery(startsAt: date.startOfDayISO, endsAt: date.endOfDayISO), cachePolicy: .fetchIgnoringCacheData) { [weak self] result in
                    switch result {
                    case .success(let res):
                        if res.data != nil {
                            let tmpTimers = self?.parseTimers(from: res) ?? []
                            continuation.resume(returning: tmpTimers)
                        } else {
                            continuation.resume(throwing: HappyError.errorFromBackend)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        })
    }
    
    func fetchTasks(graphqlClient: GraphqlClient?, projectId: Int) async throws -> [ProjectTask]? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?.client?
                .fetch(query: GetTasksQuery(projectId: projectId), cachePolicy: .fetchIgnoringCacheData) { [weak self] result in
                    switch result {
                    case .success(let res):
                        if res.data != nil {
                            let tmpTasks = self?.parseTasks(from: res)
                            continuation.resume(returning: tmpTasks)
                        } else {
                            continuation.resume(throwing: HappyError.errorFromBackend)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        })
    }
    
    func logTimer(graphqlClient: GraphqlClient?, projectTaskId: Int, duration: String, notes: String, date: Date) async throws -> LogTimerMutation.Data.Log? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?.client?
                .perform(mutation: LogTimerMutation(projectTaskId: projectTaskId,
                                                    duration: duration.toMinute,
                                                    notes: notes,
                                                    startsAt: date.toISO(),
                                                    endsAt: date.toISO())) { result in
                    switch result {
                    case .success(let res):
                        if res.data != nil {
                            continuation.resume(returning: res.data?.log)
                        } else {
                            continuation.resume(throwing: HappyError.errorFromBackend)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        })
    }
    
    func updateTimer(graphqlClient: GraphqlClient?,
                     editedTimeItemId: Int,
                     projectTaskId: Int,
                     duration: String,
                     notes: String,
                     startsAt: String,
                     endsAt: String) async throws -> UpdateTimerMutation.Data.Update? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?.client?
                .perform(mutation: UpdateTimerMutation(timerId: editedTimeItemId,
                                                       duration: .some(duration.toMinute),
                                                       startsAt: .some(startsAt),
                                                       endsAt: .some(endsAt),
                                                       notes: .some(notes))) { result in
                    switch result {
                    case .success(let res):
                        if res.data != nil {
                            continuation.resume(returning: res.data?.update)
                        } else {
                            continuation.resume(throwing: HappyError.errorFromBackend)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        })
    }
    
    func removeTimer(graphqlClient: GraphqlClient?, id: Int, selectedDate: Date) async throws -> Int? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?.client?
                .perform(mutation: RemoveTimerMutation(removeId: id)) { result in
                    switch result {
                    case .success(let res):
                        if res.data != nil {
                            continuation.resume(returning: res.data?.remove?.id)
                        } else {
                            continuation.resume(throwing: HappyError.errorFromBackend)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        })
    }
    
    func startTimer(graphqlClient: GraphqlClient?, projectTaskId: Int, notes: String) async throws -> StartTimerMutation.Data.Start? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?
                .client?
                .perform(mutation: StartTimerMutation(projectTaskId: projectTaskId,
                                                      duration: .some(0),
                                                      notes: .some(notes)), resultHandler: { result in
                    switch result {
                    case .success(let res):
                        if res.data != nil {
                            continuation.resume(returning: res.data?.start)
                        } else {
                            continuation.resume(throwing: HappyError.errorFromBackend)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                })
        })
    }
    
    func stopTimer(graphqlClient: GraphqlClient?, for id: Int) async throws -> StopTimerMutation.Data.Stop? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?
                .client?
                .perform(mutation: StopTimerMutation(timerId: id), resultHandler: { result in
                    switch result {
                    case .success(let res):
                        if res.data != nil {
                            continuation.resume(returning: res.data?.stop)
                        } else {
                            continuation.resume(throwing: HappyError.errorFromBackend)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                })
        })
    }
    
    func restartTimer(graphqlClient: GraphqlClient?, for id: Int) async throws -> RestartTimerMutation.Data.Restart? {
        return try await withCheckedThrowingContinuation({ continuation in
            graphqlClient?
                .client?
                .perform(mutation: RestartTimerMutation(timerId: id), resultHandler: { result in
                    switch result {
                    case .success(let res):
                        if res.data != nil {
                            continuation.resume(returning: res.data?.restart)
                        } else {
                            continuation.resume(throwing: HappyError.errorFromBackend)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                })
        })
    }
    
    // MARK: Object Parsers
    
    private func parseStats(from res: GraphQLResult<StatsQuery.Data>) -> Stats? {
        let tmpStatByDate = res.data?.stats?.byDate?.compactMap({ byDate -> StatsByDate? in
            guard let date = byDate?.date,
                  let startOfDate = date.toDate()?.date.startOfDayISO,
                  let totalDuration = byDate?.totalDuration else {
                return nil
            }
            return StatsByDate(date: startOfDate, totalDuration: totalDuration)
        }) ?? []
        
        var tmpStatByInterval = res.data?.stats?.byInterval?.compactMap({ byInterval -> StatsByInterval? in
            guard let type = byInterval?.type,
                  let startAt = byInterval?.startsAt,
                  let endsAt = byInterval?.endsAt,
                  let totalDuration = byInterval?.totalDuration  else {
                return nil
            }
            return StatsByInterval(type: type,
                                   startsAt: startAt,
                                   endsAt: endsAt,
                                   totalDuration: totalDuration)
        }) ?? []
        
        // calculate weekly interval
        let weeklyIntervalTotalDuration = tmpStatByDate.reduce(0) { partialResult, statsByDate in
            return partialResult + statsByDate.totalDuration
        }
        let weeklyInterval = StatsByInterval(type: "weekly",
                        startsAt: Date().dateAtStartOf(.weekday).startOfDayISO,
                        endsAt: Date().dateAtEndOf(.weekday).endOfDayISO,
                        totalDuration: weeklyIntervalTotalDuration)
        
        tmpStatByInterval.append(weeklyInterval)
        
        // calculate daily interval
        let dailyIntervalTotalDuration = tmpStatByDate.first(where: {$0.date.toDate()?.dateAtStartOf(.day).toISO() == Date().startOfDayISO})?.totalDuration ?? 0
        let dailyInterval = StatsByInterval(type: "daily",
                        startsAt: Date().startOfDayISO,
                        endsAt: Date().endOfDayISO,
                        totalDuration: dailyIntervalTotalDuration)
        
        tmpStatByInterval.append(dailyInterval)
        
        // calculate previous daily interval
        let yesterdayDailyIntervalTotalDuration = tmpStatByDate.first(where: {$0.date.toDate()?.dateAtStartOf(.day).toISO() == Date().dateByAdding(-1, .day).date.startOfDayISO})?.totalDuration ?? 0
        let yesterdayDailyInterval = StatsByInterval(type: "yesterday",
                        startsAt: Date().startOfDayISO,
                        endsAt: Date().endOfDayISO,
                        totalDuration: yesterdayDailyIntervalTotalDuration)
        
        tmpStatByInterval.append(yesterdayDailyInterval)
        
        return Stats(byDate: tmpStatByDate, byInterval: tmpStatByInterval)
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
                  let startsAt = timer.startsAt else {
                return nil
            }
            
            return TimeEntry(id: id,
                             projectId: projectId,
                             projectName: timer.project?.name ?? "",
                             taskId: taskId,
                             taskName: timer.task?.name ?? "",
                             notes: timer.notes ?? "",
                             startsAt: startsAt,
                             endsAt: timer.endsAt,
                             duration: timer.duration,
                             totalDuration: timer.totalDuration ?? 0)
        }) ?? []
    }
    
    private func parseTasks(from res: GraphQLResult<GetTasksQuery.Data>) -> [ProjectTask] {
        return res.data?.tasks?.compactMap({ task in
            guard let id = task?.id, let name = task?.taskName else {
                return nil
            }
            return ProjectTask(id: Int(id)!, name: name)
        }) ?? []
    }
}
