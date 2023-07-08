//
//  NewTimeEntryView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 30.06.2023.
//

import SwiftUI

struct NewTimeEntryView: View {
    @State private var notes: String = ""
    @State private var timeEntry: String = ""
    @State private var selectedProject: String = ""
    @State private var isProjectSelectorShown = false
    @State private var isTaskSelectorShown = false
    @State private var selectedTask: String = ""
    
    var body: some View {
        VStack {
            Text("New Time Entry")
            TimeDividier()
            Spacer()
            NewTimeContentEntryView()
            Spacer()
            BottomView()
        }
        .frame(width: 240)
        .padding()
    }
}

extension NewTimeEntryView {
    @ViewBuilder
    func NewTimeContentEntryView() -> some View {
        VStack {
            // project list will be shown here
            Text(selectedProject.isEmpty ? "Add Project" : selectedProject)
                .popover(isPresented: $isProjectSelectorShown) {
                    VStack {
                        ForEach(0..<4) { i in
                            Text("\(i)")
                                .onTapGesture {
                                    selectedProject = String(i)
                                    isProjectSelectorShown = false
                                }
                        }
                    }
                }
                .onTapGesture {
                    isTaskSelectorShown = false
                    isProjectSelectorShown.toggle()
                }
            
            // task list will be shown here
            Text(selectedTask.isEmpty ? "Add Task" : selectedTask)
                .popover(isPresented: $isTaskSelectorShown) {
                    VStack {
                        ForEach(0..<4) { i in
                            Text("\(i)")
                                .onTapGesture {
                                    selectedTask = String(i)
                                    isTaskSelectorShown = false
                                }
                        }
                    }
                }
                .onTapGesture {
                    isProjectSelectorShown = false
                    isTaskSelectorShown.toggle()
                }
            
            HStack {
                ZStack {
                    if notes.isEmpty {
                        Text("Add Notes")
                            .foregroundColor(Color(.placeholderTextColor))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 4)
                    }
                    TextEditor(text: $notes)
                }
                TextField("0:00", text: $timeEntry)
                    .textFieldStyle(.plain)
                    .frame(maxHeight: .infinity)
                    .frame(width: 60)
            }
            
        }
    }
    
    @ViewBuilder
    func BottomView() -> some View {
        HStack {
            Spacer()
            Button {
                print("Cancel")
            } label: {
                Text("Cancel")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.plain)
            Button {
                print("start timer")
            } label: {
                Text("Start")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background {
                        Color.green.opacity(0.5)
                    }
            }
            .buttonStyle(.plain)
        }
        .padding(.trailing, 8)
        .padding(.vertical, 8)
    }
}

struct NewTimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        NewTimeEntryView()
    }
}
