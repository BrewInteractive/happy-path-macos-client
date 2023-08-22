//
//  MainScreenViewModelTests.swift
//  HappyPathTimeTrackerTests
//
//  Created by Gorkem Sevim on 18.07.2023.
//

@testable import HappyPathTimeTracker
@testable import SwiftDate
@testable import DirectusGraphql
import XCTest
import Combine

final class MainScreenViewModelTests: XCTestCase {
    var networkManager: NetworkSource? = nil
    var cancellables = Set<AnyCancellable>()
    var vm: MainScreenViewModel? = nil
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkManager = MockNetworkManager()
        vm = MainScreenViewModel(networkSource: MockNetworkManager())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkManager = nil
        vm = nil
        cancellables.removeAll()
        sleep(1)
    }

    func test_MainScreenVM_initialValues() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        guard let vm = vm else {
            XCTFail("vm is nil")
            return
        }
        
        XCTAssertNil(vm.appState)
        XCTAssertEqual(vm.email, "")
        XCTAssertEqual(vm.timers.count, 0)
        XCTAssertEqual(vm.projects.count, 0)
        XCTAssertEqual(vm.projects.count, 0)
        XCTAssertEqual(vm.isLoading, false)
        XCTAssertEqual(vm.isTasksLoading, false)
        XCTAssertEqual(vm.selectedDate.startOfDayISO, Date().startOfDayISO)
        XCTAssertEqual(vm.isNewEntryModalShown, false)
        XCTAssertEqual(vm.editedTimerItemId, nil)
        XCTAssertEqual(vm.activeTimerSeconds, 0.0)
        XCTAssertEqual(vm.todayTotalDurationWithActiveTimer, "00:00")
        XCTAssertEqual(vm.thisWeekDurationWithActiveTimer, "00:00")
        XCTAssertEqual(vm.thisMonthDurationWithActiveTimer, "00:00")
        XCTAssertEqual(vm.totalDurationMap.count, 0)
        XCTAssertNil(vm.stats)
        XCTAssertEqual(vm.isErrorShown, false)
        XCTAssertEqual(vm.activeTimerId, nil)
    }
    
    func test_MainScreenVm_showEditTimerModal_updateModalShownAndEditTimerId() throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("showEditTimerModal")
        let editedTimerId = Int.random(in: 1...10)
        vm.showEditTimerModal(editedTimerId: editedTimerId)
        let expectation = XCTestExpectation(description: "waitin for edited timer id and isEntryModalShown props")
        
        vm.$editedTimerItemId
            .zip(vm.$isNewEntryModalShown)
            .dropFirst()
            .sink { value in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(vm.isNewEntryModalShown)
        XCTAssertEqual(vm.editedTimerItemId, editedTimerId)
    }
    
    func test_MainScreenVm_showNewEntryModal_updateModalShownAndEditTimerId() throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("showNewEntryModal")
        vm.showNewEntryTimerModal()
        let expectation = XCTestExpectation(description: "waitin for edited timer id and isEntryModalShown props")
        
        vm.$editedTimerItemId
            .zip(vm.$isNewEntryModalShown)
            .dropFirst()
            .sink { value in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(vm.isNewEntryModalShown)
        XCTAssertNil(vm.editedTimerItemId)
    }
    
    func test_MainScreenVm_getEditedTimer_shouldReturnTimeEntryIfNotEmptyArray() throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("getEditedTimer")
        let editedTImer = vm.getEditedTimer()
        XCTAssertNil(editedTImer)
    }
    
    func test_MainScreenVm_getEditedTimer_shouldReturnNilIfEmptyArray() throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("Dummy timers getEditedTimer: ", DummyData.timers)
        let randomElement = DummyData.timers.randomElement()!
        vm.editedTimerItemId = randomElement.id
        vm.timers = DummyData.timers
        let editedTimer = vm.getEditedTimer()
        XCTAssertNotNil(editedTimer)
        XCTAssertEqual(editedTimer?.id, randomElement.id)
    }
    
    func test_MainScreenVm_updateMainScreenVmProp_shouldUpdateProps() throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("updateMainScreenVmProp")
        XCTAssertEqual(vm.isLoading, false)
        vm.updateMainScreenVmProp(for: \.isLoading, newValue: true)
        let expectation = XCTestExpectation(description: "wait for update prop")
        vm.$isLoading
            .dropFirst()
            .sink { _ in
            expectation.fulfill()
        }
        .store(in: &cancellables)
        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(vm.isLoading, true)
    }
    
    func test_MainScreenVm_me_shouldUpdateEMailPropIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("me success")
        await vm.me()
        
        let expectation = XCTestExpectation(description: "wait for me response")
        vm.$email
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(vm.email, DummyData.email)
    }
    
    func test_MainScreenVm_me_shouldNotUpdateEMailPropIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        print("me throws")
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        await vm.me()
        
        let expectation = XCTestExpectation(description: "wait for me response")
        Publishers.Zip(vm.$email, vm.$isErrorShown)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(vm.email, "")
        XCTAssertEqual(vm.isErrorShown, true)
    }
    
    func test_MainScreenVm_getStats_shouldUpdateStatsTodayWeeklyAndMonthlyDurationIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("getStats success")
        await vm.getStats()
        
        let expectation = XCTestExpectation(description: "wait for get stats response")
        Publishers.Zip4(vm.$stats,
                        vm.$todayTotalDurationWithActiveTimer,
                        vm.$thisWeekDurationWithActiveTimer,
                        vm.$thisMonthDurationWithActiveTimer)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(vm.stats?.byDate.count, DummyData.stats.byDate.count)
        XCTAssertEqual(vm.stats?.byInterval.count, DummyData.stats.byInterval.count)
        XCTAssertEqual(vm.isErrorShown, false)
    }
    
    func test_MainScreenVm_getStats_shouldNOTUpdateStatsTodayWeeklyAndMonthlyDurationAndUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("getStats success")
        await vm.getStats()
        
        let expStats = XCTestExpectation(description: "wait for get stats response")
        vm.$isErrorShown
            .sink { _ in
                expStats.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expStats], timeout: 1)
        XCTAssertNil(vm.stats)
        XCTAssertEqual(vm.isErrorShown, true)
        XCTAssertEqual(vm.todayTotalDurationWithActiveTimer, "00:00")
        XCTAssertEqual(vm.thisWeekDurationWithActiveTimer, "00:00")
        XCTAssertEqual(vm.thisMonthDurationWithActiveTimer, "00:00")
    }
    
    func test_MainScreenVm_getTimers_shouldUpdateTimerstotalDurationMapAndShouldStartLocalTimerIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("getTimers success")
        print("Dummy timers: ", DummyData.timers)
        let date = Date()
        let dateTotalDuration = DummyData.timers.reduce(0, { partialResult, timeEntry in
            return partialResult + timeEntry.totalDuration
        })
        
        await vm.getTimers(date: date)
        
        let expectation = XCTestExpectation(description: "wait for get timers response")
        Publishers.Zip(vm.$timers, vm.$totalDurationMap)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expectation], timeout: 1)
        
        XCTAssertEqual(vm.timers.count, DummyData.timers.count)
        XCTAssertEqual(vm.totalDurationMap[date.startOfDayISO], dateTotalDuration)
    }
    
    func test_MainScreenVm_getTimers_shouldNOTUpdateTimerstotalDurationMapUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("getTimers throws")
        await vm.getTimers(date: Date())
        
        let expTimers = XCTestExpectation(description: "wait for get timers response")
        vm.$isErrorShown
            .sink { _ in
                expTimers.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expTimers], timeout: 1)
        
        XCTAssertEqual(vm.timers.count, 0)
        XCTAssertEqual(vm.timers.isEmpty, true)
        XCTAssertEqual(vm.isErrorShown, true)
    }
    
    func test_MainScreenVm_getTasks_shouldUpdateTasksIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("getTasks success")
        await vm.getTasks(projectId: 1)
        let expectation = XCTestExpectation(description: "waiting for get tasks response")
        vm.$tasks
            .sink { newTasks in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertEqual(vm.tasks.count, DummyData.tasks.count)
        XCTAssertEqual(vm.tasks, DummyData.tasks)
    }
    
    func test_MainScreenVm_getTasks_shouldNOTUpdateTasksAndUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("getTasks throws")
        let expectation = XCTestExpectation(description: "waiting for getTasks response")
        vm.$isErrorShown
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await vm.getTasks(projectId: 1)
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(vm.isErrorShown)
        XCTAssertEqual(vm.tasks.count, 0)
        XCTAssertTrue(vm.tasks.isEmpty)
    }
    
    func test_MainScreenVm_refetch_shouldUpdateProjectsTimersStatsMeIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("refetch success")
        print("dummy timers: ", DummyData.timers)
        await vm.refetch(date: Date())
        let expectation = XCTestExpectation(description: "waiting for refetch response")
        let expectationProjects = XCTestExpectation(description: "waiting for refetch projects response")
        vm.$projects
            .sink { newProjects in
                expectationProjects.fulfill()
            }
            .store(in: &cancellables)
        Publishers.Zip3(vm.$timers,
                        vm.$stats,
                        vm.$email)
        .sink { output in
            expectation.fulfill()
        }
        .store(in: &cancellables)
        
        await fulfillment(of: [expectation, expectationProjects], timeout: 1)
        XCTAssertEqual(vm.projects, DummyData.projects)
        XCTAssertEqual(vm.timers.count, DummyData.timers.count)
        XCTAssertEqual(vm.stats?.byDate.count, DummyData.stats.byDate.count)
        XCTAssertEqual(vm.stats?.byInterval.count, DummyData.stats.byInterval.count)
        XCTAssertEqual(vm.email, DummyData.email)
    }
    
    func test_MainScreenVm_refetch_shouldNOTUpdateProjectsTimersStatsMeAndUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("refetch throws")
        let expectation = XCTestExpectation(description: "waiting for refetch response")
        vm.$isErrorShown
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await vm.refetch(date: Date())
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(vm.isErrorShown)
        XCTAssertEqual(vm.email, "")
        XCTAssertEqual(vm.timers.count, 0)
        XCTAssertEqual(vm.projects.count, 0)
        XCTAssertEqual(vm.tasks.count, 0)
    }
    
    func test_MainScreenVm_logTimer_shouldUpdateTimersStatsIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("logTimer success")
        let projectId = DummyData.logTimerProjectId
        let projectTaskId = DummyData.logTimerTaskId
        let duration = "0:40"
        let notes = "notes"
        let date = Date()
        
        XCTAssertEqual(vm.timers.count, 0)
        
        let expectation = XCTestExpectation(description: "waiting for log timer response")
        let expProjects = XCTestExpectation()
        let expTasks = XCTestExpectation()
        
        // update tasks and projects to their initial state
        vm.updateMainScreenVmProp(for: \.tasks, newValue: DummyData.tasks)
        vm.updateMainScreenVmProp(for: \.projects, newValue: DummyData.projects)
        
        vm.$projects
            .sink { newProjects in
                expProjects.fulfill()
            }
            .store(in: &cancellables)
        
        vm.$tasks
            .sink { newTasks in
                expTasks.fulfill()
            }
            .store(in: &cancellables)
        
        await vm.logTimer(projectId: projectId, projectTaskId: projectTaskId, duration: duration, notes: notes, date: date)
        
        vm.$timers
            .sink { newTimers in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation, expTasks, expProjects], timeout: 1)
        XCTAssertEqual(vm.timers.last?.id, Int(DummyData.loggedTimerInfoId))
    }
    
    func test_MainScreenVm_logTimer_shouldNOTUpdateTimersStatsAndUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("logTimer throws")
        let expectation = XCTestExpectation(description: "waiting for log timer response")
        vm.$isErrorShown
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await vm.logTimer(projectId: DummyData.logTimerProjectId,
                          projectTaskId: DummyData.logTimerProjectId,
                          duration: "0:40",
                          notes: "notes",
                          date: Date())
        await fulfillment(of: [expectation], timeout: 1)
        XCTAssertTrue(vm.isErrorShown)
    }
    
    func test_MainScreenVm_updateTimer_shouldUpdateTimersAndStatsIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("updatedTimer success")
        print("Dummy timers: ", DummyData.timers)
        let updatedNotes = "updated notes"
        let expectation = XCTestExpectation(description: "wait for updateTimer response")
        let expEditedTimer = XCTestExpectation(description: "wait for updateTimer response")
        let expTimers = XCTestExpectation(description: "wait for updateTimer response")
        
        vm.updateMainScreenVmProp(for: \.editedTimerItemId, newValue: DummyData.timers[0].id)
        vm.$editedTimerItemId
            .dropFirst()
            .sink { _ in
                expEditedTimer.fulfill()
            }
            .store(in: &cancellables)
        vm.updateMainScreenVmProp(for: \.timers, newValue: DummyData.timers)
        vm.$timers
            .sink { _ in
                expTimers.fulfill()
            }
            .store(in: &cancellables)
        await vm.updateTimer(projectTaskId: DummyData.timers[0].taskId,
                             duration: "0:40",
                             notes: updatedNotes,
                             startsAt: Date().startOfDayISO,
                             endsAt: Date().endOfDayISO)
        
        vm.$timers
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation, expTimers, expEditedTimer], timeout: 1)
        XCTAssertEqual(vm.timers[0].notes, updatedNotes)
    }
    
    func test_MainScreenVm_updateTimer_shouldNOTUpdateTimersAndStatsAndUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("updatedTimer throws")
        print("Dummy timers: ", DummyData.timers)
        let updatedNotes = "updated notes"
        let expUpdateTimer = XCTestExpectation(description: "wait for updateTimer response")
        let expEditedTimer = XCTestExpectation(description: "wait for updateTimer response")
        let expTimers = XCTestExpectation(description: "wait for updateTimer response")
        
        vm.updateMainScreenVmProp(for: \.editedTimerItemId, newValue: DummyData.timers[0].id)
        vm.$editedTimerItemId
            .dropFirst()
            .sink { _ in
                expEditedTimer.fulfill()
            }
            .store(in: &cancellables)
        vm.updateMainScreenVmProp(for: \.timers, newValue: DummyData.timers)
        vm.$timers
            .sink { _ in
                expTimers.fulfill()
            }
            .store(in: &cancellables)
        await vm.updateTimer(projectTaskId: DummyData.timers[0].taskId,
                             duration: "0:40",
                             notes: updatedNotes,
                             startsAt: Date().startOfDayISO,
                             endsAt: Date().endOfDayISO)
        
        vm.$timers
            .sink { _ in
                expUpdateTimer.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expUpdateTimer, expTimers, expEditedTimer], timeout: 3)
        XCTAssertNotEqual(vm.timers[0].notes, updatedNotes)
        XCTAssertTrue(vm.isErrorShown)
    }
    
    func test_MainScreenVm_removeTimer_shouldDeleteItemFromTimersAndUpdateStatsIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("removeTimer success")
        print("Dummy timers: ", DummyData.timers)
        let expTimersInitial = XCTestExpectation()
        let expTimersAfterRemove = XCTestExpectation()
        
        vm.updateMainScreenVmProp(for: \.timers, newValue: DummyData.timers)
        vm.$timers
            .sink { _ in
                expTimersInitial.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expTimersInitial], timeout: 1)
        XCTAssertEqual(vm.timers.count, DummyData.timers.count)
        await vm.removeTimer(id: DummyData.timers[0].id, selectedDate: Date())
        
        vm.$timers
            .sink { _ in
                expTimersAfterRemove.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expTimersAfterRemove], timeout: 1)
        XCTAssertEqual(vm.timers.count, DummyData.timers.count - 1)
    }
    
    func test_MainScreenVm_removeTimer_shouldNOTDeleteItemFromTimersAndUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("removeTimer throws")
        print("Dummy timers: ", DummyData.timers)
        let expTimersInitial = XCTestExpectation()
        let expTimersAfterRemove = XCTestExpectation()
        
        vm.updateMainScreenVmProp(for: \.timers, newValue: DummyData.timers)
        vm.$timers
            .sink { _ in
                expTimersInitial.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expTimersInitial], timeout: 2)
        XCTAssertEqual(vm.timers.count, DummyData.timers.count)
        await vm.removeTimer(id: DummyData.timers[0].id, selectedDate: Date())
        
        vm.$timers
            .sink { _ in
                expTimersAfterRemove.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expTimersAfterRemove], timeout: 1)
        XCTAssertEqual(vm.timers.count, DummyData.timers.count)
        XCTAssertTrue(vm.isErrorShown)
    }
    
    func test_MainScreenVm_startTimer_shouldAddItemToTimersAndUpdateStatsActiveTimersSecondIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("startTimer success")
        let expProjects = XCTestExpectation()
        let expTasks = XCTestExpectation()
        let expActiveTimer = XCTestExpectation()
        
        // update tasks and projects to their initial state
        vm.updateMainScreenVmProp(for: \.tasks, newValue: DummyData.tasks)
        vm.updateMainScreenVmProp(for: \.projects, newValue: DummyData.projects)
        
        vm.$projects
            .sink { _ in
                expProjects.fulfill()
            }
            .store(in: &cancellables)
        
        vm.$tasks
            .sink { _ in
                expTasks.fulfill()
            }
            .store(in: &cancellables)
        
        let expStartTimer = XCTestExpectation()
        await vm.startTimer(projectId: 1,
                            projectTaskId: 1,
                            notes: "started notes")
        
        vm.$timers
            .sink { _ in
                expStartTimer.fulfill()
            }
            .store(in: &cancellables)
        
        vm.$activeTimerSeconds
            .dropFirst()
            .sink { val in
                expActiveTimer.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expStartTimer, expTasks, expProjects, expActiveTimer], timeout: 1)
        XCTAssertEqual(vm.timers.count, 1)
        XCTAssertEqual(vm.timers.last?.id, Int(DummyData.startedTimerId))
        XCTAssertNotEqual(vm.activeTimerSeconds, 0.0)
    }
    
    func test_MainScreenVm_startTimer_shouldNOTAddItemToTimerAndActiveTimersSecondAndUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("startTimer throw")
        let expStartTimer = XCTestExpectation(description: "wait for start timer response")
        await vm.startTimer(projectId: 1,
                            projectTaskId: 1,
                            notes: "started notes")
        vm.$isErrorShown
            .sink { _ in
                expStartTimer.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expStartTimer], timeout: 1)
        XCTAssertEqual(vm.timers.count, 0)
        XCTAssertEqual(vm.activeTimerSeconds, 0.0)
        XCTAssertTrue(vm.isErrorShown)
    }
    
    func test_MainScreenVm_stopTimer_shouldUpdateItemFromTimersAndUpdateStatsAndActiveTimersSecondIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("stopTimer success")
        print("Dummy timers: ", DummyData.timers)
        let expTimers = XCTestExpectation()
        let expActiveTimer = XCTestExpectation()
        let expStopTimer = XCTestExpectation()
        // update tasks and projects to their initial state
        vm.updateMainScreenVmProp(for: \.timers, newValue: DummyData.timers)
        
        vm.$timers
            .sink { _ in
                expTimers.fulfill()
            }
            .store(in: &cancellables)
        
        await vm.stopTimer(for: DummyData.stoppedTimerId)
        
        vm.$timers
            .sink { _ in
                expStopTimer.fulfill()
            }
            .store(in: &cancellables)
        
        vm.$activeTimerSeconds
            .sink { val in
                expActiveTimer.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expStopTimer, expTimers, expActiveTimer], timeout: 2)
        XCTAssertEqual(vm.activeTimerSeconds, 0.0)
    }
    
    func test_MainScreenVm_stopTimer_shouldNOTAddItemToTimersAndUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("stopTimer throws")
        let expStopTimer = XCTestExpectation()
        await vm.stopTimer(for: DummyData.stoppedTimerId)
        vm.$isErrorShown
            .sink { _ in
                expStopTimer.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expStopTimer], timeout: 1)
        XCTAssertTrue(vm.isErrorShown)
    }
    
    func test_MainScreenVm_restartTimer_shouldUpdateItemFromTimersAndUpdateStatsAndActiveTimersSecondIfNOTThrows() async throws {
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("restartTimer success")
        print("Dummy timers: ", DummyData.timers)
        let expTimers = XCTestExpectation()
        let expActiveTimer = XCTestExpectation()
        
        // update tasks and projects to their initial state
        vm.updateMainScreenVmProp(for: \.timers, newValue: DummyData.timers)
        
        vm.$timers
            .sink { _ in
                expTimers.fulfill()
            }
            .store(in: &cancellables)
        
        let expRestartTimer = XCTestExpectation()
        await vm.restartTimer(for: DummyData.restartedTimerId)
        
        vm.$timers
            .sink { timers in
                expRestartTimer.fulfill()
            }
            .store(in: &cancellables)
        
        vm.$activeTimerSeconds
            .dropFirst()
            .sink { val in
                expActiveTimer.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expRestartTimer, expTimers, expActiveTimer], timeout: 2)
        XCTAssertEqual(vm.timers[0].totalDuration, DummyData.restartedTotalDuration)
        XCTAssertNotEqual(vm.activeTimerSeconds, 0.0)
    }
    
    func test_MainScreenVm_restartTimer_shouldNOTAddItemToTimersAndUpdateIsErrorShownIfThrows() async throws {
        vm = MainScreenViewModel(networkSource: MockNetworkManagerErrorThrows())
        guard let vm = vm else {
            XCTFail("vm not found")
            return
        }
        print("restartTimer throws")
        let expStopTimer = XCTestExpectation()
        await vm.stopTimer(for: DummyData.stoppedTimerId)
        vm.$isErrorShown
            .sink { _ in
                expStopTimer.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expStopTimer], timeout: 1)
        XCTAssertTrue(vm.isErrorShown)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
