//
//  NewTimeEntryView.swift
//  HappyPathTimeTracker
//
//  Created by Gorkem Sevim on 30.06.2023.
//

import SwiftUI
import Combine

//TODO: secilen proje degistikten sonra beklenen surede kullanici yeni tasklar gelirken bekleyecegi icin bir loading ile process i kullaniciya gostermeliyiz

struct NewTimeEntryView: View {
    @EnvironmentObject var mainScreenVm: MainScreenViewModel
    @State private var notes: String = ""
    @State private var duration: String = ""
    @State private var selectedProjectId = -1
    @State private var selectedTaskId = -1
    let selectedDate: Date
    let onCancel: (() -> Void)
    let onSuccess: (() -> Void)
    
    init(selectedDate: Date,
         onCancel: @escaping () -> Void,
         onSuccess: @escaping () -> Void) {
        self.selectedDate = selectedDate
        self.onCancel = onCancel
        self.onSuccess = onSuccess
    }
        
    var isSaveButtonDisable: Bool {
        return selectedTaskId == -1 || selectedProjectId == -1
    }
    
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
        .onChange(of: selectedProjectId) { newSelectedProjectId in
            if newSelectedProjectId != -1 {
                mainScreenVm.getTasks(projectId: newSelectedProjectId)
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
                TextField("0", text: $duration)
                    .onReceive(Just(duration)) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
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
                mainScreenVm.logTimer(projectTaskId: selectedTaskId,
                                      duration: Int(duration) ?? 0,
                                      notes: notes, date: selectedDate,
                                      onSuccess: onSuccess)
            } label: {
                Text("Save")
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
