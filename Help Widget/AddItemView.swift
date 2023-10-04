//
//  AddItemView.swift
//  Help Widget
//
//  Created by Gustavo Diefenbach on 02/10/23.
//

import Foundation

import SwiftUI


struct AddItemView: View {
    @State private var selectedDate = Date()
    
    @State private var textValue = "R$ 0,00"
    @State private var tagValue = ""

    @FocusState private var isKeyboardShow: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 16) {
                VStack(spacing: 8){
                    Text("Move down to close")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.down")
                        .foregroundColor(.secondary)
                    Divider()
                }
                HStack{
                    Image(systemName: "calendar")
                        .font(.title)
                        .foregroundStyle(.secondary)
                    DatePicker("Selecione uma Data", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .scaledToFit()
                        .labelsHidden()
                }
                TextField("R$ 0,00", text: $textValue)
                    .keyboardType(.numberPad)
                    .textFieldStyle(PlainTextFieldStyle()) // Elimina el estilo de borde
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .focused($isKeyboardShow)
                TextField("#Tag", text: $tagValue)
                    .keyboardType(.default)
                    .textFieldStyle(PlainTextFieldStyle()) // Elimina el estilo de borde
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .focused($isKeyboardShow)
                Button(action: {
                    
                }, label: {
                    HStack{
                        Spacer()
                        Text("Registrar")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(16)
                        Spacer()
                    }
                })
                .background(Color.blue)
                .cornerRadius(cornerRadiusInside)
                .shadow(radius: shadowValue)
            }
            .padding(16)
        }
        .onAppear {
            isKeyboardShow = true
        }
    }

}

#Preview {
    AddItemView()
}
