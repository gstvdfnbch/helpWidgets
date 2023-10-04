//
//  BottomRect.swift
//  Help Widget
//
//  Created by Gustavo Diefenbach on 04/10/23.
//

import Foundation
import SwiftUI

struct BottomRect: View{
    
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadiusInside)
            Color("greySystem6")
            Image("gstv.logo")
                .padding(16)
        }
        .cornerRadius(cornerRadiusInside+16)
        .shadow(radius: shadowValue)

    }
}
