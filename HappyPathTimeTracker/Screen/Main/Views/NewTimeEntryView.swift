//
//  NewTimeEntryView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 30.06.2023.
//

import SwiftUI
import Combine

struct NewTimeEntryView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    let selectedDate: Date
    @State private var notes: String = ""
    @State private var duration: String = "" // hour
    @State private var selectedProjectId = -1
    @State private var selectedTaskId = -1
    
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
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
        } else if duration.isEmpty && selectedDate.isToday {
            return "Start"
        } else {
            return "Save"
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                Text(title)
                    .foregroundColor(.Primary.DarkNight)
                HappyDividier()
                Spacer()
                NewTimeContentEntryView()
                Spacer()
                BottomView()
            }
            .frame(width: 240)
            .padding()
            .onChange(of: selectedProjectId) { newSelectedProjectId in
                if newSelectedProjectId != -1 {
                    Task {
                        await mainScreenVm.getTasks(projectId: newSelectedProjectId)
                    }
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
                    if editedTimer.id == mainScreenVm.activeTimerId {
                        duration = Int(mainScreenVm.activeTimerSeconds).secondsToHours
                    } else {
                        duration = editedTimer.totalDuration.minuteToHours
                    }
                }
            }
            
            if mainScreenVm.isTasksLoading {
                ZStack {
                    Color.Primary.DarkNight.opacity(0.2)
                    ProgressView()
                        .background {
                            Color.ShadesOfDark.D_04.opacity(0.3)
                        }
                }
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
                        .foregroundColor(project.id == selectedProjectId ? .Primary.DarkNight : .black)
                        .tag(project.id)
                }
            } label: {
                Text("Project")
                    .foregroundColor(.Primary.DarkNight)
                    .frame(width: 50, alignment: .leading)
            }
            .pickerStyle(.menu)
            .disabled(isEditMode)
            .preferredColorScheme(.light)
            
            
            // task list will be shown here
            Picker(selection: $selectedTaskId) {
                ForEach(mainScreenVm.tasks) { task in
                    Text(task.name)
                        .foregroundColor(task.id == selectedTaskId ? .Primary.DarkNight : .black)
                        .tag(task.id)
                }
            } label: {
                Text("Task")
                    .foregroundColor(.Primary.DarkNight)
                    .frame(width: 50, alignment: .leading)
            }
            .pickerStyle(.menu)
            .disabled(isEditMode)
            
            HStack {
                ZStack {
                    TextEditor(text: $notes)
                        .foregroundColor(.Primary.DarkNight)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 2)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0)
                                .strokeBorder(Color.ShadesofCadetGray.CadetGray200,
                                              style: StrokeStyle(lineWidth: 1.0))
                        )
                        .scrollContentBackground(.hidden)
                        .background(Color.ShadesofCadetGray.CadetGray50)
                    if notes.isEmpty {
                        Text("Add Notes")
                            .foregroundColor(.Primary.DarkNight)
                            .frame(maxWidth: .infinity,
                                   maxHeight: .infinity,
                                   alignment: .topLeading)
                            .padding(6)
                    }
                }
                TextField("0:00", text: $duration)
                    .textFieldStyle(.plain)
                    .padding(.leading, 4)
                    .frame(maxHeight: .infinity)
                    .frame(width: 60, height: 40)
                    .foregroundColor(.Primary.DarkNight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0)
                            .strokeBorder(Color.ShadesofCadetGray.CadetGray200,
                                          style: StrokeStyle(lineWidth: 1.0))
                    )
                    .scrollContentBackground(.hidden)
                    .background(Color.ShadesofCadetGray.CadetGray50)
                    .onReceive(Just(duration)) { newValue in
                        let filtered = newValue.filter { $0.isNumber || $0 == ":" }
                        if filtered != newValue {
                            self.duration = filtered
                        }
                    }
            }
            .frame(minHeight: 40)
            
        }
    }
    
    @ViewBuilder
    func BottomView() -> some View {
        HStack {
            HappyDividier(color: .gray.opacity(0.2))
            Button {
                self.mainScreenVm.updateMainScreenVmProp(for: \.isNewEntryModalShown, newValue: false)
            } label: {
                Text("Cancel")
                    .foregroundColor(.Primary.DarkNight)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.ShadesofCadetGray.CadetGray200, lineWidth: 2)
                    )
            }
            .buttonStyle(.borderless)
            Button {
                if isEditMode {
                    // because we can't update started timer, send startsAt with endsAt param
                    if let editedTimer = mainScreenVm.getEditedTimer() {
                        Task {
                            await mainScreenVm.updateTimer(projectTaskId: editedTimer.taskId,
                                                     duration: duration,
                                                     notes: notes,
                                                     startsAt: editedTimer.startsAt,
                                                     endsAt: editedTimer.startsAt)
                        }
                    } else {
                        print("error")
                    }
                } else {
                    if duration.isEmpty && selectedDate.isToday {
                        Task {
                            await mainScreenVm.startTimer(projectId: selectedProjectId,
                                                          projectTaskId: selectedTaskId,
                                                          notes: notes)
                        }
                    } else {
                        Task {
                            await mainScreenVm.logTimer(projectId: selectedProjectId,
                                                        projectTaskId: selectedTaskId,
                                                        duration: duration,
                                                        notes: notes,
                                                        date: selectedDate)
                        }
                    }
                }
            } label: {
                Text(saveButtonTitle)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background {
                        Color.ShadesOfTeal.Teal_400
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
        NewTimeEntryView(selectedDate: Date())
            .environmentObject(MainScreenViewModel())
            .background {
                Color.Primary.LightBabyPowder
            }
    }
}
