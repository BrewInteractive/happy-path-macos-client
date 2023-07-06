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
    @State private var selectedProjectType: String = ""
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
            Picker("Add Project", selection: $selectedProjectType) {
                ForEach(["a", "b"], id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.segmented)
            
            Text("Add Project")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Add Task")
                .frame(maxWidth: .infinity, alignment: .leading)
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
