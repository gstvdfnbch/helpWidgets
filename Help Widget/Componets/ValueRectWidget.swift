//
//  MiniWidget.swift
//  Help Widget
//
//  Created by Gustavo Diefenbach on 02/10/23.
//

import Foundation
import SwiftUI

struct ValueRectWidget: View {
    var data: BasicInfos
    
    private var valueString: (String,String) = ("","")
    
    init(data: BasicInfos) {
        self.data = data
        self.valueString = data.formatValue(data.value)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadiusInside) // Forma geométrica da borda
                .stroke(data.colorStroke.opacity(0.5), lineWidth: 6)
                .background(Color("greySystem6"))
            HStack(spacing: 16){
                VStack(alignment: .leading, spacing: 8) {
                    HStack{
                        Text(data.titleTop)
                            .font(.title3)
                            .fontWeight(.semibold)
                        Spacer()
                        if data.percent != 0.0 {
                            if data.percent > 0 {
                                Image(systemName: "arrow.up")
                                    .font(.title2)
                                    .foregroundColor(data.percentRule ? .green : .red)
                            } else {
                                Image(systemName: "arrow.down")
                                    .font(.title2)
                                    .foregroundColor(data.percentRule ? .red : .green)
                            }
                            
                            Spacer()
                        }
                        if !data.namedIcon.isEmpty {
                            Image(data.namedIcon)
                        }
                    }
                    HStack(spacing: 4){
                        Text(data.unit + " " + valueString.0 + "." + valueString.1)
                            .font(.title3)
                        Text(data.calc)
                            .font(.body)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    
                    if !data.subtitle.isEmpty {
                        Text(data.subtitle)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                    
                }

            }
            .padding(16)
        }
        .cornerRadius(cornerRadiusInside)
        .shadow(radius: shadowValue)
    }
}

