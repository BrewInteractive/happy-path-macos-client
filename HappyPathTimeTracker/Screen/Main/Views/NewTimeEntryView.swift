//
//  NewTimeEntryView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 30.06.2023.
//

import SwiftUI
import Combine

struct NewTimeEntryView: View {
    let selectedDate: Date
    let onCancel: (() -> Void)
    let onSuccess: (() -> Void)
    
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    @State private var notes: String = ""
    @State private var duration: String = "" // hour
    @State private var selectedProjectId = -1
    @State private var selectedTaskId = -1
    
    init(selectedDate: Date,
         onCancel: @escaping () -> Void,
         onSuccess: @escaping () -> Void) {
        self.selectedDate = selectedDate
        self.onCancel = onCancel
        self.onSuccess = onSuccess
    }
        
    var isSaveButtonDisable: Bool {
        return selectedTaskId == -1 || selectedProjectId == -1 || mainScreenVm.isLoading
    }
    
    var title: String {
        return mainScreenVm.editedTimerItemId != nil ? "Edit Time Entry" : "New Time Entry"
    }
    
    var isEditMode: Bool {
        return mainScreenVm.editedTimerItemId != nil
    }
    
    var saveButtonTitle: String {
        if isEditMode {
            return "Update"
        } else if duration.isEmpty {
            return "Start"
        } else {
            return "Save"
        }
    }
    
    var body: some View {
        VStack {
            Text(title)
            TimeDividier()
            Spacer()
            if mainScreenVm.isTasksLoading {
                ProgressView()
            } else {
                NewTimeContentEntryView()
            }
            Spacer()
            BottomView()
        }
        .frame(width: 240)
        .padding()
        .onChange(of: selectedProjectId) { newSelectedProjectId in
            if newSelectedProjectId != -1 {
                mainScreenVm.getTasks(projectId: newSelectedProjectId)
            }
        }
        .onChange(of: duration, perform: { newDuration in
            if newDuration.count > 5 {
                duration = String(newDuration.prefix(5))
            }
        })
        .onAppear {
            if isEditMode {
                let editedTimer = mainScreenVm.getEditedTimer()
                guard let editedTimer = editedTimer else {
                    return
                }
                selectedProjectId = editedTimer.projectId
                selectedTaskId = editedTimer.taskId
                notes = editedTimer.notes
                duration = editedTimer.totalDuration.minuteToHours
            }
        }
    }
}

extension NewTimeEntryView {
    
    @ViewBuilder
    func NewTimeContentEntryView() -> some View {
        VStack {
            // project list will be shown here
            Picker(selection: $selectedProjectId) {
                ForEach(mainScreenVm.projects) { project in
                    Text(project.name)
                        .tag(project.id)
                }
            } label: {
                Text("Project")
                    .frame(width: 50, alignment: .leading)
            }
            .pickerStyle(.menu)
            .disabled(isEditMode)
            
            // task list will be shown here
            Picker(selection: $selectedTaskId) {
                ForEach(mainScreenVm.tasks) { task in
                    Text(task.name)
                        .tag(task.id)
                }
            } label: {
                Text("Task")
                    .frame(width: 50, alignment: .leading)
            }
            .pickerStyle(.menu)
            .disabled(isEditMode)
            
            HStack {
                ZStack {
                    TextEditor(text: $notes)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 2)
                        .border(.gray.opacity(0.2), width: 1)
                        .cornerRadius(5.0)
                    if notes.isEmpty {
                        Text("Add Notes")
                            .foregroundColor(.white.opacity(0.2))
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity,
                                   alignment: .topLeading)
                            .padding(6)
                    }
                }
                TextField("0:00", text: $duration)
                    .onReceive(Just(duration)) { newValue in
                        let filtered = newValue.filter { $0.isNumber || $0 == ":" }
                        if filtered != newValue {
                            self.duration = filtered
                        }
                    }
                    .padding(6)
                    .textFieldStyle(.plain)
                    .frame(maxHeight: .infinity)
                    .frame(width: 60)
                    .border(.gray.opacity(0.2), width: 1)
                    .cornerRadius(5.0)
            }
            .frame(minHeight: 40)
            
        }
    }
    
    @ViewBuilder
    func BottomView() -> some View {
        HStack {
            TimeDividier(color: .gray.opacity(0.2))
            Button {
                onCancel()
            } label: {
                Text("Cancel")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 1)
                    )
            }
            .buttonStyle(.borderless)
            Button {
                if isEditMode {
                    // because we can't update started timer, send startsAt with endsAt param
                    if let editedTimer = mainScreenVm.getEditedTimer() {
                        mainScreenVm.updateTimer(projectTaskId: editedTimer.taskId,
                                                 duration: duration,
                                                 notes: notes,
                                                 startsAt: editedTimer.startsAt,
                                                 endsAt: editedTimer.startsAt,
                                                 onSuccess: onSuccess)
                    } else {
                        print("error")
                    }
                } else {
                    if duration.isEmpty {
                        mainScreenVm.startTimer(projectTaskId: selectedTaskId,
                                                duration: "0",
                                                notes: notes)
                    } else {
                        mainScreenVm.logTimer(projectTaskId: selectedTaskId,
                                              duration: duration,
                                              notes: notes,
                                              date: selectedDate,
                                              onSuccess: onSuccess)
                    }
                }
            } label: {
                Text(saveButtonTitle)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background {
                        Color.green.opacity(0.5)
                    }
                    .cornerRadius(5)
            }
            .buttonStyle(.plain)
            .disabled(isSaveButtonDisable)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

struct NewTimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NewTimeEntryView(selectedDate: Date(), onCancel: {
            print("cancel")
        }, onSuccess: {
            print("success")
        })
    }
}
