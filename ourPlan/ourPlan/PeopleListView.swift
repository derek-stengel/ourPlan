//
//  PeopleListView.swift
//  ourPlan
//
//  Created by Derek Stengel on 7/30/24.
//

import Foundation
import SwiftUI
import Contacts
import MessageUI

struct PeopleListView: View {
    @StateObject private var viewModel = PeopleViewModel()
    @State private var showingAddPerson = false
    @State private var showingSyncContacts = false
    @State private var showingAlert = false
    @State private var messageRecipients: [String] = []
    @State private var showingMessageCompose = false
    @Binding var selectedColor: UIColor
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.contactsImported {
                    Spacer()
                    Button(action: {
                        showingSyncContacts = true
                    }) {
                        Text("Import Contacts")
                            .padding()
                            .background(Color(selectedColor))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.title2)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(groupedPeopleKeys, id: \.self) { key in
                            Section(header: Text(key).font(.headline).foregroundColor(.blue)) {
                                ForEach(groupedPeople[key] ?? []) { $person in
                                    HStack {
                                        Button(action: {
                                            person.isSelected.toggle()
                                        }) {
                                            Image(systemName: person.isSelected ? "circle.fill" : "circle")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(person.isSelected ? .blue : .gray)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        
                                        NavigationLink(destination: EditPersonView(person: $person)) {
                                            VStack(alignment: .leading) {
                                                Text(person.name)
                                                    .font(.headline)
                                                Text(person.job)
                                                    .font(.subheadline)
                                            }
                                        }
                                        .background(Color.clear) // Ensure the background is clear
                                    }
                                }
                                .onDelete { offsets in
                                    offsets.forEach { index in
                                        if let person = groupedPeople[key]?[index].wrappedValue {
                                            viewModel.deletePerson(by: person.id)
                                        }
                                    }
                                }
                            }
                        }
                        .onMove(perform: movePerson)
                    }
                    .navigationTitle("People")
                }
            }
            .navigationBarItems(
                leading: HStack {
                    if viewModel.contactsImported {
//                        EditButton()
                        Button(action: {
                            showingSyncContacts = true
                        }) {
                            VStack(alignment: .center, spacing: 12) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(selectedColor))
                                        .opacity(0.7)
                                        .frame(width: 75)
                                        .frame(height: 35)
                                    Text("Import")
                                        .padding(.horizontal)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                },
                trailing: HStack {
                    Button(action: sendMessage) {
                        Image(systemName: "message")
                    }
                    Button(action: {
                        showingAddPerson = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            )
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingSyncContacts) {
//                SyncContactsView1() // maybe fix this
                SyncContactsView(viewModel: viewModel) // maybe fix this
                    .onDisappear {
                        viewModel.contactsImported = true // Update the state on disappear
                    }
            }
            .sheet(isPresented: $showingMessageCompose) {
                MessageComposeView(recipients: messageRecipients, body: "")
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Incomplete Contact Information"),
                    message: Text("Some contacts do not have an email or phone number."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private func sendMessage() {
        viewModel.objectWillChange.send()
        DispatchQueue.main.async {
            messageRecipients = viewModel.people.filter { $0.isSelected }.compactMap {
                !$0.phoneNumber.isEmpty ? $0.phoneNumber : $0.email
            }
            
            if messageRecipients.isEmpty {
                showingAlert = true
            } else {
                showingMessageCompose = true
            }
        }
    }
    
    private func movePerson(from source: IndexSet, to destination: Int) {
        viewModel.people.move(fromOffsets: source, toOffset: destination)
    }
    
    // Simplified and broken down the groupedPeople and groupedPeopleKeys properties
    private var groupedPeople: [String: [Binding<Person>]] {
        // Step 1: Group people by their first letter
        let grouped = Dictionary(
            grouping: viewModel.people,
            by: { String($0.name.prefix(1).uppercased()) }
        )
        
        // Step 2: Convert the array to bindings
        var result = [String: [Binding<Person>]]()
        for (key, peopleArray) in grouped {
            result[key] = peopleArray.map { person in
                Binding(
                    get: { person },
                    set: { newValue in
                        if let index = viewModel.people.firstIndex(where: { $0.id == newValue.id }) {
                            viewModel.people[index] = newValue
                        }
                    }
                )
            }
        }
        return result
    }
    
    private var groupedPeopleKeys: [String] {
        groupedPeople.keys.sorted()
    }
}


struct MessageComposeView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    var recipients: [String]
    var body: String

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposeView

        init(_ parent: MessageComposeView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
            parent.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = context.coordinator
        messageComposeVC.recipients = recipients
        messageComposeVC.body = body
        return messageComposeVC
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
        // No update needed
    }

    static func dismantleUIViewController(_ uiViewController: MFMessageComposeViewController, coordinator: ()) {
        uiViewController.dismiss(animated: true, completion: nil)
    }
}

struct PeopleListView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleListView(selectedColor: .constant(.orange))
    }
}

//import Foundation
//import SwiftUI
//import Contacts
//import MessageUI
//
//struct PeopleListView: View {
//    @StateObject private var viewModel = PeopleViewModel()
//    @State private var showingAddPerson = false
//    @State private var showingSyncContacts = false
//    @State private var showingAlert = false
//    @State private var messageRecipients: [String] = []
//    @State private var showingMessageCompose = false
//    @Binding var selectedColor: UIColor
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if !viewModel.contactsImported {
//                    Spacer()
//                    Button(action: {
//                        showingSyncContacts = true
//                    }) {
//                        Text("Import Contacts")
//                            .padding()
//                            .background(Color(selectedColor))
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .font(.title2)
//                    }
//                    Spacer()
//                } else {
//                    List {
//                        ForEach(groupedPeopleKeys, id: \.self) { key in
//                            Section(header: Text(key).font(.headline).foregroundColor(.blue)) {
//                                ForEach(groupedPeople[key] ?? []) { $person in
//                                    HStack {
//                                        Button(action: {
//                                            person.isSelected.toggle()
//                                        }) {
//                                            Image(systemName: person.isSelected ? "circle.fill" : "circle")
//                                                .resizable()
//                                                .frame(width: 24, height: 24)
//                                                .foregroundColor(person.isSelected ? .blue : .gray)
//                                        }
//                                        .buttonStyle(PlainButtonStyle())
//                                        
//                                        NavigationLink(destination: EditPersonView(person: $person)) {
//                                            VStack(alignment: .leading) {
//                                                Text(person.name)
//                                                    .font(.headline)
//                                                Text(person.job)
//                                                    .font(.subheadline)
//                                            }
//                                        }
//                                        .background(Color.clear) // Ensure the background is clear
//                                    }
//                                }
//                                .onDelete { offsets in
//                                    offsets.forEach { index in
//                                        if let person = groupedPeople[key]?[index].wrappedValue {
//                                            viewModel.deletePerson(by: person.id)
//                                        }
//                                    }
//                                }
//                            }
//                        }
////                        .onMove(perform: movePerson)
//                    }
//                    .navigationTitle("People")
//                }
//            }
//            .navigationBarItems(
//                leading: HStack {
//                    if viewModel.contactsImported {
//                        EditButton()
//                        Button(action: {
//                            showingSyncContacts = true
//                        }) {
//                            VStack(alignment: .center, spacing: 12) {
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .fill(Color(selectedColor))
//                                        .opacity(0.7)
//                                        .frame(width: 75)
//                                        .frame(height: 35)
//                                    Text("Import")
//                                        .padding(.horizontal)
//                                        .fontWeight(.semibold)
//                                        .foregroundColor(.black)
//                                }
//                            }
//                        }
//                    }
//                },
//                trailing: HStack {
//                    Button(action: sendMessage) {
//                        Image(systemName: "message")
//                    }
//                    Button(action: {
//                        showingAddPerson = true
//                    }) {
//                        Image(systemName: "plus")
//                    }
//                }
//            )
//            .sheet(isPresented: $showingAddPerson) {
//                AddPersonView(viewModel: viewModel)
//            }
//            .sheet(isPresented: $showingSyncContacts) {
//                SyncContactsView(viewModel: viewModel)
//                    .onDisappear {
//                        viewModel.contactsImported = true // Update the state on disappear
//                    }
//            }
//            .sheet(isPresented: $showingMessageCompose) {
//                MessageComposeView(recipients: messageRecipients, body: "")
//            }
//            .alert(isPresented: $showingAlert) {
//                Alert(
//                    title: Text("Incomplete Contact Information"),
//                    message: Text("Some contacts do not have an email or phone number."),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//        }
//    }
//    
//    private func sendMessage() {
//        viewModel.objectWillChange.send()
//        DispatchQueue.main.async {
//            messageRecipients = viewModel.people.filter { $0.isSelected }.compactMap {
//                !$0.phoneNumber.isEmpty ? $0.phoneNumber : $0.email
//            }
//            
//            if messageRecipients.isEmpty {
//                showingAlert = true
//            } else {
//                showingMessageCompose = true
//            }
//        }
//    }
//    
////    private func movePerson(from source: IndexSet, to destination: Int) {
////        viewModel.people.move(fromOffsets: source, toOffset: destination)
////    }
//    
//    // Simplified and broken down the groupedPeople and groupedPeopleKeys properties
//    private var groupedPeople: [String: [Binding<Person>]] {
//        // Step 1: Group people by their first letter
//        let grouped = Dictionary(
//            grouping: viewModel.people,
//            by: { String($0.name.prefix(1).uppercased()) }
//        )
//        
//        // Step 2: Convert the array to bindings
//        var result = [String: [Binding<Person>]]()
//        for (key, peopleArray) in grouped {
//            result[key] = peopleArray.map { person in
//                Binding(
//                    get: { person },
//                    set: { newValue in
//                        if let index = viewModel.people.firstIndex(where: { $0.id == newValue.id }) {
//                            viewModel.people[index] = newValue
//                        }
//                    }
//                )
//            }
//        }
//        return result
//    }
//    
//    private var groupedPeopleKeys: [String] {
//        groupedPeople.keys.sorted()
//    }
//}
//
//
//struct MessageComposeView: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) var presentationMode
//    var recipients: [String]
//    var body: String
//
//    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
//        var parent: MessageComposeView
//
//        init(_ parent: MessageComposeView) {
//            self.parent = parent
//        }
//
//        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
//            controller.dismiss(animated: true)
//            parent.presentationMode.wrappedValue.dismiss()
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
//        let messageComposeVC = MFMessageComposeViewController()
//        messageComposeVC.messageComposeDelegate = context.coordinator
//        messageComposeVC.recipients = recipients
//        messageComposeVC.body = body
//        return messageComposeVC
//    }
//
//    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {
//        // No update needed
//    }
//
//    static func dismantleUIViewController(_ uiViewController: MFMessageComposeViewController, coordinator: ()) {
//        uiViewController.dismiss(animated: true, completion: nil)
//    }
//}
//
//struct PeopleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleListView(selectedColor: .constant(.orange))
//    }
//}
