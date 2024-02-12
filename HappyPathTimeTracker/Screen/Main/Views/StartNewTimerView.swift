//
//  StartNewTimerView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 7.02.2024.
//

import Foundation
import SwiftUI
import Combine

struct StartNewTimerView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    @StateObject private var startNewTimerVm: StartNewTimerViewModel
    @FocusState private var isTaskNoteFocussed
    
    init(selectedDate: Date, selectedTimerEntry: TimeEntry?) {
        self._startNewTimerVm = StateObject(wrappedValue: StartNewTimerViewModel(selectedDate: selectedDate, selectedTimerEntry: selectedTimerEntry))
    }
    
    var body: some View {
        ZStack {
            Color.ShadesOfDark.D_32
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(Color.Primary.RealWhite)
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text(startNewTimerVm.title)
                            .font(.figtree(size: 19, weight: .medium))
                            .foregroundStyle(Color.Primary.DarkNight)
                        Spacer()
                        Button(action: {
                            mainScreenVm.hideNewEntryTimerModal()
                        }, label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(Color.ShadesofCadetGray.CadetGray400)
                        })
                        .buttonStyle(.link)
                        .padding(.trailing, 2)
                    }
                    if startNewTimerVm.isSelectProjectViewShown {
                        SelectProjectView()
                    } else if startNewTimerVm.isSelectTaslViewShown {
                        SelectTaskView()
                    } else if startNewTimerVm.isSaveViewShown {
                        SaveTimerView()
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal, 16)
                
                if mainScreenVm.isTasksLoading || mainScreenVm.isLoading {
                    Loading()
                }
            }
            .frame(maxHeight: 450)
            .padding(.horizontal, 40)
            .padding(.vertical, 20)
        }
        .onAppear {
            startNewTimerVm.initData(mainScreenVm: mainScreenVm)
        }
    }
}

extension StartNewTimerView {
    @ViewBuilder
    func SelectProjectView() -> some View {
        VStack(alignment: .leading) {
            SearchBar(placeholder: "Search in projects", searchText: $startNewTimerVm.projectSearchText)
            
            List {
                ForEach(startNewTimerVm.filteredProjectList) { project in
                    Button(action: {
                        Task {
                            await startNewTimerVm.selectProjectItem(item: project)
                        }
                    }, label: {
                        Text(project.name)
                            .font(.figtree(size: 14, weight: .regular))
                            .foregroundStyle(Color.Primary.DarkNight)
                    })
                    .buttonStyle(.link)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0))
                }
            }
        }
    }
    
    @ViewBuilder
    func SelectTaskView() -> some View {
        VStack(alignment: .leading) {
            SearchBar(placeholder: "Search in tasks", searchText: $startNewTimerVm.taskSearchText)
            
            List {
                ForEach(startNewTimerVm.filteredTaskList) { task in
                    Button(action: {
                        startNewTimerVm.selectedTaskId = task.id
                    }, label: {
                        Text(task.name)
                            .foregroundStyle(Color.Primary.DarkNight)
                    })
                    .buttonStyle(.link)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: -10, bottom: 0, trailing: 0))
                }
            }
            Button(action: {
                startNewTimerVm.selectedProjectId = nil
            }, label: {
                HStack(spacing: 8) {
                    Image("chevron-left")
                        .resizable()
                        .foregroundColor(Color.Primary.CadetGray)
                        .frame(width: 20, height: 20)
                    Text("Back to Projects")
                }
                .foregroundStyle(Color.ShadesOfTeal.Teal_400)
            })
            .buttonStyle(.link)
        }
    }
    
    @ViewBuilder
    func SaveTimerView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                if startNewTimerVm.isErrorShown {
                    Text("Required for this project")
                        .font(.figtree(size:14, weight: .regular))
                        .foregroundStyle(Color.ShadesOfCoral.Coral700)
                }
                ZStack(alignment: .topLeading) {
                    if startNewTimerVm.notes.isEmpty && !isTaskNoteFocussed {
                        Text("Type here...")
                            .foregroundStyle(Color.ShadesofCadetGray.CadetGray500)
                            .padding(4)
                    }
                    TextEditor(text: $startNewTimerVm.notes)
                        .focused($isTaskNoteFocussed)
                        .foregroundColor(.Primary.DarkNight)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 2)
                        .onChange(of: startNewTimerVm.notes, perform: { value in
                            startNewTimerVm.isErrorShown = false
                        })
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(Color.ShadesofCadetGray.CadetGray200,
                                              style: StrokeStyle(lineWidth: 1.0))
                        )
                        .scrollContentBackground(.hidden)
                }
            }
            
            Text("Add Time")
                .font(.figtree(size: 14, weight: .medium))
                .foregroundStyle(Color.Primary.DarkNight)
            VStack {
                DatePicker("", selection: $startNewTimerVm.duration, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .colorInvert()
                    .colorMultiply(Color.ShadesofCadetGray.CadetGray200)
                HappyDividier()
                    .frame(maxWidth: .infinity)
            }
            
            Button(action: {
                Task {
                    await startNewTimerVm.logOrUpdateTimer()
                }
            }, label: {
                Text(startNewTimerVm.saveButtonTitle)
                    .foregroundStyle(Color.Primary.RealWhite)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 28)
                            .foregroundStyle(startNewTimerVm.isErrorShown ? Color.ShadesOfTeal.Teal_50 : Color.ShadesOfTeal.Teal_300)
                    }
            })
            .disabled(startNewTimerVm.isErrorShown)
            if !startNewTimerVm.isEditMode {
                Button(action: {
                    startNewTimerVm.selectedTaskId = nil
                }, label: {
                    HStack(spacing: 8) {
                        Image("chevron-left")
                            .resizable()
                            .foregroundColor(Color.Primary.CadetGray)
                            .frame(width: 20, height: 20)
                        Text("Back to Task")
                    }
                    .foregroundStyle(Color.ShadesOfTeal.Teal_400)
                })
                .buttonStyle(.link)
            }
        }
    }
}
