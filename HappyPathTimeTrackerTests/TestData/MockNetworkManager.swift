//
//  MockNetworkManager.swift
//  HappyPathTimeTrackerTests
//
//  Created by Gorkem Sevim on 11.08.2023.
//

@testable import DirectusGraphql
@testable import GraphqlTestMocks
@testable import HappyPathTimeTracker
import Foundation
import ApolloTestSupport

enum TestError: Error {
    case dummy
}

class MockNetworkManager: NetworkSource {
    func me(graphqlClient: HappyPathTimeTracker.GraphqlClient?) async throws -> DirectusGraphql.MeQuery.Data.Me? {
        let mockMe = Mock<GraphqlTestMocks.Me>(email: DummyData.email)
        return MeQuery.Data.Me.from(mockMe)
    }
    
    func fetchStats(graphqlClient: HappyPathTimeTracker.GraphqlClient?, date: Date) async throws -> HappyPathTimeTracker.Stats? {
        return DummyData.stats
    }
    
    func fetchProjects(graphqlClient: HappyPathTimeTracker.GraphqlClient?) async throws -> [HappyPathTimeTracker.Project]? {
        return DummyData.projects
    }
    
    func fetchTimers(graphqlClient: HappyPathTimeTracker.GraphqlClient?, date: Date) async throws -> [HappyPathTimeTracker.TimeEntry]? {
        return DummyData.timers
    }
    
    func fetchTasks(graphqlClient: HappyPathTimeTracker.GraphqlClient?, projectId: Int) async throws -> [HappyPathTimeTracker.ProjectTask]? {
        return DummyData.tasks
    }
    
    func logTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, projectTaskId: Int, duration: String, notes: String, date: Date) async throws -> DirectusGraphql.LogTimerMutation.Data.Log? {
        
        let mockLogTimer = Mock<GraphqlTestMocks.Log>()
        mockLogTimer.id = DummyData.loggedTimerInfoId
        mockLogTimer.startsAt = DummyData.loggedTimerInfoStartsAt
        return LogTimerMutation.Data.Log.from(mockLogTimer)
    }
    
    func updateTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, editedTimeItemId: Int, projectTaskId: Int, duration: String, notes: String, startsAt: String, endsAt: String) async throws -> DirectusGraphql.UpdateTimerMutation.Data.Update? {
        let mockUpdateTimer = Mock<GraphqlTestMocks.Update>()
        mockUpdateTimer.id = DummyData.updatedTimerId
        mockUpdateTimer.startsAt = DummyData.updatedTimerStartsAt
        mockUpdateTimer.endsAt = DummyData.updatedTimerEndsAt
        mockUpdateTimer.totalDuration = DummyData.updatedTimerTotalDuration
        
        return UpdateTimerMutation.Data.Update.from(mockUpdateTimer)
    }
    
    func removeTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, id: Int, selectedDate: Date) async throws -> Int? {
        DummyData.timers[0].id
    }
    
    func startTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, projectTaskId: Int, notes: String) async throws -> DirectusGraphql.StartTimerMutation.Data.Start? {
        let mockStartTimer = Mock<GraphqlTestMocks.Start>()
        mockStartTimer.id = DummyData.startedTimerId
        mockStartTimer.startsAt = DummyData.startedTimerStartsAt
        mockStartTimer.endsAt = DummyData.startedTimerEndsAt
        mockStartTimer.duration = DummyData.startedTimerDuration
        
        return StartTimerMutation.Data.Start.from(mockStartTimer)
    }
    
    func stopTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, for id: Int) async throws -> DirectusGraphql.StopTimerMutation.Data.Stop? {
        
        let mockStopTimer = Mock<GraphqlTestMocks.Stop>()
        mockStopTimer.id = String(DummyData.stoppedTimerId)
        mockStopTimer.startsAt = DummyData.stoppedTimerStartsAt
        mockStopTimer.endsAt = DummyData.stoppedTimerEndsAt
        mockStopTimer.totalDuration = DummyData.stoppedTimerTotalDuration
        return StopTimerMutation.Data.Stop.from(mockStopTimer)
    }
    
    func restartTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, for id: Int) async throws -> DirectusGraphql.RestartTimerMutation.Data.Restart? {
        let mockRestartTimer = Mock<GraphqlTestMocks.Restart>()
        mockRestartTimer.id = DummyData.restartedTimerId
        mockRestartTimer.startsAt = DummyData.restartedTimerStartsAt
        mockRestartTimer.totalDuration = DummyData.restartedTotalDuration
        return RestartTimerMutation.Data.Restart.from(mockRestartTimer)
    }
}

class MockNetworkManagerErrorThrows: NetworkSource {
    func me(graphqlClient: HappyPathTimeTracker.GraphqlClient?) async throws -> DirectusGraphql.MeQuery.Data.Me? {
        throw TestError.dummy
    }
    
    func fetchStats(graphqlClient: HappyPathTimeTracker.GraphqlClient?, date: String) async throws -> HappyPathTimeTracker.Stats? {
        throw TestError.dummy
    }
    
    func fetchProjects(graphqlClient: HappyPathTimeTracker.GraphqlClient?) async throws -> [HappyPathTimeTracker.Project]? {
        throw TestError.dummy
    }
    
    func fetchTimers(graphqlClient: HappyPathTimeTracker.GraphqlClient?, date: Date) async throws -> [HappyPathTimeTracker.TimeEntry]? {
        throw TestError.dummy
    }
    
    func fetchTasks(graphqlClient: HappyPathTimeTracker.GraphqlClient?, projectId: Int) async throws -> [HappyPathTimeTracker.ProjectTask]? {
        throw TestError.dummy
    }
    
    func logTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, projectTaskId: Int, duration: String, notes: String, date: Date) async throws -> DirectusGraphql.LogTimerMutation.Data.Log? {
        throw TestError.dummy
    }
    
    func updateTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, editedTimeItemId: Int, projectTaskId: Int, duration: String, notes: String, startsAt: String, endsAt: String) async throws -> DirectusGraphql.UpdateTimerMutation.Data.Update? {
        throw TestError.dummy
    }
    
    func removeTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, id: Int, selectedDate: Date) async throws -> Int? {
        throw TestError.dummy
    }
    
    func startTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, projectTaskId: Int, notes: String) async throws -> DirectusGraphql.StartTimerMutation.Data.Start? {
        throw TestError.dummy
    }
    
    func stopTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, for id: Int) async throws -> DirectusGraphql.StopTimerMutation.Data.Stop? {
        
        throw TestError.dummy
    }
    
    func restartTimer(graphqlClient: HappyPathTimeTracker.GraphqlClient?, for id: Int) async throws -> DirectusGraphql.RestartTimerMutation.Data.Restart? {
        throw TestError.dummy
    }
}
