//
//  BottomRect.swift
//  Help Widget
//
//  Created by Gustavo Diefenbach on 04/10/23.
//

import Foundation
import SwiftUI

struct BottomRectGstv: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadiusInside)
            Color("greySystem6")
            Image("gstv.logo")
                .padding(16)
        }
        .clipShape(
            .rect(
                topLeadingRadius: cornerRadiusInside,
                bottomLeadingRadius: cornerRadiusInside+16,
                bottomTrailingRadius: cornerRadiusInside+16,
                topTrailingRadius: cornerRadiusInside
            )
        )
        .shadow(radius: shadowValue)

    }
}
