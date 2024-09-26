////
////  FilterSheetView.swift
////  ourPlan
////
////  Created by Derek Stengel on 8/8/24.
////
//
//import Foundation
//import MapKit
//import SwiftUI
//
//struct FilterSheetView: View {
//    @Binding var stateFilter: String?
//    @ObservedObject var viewModel: MapViewModel
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Filter by State")) {
//                    TextField("Enter state", text: Binding(
//                        get: { stateFilter ?? "" },
//                        set: { stateFilter = $0 }
//                    ))
//                }
//            }
//            .navigationBarItems(trailing: Button("Done") {
//                if let state = stateFilter, !state.isEmpty {
//                    viewModel.applyStateFilter(state)  // Implement this method in your ViewModel
//                }
//                // For simplicity, just dismiss the sheet
//                UIApplication.shared.endEditing()
//            })
//        }
//    }
//}
//
//struct FilterSheetView_Preview: PreviewProvider {
//    static var previews: some View {
//        // Create a State variable for the preview
//        // We need a @State variable of type String?
//        @State var stateFilter: String? = "UT"
//        
//        // Provide an instance of MapViewModel
//        FilterSheetView(stateFilter: $stateFilter, viewModel: MapViewModel())
//            .preferredColorScheme(.light) // Optional: Set preferred color scheme for preview
//            .previewLayout(.sizeThatFits)  // Optional: Use size that fits for the preview
//            .padding() // Optional: Add padding to the preview
//    }
//}
//
//extension UIApplication {
//    func endEditing() {
//        sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
//
