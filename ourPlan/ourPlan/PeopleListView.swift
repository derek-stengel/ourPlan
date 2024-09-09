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
    @State private var contactsImported = false
    @State private var showingAlert = false
    @State private var messageRecipients: [String] = []
    @State private var showingMessageCompose = false
    @Binding var selectedColor: UIColor
    
    var body: some View {
        NavigationView {
            VStack {
                if !contactsImported {
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
                    if contactsImported {
                        EditButton()
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
                SyncContactsView(viewModel: viewModel)
                    .onDisappear {
                        contactsImported = true
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
    @Environment(\.presentationMode) var presentationMode
    var recipients: [String]
    var body: String

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        var parent: MessageComposeView

        init(_ parent: MessageComposeView) {
            self.parent = parent
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true)
            parent.presentationMode.wrappedValue.dismiss()
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
//    @State private var contactsImported = false
//    @State private var showingAlert = false
//    @State private var messageRecipients: [String] = []
//    @State private var showingMessageCompose = false
//    @Binding var selectedColor: UIColor
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if !contactsImported {
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
//                                        .onDelete { offsets in
//                                            offsets.forEach { index in
//                                                if let person = groupedPeople[key]?[index].wrappedValue {
//                                                    viewModel.deletePerson(by: person.id)
//                                                }
//                                            }
//                                        }
//                                        .background(Color.clear) // Ensure the background is clear
//                                    }
//                                }
//                            }
//                        }
////                        .onDelete(perform: viewModel.deletePerson)
//                        .onMove(perform: movePerson)
//                    }
//                    .navigationTitle("People")
//                }
//            }
//            .navigationBarItems(
//                leading: HStack {
//                    if contactsImported {
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
//                        contactsImported = true
//                    }
//            }
//            .sheet(isPresented: $showingMessageCompose) {
//                MessageComposeView(recipients: messageRecipients, body: "")
//            }
//            .alert(isPresented: $showingAlert) {
//                Alert(
//                    title: Text("Incomplete Contact Information"),
//                    message: Text("Some contacts do not have an email or phone number and will not be included."),
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
//    private func movePerson(from source: IndexSet, to destination: Int) {
//        viewModel.people.move(fromOffsets: source, toOffset: destination)
//    }
//    
////    private var groupedPeople: [String: [Binding<Person>]] {
////        Dictionary(
////            grouping: $viewModel.people,
////            by: { $0.name.wrappedValue.prefix(1).uppercased() }
////        )
////    }
////    
////    private var groupedPeopleKeys: [String] {
////        groupedPeople.keys.sorted()
////    }
////}
//    
//    private var groupedPeople: [String: [Binding<Person>]] {
//        // Step 1: Group people by their first letter
//        let grouped = Dictionary(
//            grouping: viewModel.people,
//            by: { $0.name.prefix(1).uppercased() }
//        )
//        
//        // Step 2: Convert the array to bindings
//        return grouped.mapValues { peopleArray in
//            peopleArray.map { person in
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
//    }
//    
//    private var groupedPeopleKeys: [String] {
//        groupedPeople.keys.sorted()
//    }
//}
//
//// background items for sending / opening messages app
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
//
//struct PeopleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleListView(selectedColor: .constant(.orange))
//    }
//}


//import Foundation
//import SwiftUI
//import Contacts
//import MessageUI
//
//struct PeopleListView: View {
//    @StateObject private var viewModel = PeopleViewModel()
//    @State private var showingAddPerson = false
//    @State private var showingSyncContacts = false
//    @State private var contactsImported = false // Track if contacts have been imported
//    @State private var showingAlert = false
//    @State private var messageRecipients: [String] = []
//    @State private var showingMessageCompose = false
//    @Binding var selectedColor: UIColor
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if !contactsImported {
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
//                                                .foregroundColor(person.isSelected ? .blue : .gray)
//                                        }
//                                        if !person.isSelected {
//                                            NavigationLink(destination: EditPersonView(person: $person)) {
//                                                VStack(alignment: .leading) {
//                                                    Text(person.name)
//                                                        .font(.headline)
//                                                    Text(person.job)
//                                                        .font(.subheadline)
//                                                }
//                                            }
//                                        } else {
//                                            VStack(alignment: .leading) {
//                                                Text(person.name)
//                                                    .font(.headline)
//                                                Text(person.job)
//                                                    .font(.subheadline)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                        .onDelete(perform: viewModel.deletePerson)
//                        .onMove(perform: movePerson)
//                    }
//                    .navigationTitle("People")
//                }
//            }
//            .navigationBarItems(leading: HStack {
//                if contactsImported {
//                    EditButton()
//                    Button(action: {
//                        showingSyncContacts = true
//                    }) {
//                        Image(systemName: "person.2.circle")
//                    }
//                }
//                Button(action: sendMessage) {
//                    Image(systemName: "message")
//                }
//            }, trailing: Button(action: {
//                showingAddPerson = true
//            }) {
//                Image(systemName: "plus")
//            })
//            .sheet(isPresented: $showingAddPerson) {
//                AddPersonView(viewModel: viewModel)
//            }
//            .sheet(isPresented: $showingSyncContacts) {
//                SyncContactsView(viewModel: viewModel)
//                    .onDisappear {
//                        contactsImported = true
//                    }
//            }
//            .sheet(isPresented: $showingMessageCompose) {
//                MessageComposeView(recipients: messageRecipients, body: "")
//            }
//            .alert(isPresented: $showingAlert) {
//                Alert(
//                    title: Text("Incomplete Contact Information"),
//                    message: Text("Some contacts do not have an email or phone number and will not be included."),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//        }
//    }
//    
//    // Function to handle sending messages
//    private func sendMessage() {
//        
//        viewModel.objectWillChange.send() // force a refresh of the bindings
//        // Delay the execution of the following code to ensure the UI updates first
//        DispatchQueue.main.async {
//        messageRecipients = viewModel.people.filter { $0.isSelected }.compactMap {
//            !$0.phoneNumber.isEmpty ? $0.phoneNumber : $0.email
//        }
//        
//        if messageRecipients.isEmpty {
//            showingAlert = true
//        } else {
//            showingMessageCompose = true
//        }
//    }
//}
//
//    // Function to handle moving people in the list
//    private func movePerson(from source: IndexSet, to destination: Int) {
//        viewModel.people.move(fromOffsets: source, toOffset: destination)
//    }
//
//    // Grouping people by the first letter of their name
//    private var groupedPeople: [String: [Binding<Person>]] {
//        Dictionary(
//            grouping: $viewModel.people,
//            by: { $0.name.wrappedValue.prefix(1).uppercased() }
//        )
//    }
//
//    // Sorted keys for sections
//    private var groupedPeopleKeys: [String] {
//        groupedPeople.keys.sorted()
//    }
//}
//
//
//// background items for sending / opening messages app
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
//
//struct PeopleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleListView(selectedColor: .constant(.orange))
//    }
//}
//
