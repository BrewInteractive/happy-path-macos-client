//
//  StartNewTimerViewModel.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 12.02.2024.
//

import Foundation

@MainActor
final class StartNewTimerViewModel: ObservableObject {
    var mainScreenVm: MainScreenViewModel? = nil
    
    let selectedDate: Date
    @Published var projectSearchText: String = ""
    @Published var taskSearchText: String = ""
    @Published var selectedProjectId: Int? = nil
    @Published var selectedTaskId: Int? = nil
    @Published var notes: String = ""
    @Published var duration: Date = .nowAt(.startOfDay)
    @Published var isErrorShown = false
    
    init(selectedDate: Date, selectedTimerEntry: TimeEntry?) {
        self.selectedDate = selectedDate
        
        if selectedTimerEntry != nil {
            _selectedProjectId = Published(wrappedValue: selectedTimerEntry!.projectId)
            _selectedTaskId = Published(wrappedValue: selectedTimerEntry!.taskId)
            _notes = Published(wrappedValue: selectedTimerEntry!.notes)
            
            let durationHour = selectedTimerEntry!.totalDuration / 60
            let durationMinute = selectedTimerEntry!.totalDuration - durationHour * 60
            let newDurationDate = Date(year: selectedDate.year, month: selectedDate.month, day: selectedDate.day, hour: durationHour, minute: durationMinute)
            _duration = Published(wrappedValue: newDurationDate)
        }
    }
    
    var isSelectProjectViewShown: Bool {
        return selectedProjectId == nil || (mainScreenVm?.isTasksLoading ?? false)
    }
    
    var isSelectTaslViewShown: Bool {
        return selectedProjectId != nil && selectedTaskId == nil
    }
    
    var isSaveViewShown: Bool {
        return selectedProjectId != nil && selectedTaskId != nil
    }
    
    var isEditMode: Bool {
        return mainScreenVm?.editedTimerItemId != nil
    }
    
    var saveButtonTitle: String {
        if isEditMode {
            return "Update"
        } else if !isDurationSelected && selectedDate.isToday {
            return "Start"
        } else {
            return "Save"
        }
    }
    
    var filteredProjectList: [Project] {
        guard let mainScreenVm = mainScreenVm else { return [] }
        return projectSearchText.isEmpty ? mainScreenVm.projects : mainScreenVm.projects.filter({  $0.name.lowercased().contains(projectSearchText.lowercased())})
    }
    
    var filteredTaskList: [ProjectTask] {
        guard let mainScreenVm = mainScreenVm else { return [] }
        return taskSearchText.isEmpty ? mainScreenVm.tasks : mainScreenVm.tasks.filter({  $0.name.lowercased().contains(taskSearchText.lowercased())})
    }
    
    var isDurationSelected: Bool {
        duration.hour != 0 || duration.minute != 0
    }
    
    func selectProjectItem(item: Project) async  {
        selectedProjectId = item.id
        await mainScreenVm?.getTasks(projectId: item.id)
    }
    
    func checkIsFormValid() -> Bool {
        if notes.isEmpty {
            isErrorShown = true
            return false
        }
        
        return true
    }
    
    var title: String {
        guard let mainScreenVm = mainScreenVm else { return "" }
        if selectedProjectId == nil || mainScreenVm.isTasksLoading {
            return "Select Project"
        } else if selectedProjectId != nil && selectedTaskId == nil {
            return "Select Task"
        } else if selectedProjectId != nil && selectedTaskId != nil {
            return "What are you working on?"
        }
        
        return ""
    }
    
    func initData(mainScreenVm: MainScreenViewModel) {
        self.mainScreenVm = mainScreenVm
    }
    
    func logOrUpdateTimer() async {
        guard let mainScreenVm = mainScreenVm else { return }
        if checkIsFormValid() {
            
            if isEditMode {
                // because we can't update started timer, send startsAt with endsAt param
                if let editedTimer = mainScreenVm.getEditedTimer(), editedTimer.startsAt != nil {
                    let totalDurationAsMinute = duration.hour * 60 + duration.minute
                    Task {
                        await mainScreenVm.updateTimer(projectTaskId: editedTimer.taskId,
                                                       duration: totalDurationAsMinute,
                                                       notes: notes,
                                                       startsAt: editedTimer.startsAt!,
                                                       endsAt: editedTimer.startsAt!)
                        HappyLogger.logger.log("Updated timer with id: \(editedTimer.taskId)")
                    }
                } else {
                    HappyLogger.logger.error("Error occured while updating timer")
                }
            } else {
                if !isDurationSelected && selectedDate.isToday {
                    Task {
                        await mainScreenVm.startTimer(projectId: selectedProjectId!,
                                                      projectTaskId: selectedTaskId!,
                                                      notes: notes)
                        HappyLogger.logger.log("Started a new timer with project id: \(self.selectedProjectId!) and task id: \(self.selectedTaskId!)")
                    }
                } else {
                    let totalDurationAsMinute = duration.hour * 60 + duration.minute
                    Task {
                        await mainScreenVm.logTimer(projectId: selectedProjectId!,
                                                    projectTaskId: selectedTaskId!,
                                                    duration: totalDurationAsMinute,
                                                    notes: notes,
                                                    date: selectedDate)
                        HappyLogger.logger.log("Logged a new timer with project id: \(self.selectedProjectId!) and task id: \(self.selectedTaskId!)")
                    }
                }
            }
        }
    }
}
