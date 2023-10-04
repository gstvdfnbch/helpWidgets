//
//  AddExpensesButton.swift
//  Help Widget
//
//  Created by Gustavo Diefenbach on 03/10/23.
//

import Foundation
import SwiftUI

struct AddExpensesButton: View {
    @State private var isClicked = false
    
    var body: some View {
        ZStack {
            Image(systemName: "plus.app")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.blue)
        }
        .frame(maxWidth: 40, alignment: .center)

    }
}
