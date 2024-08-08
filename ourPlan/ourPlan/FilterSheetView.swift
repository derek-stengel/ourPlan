//
//  FilterSheetView.swift
//  ourPlan
//
//  Created by Derek Stengel on 8/8/24.
//

import Foundation
import MapKit
import SwiftUI

struct FilterSheetView: View {
    @Binding var stateFilter: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Filter by State")) {
                    TextField("Enter state", text: Binding(
                        get: { stateFilter ?? "" },
                        set: { stateFilter = $0 }
                    ))
                }
            }
            .navigationBarItems(trailing: Button("Done") {
                // Apply the filter, if necessary
                // For simplicity, just dismiss the sheet
                UIApplication.shared.endEditing()
            })
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

