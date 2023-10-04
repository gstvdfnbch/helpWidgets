//
//  MainWidget.swift
//  Help Widget
//
//  Created by Gustavo Diefenbach on 02/10/23.
//

import Foundation
import SwiftUI
import Charts

struct ChartsLineCompareWidget: View {
    
    var sizeRect: CGSize
    var titleChart: String
    var expensesLast: [DataDoublePair]?
    var expensesNow: [DataDoublePair]
    var averageRule: Double
    
    let valueGridFix: Int = 20
    
    
    init(title: String, sizeRect: CGSize, expensesLast: [DataDoublePair]? = nil, expensesNow: [DataDoublePair], averageRule: Double) {
        self.titleChart = title
        self.sizeRect = sizeRect
        self.expensesLast = expensesLast
        self.expensesNow = expensesNow
        self.averageRule = averageRule
    }
    
    var body: some View {
        ZStack{
            Color("greySystem6")
            VStack(alignment: .leading){
                Text(self.titleChart)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                AnimatedBarCharts()
            }
            .padding(16)
        }
        .cornerRadius(cornerRadiusInside)
        .shadow(radius: shadowValue)
        .frame(width: sizeRect.width * 0.80, height: sizeRect.height * 0.4)
    }
    
    @ViewBuilder
    func AnimatedBarCharts() -> some View {
        let maxAverage: Double = Double((Int(self.averageRule/Double(valueGridFix)) * 5 / 4) * valueGridFix)
        
        let maxNow = self.expensesNow.max { item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        let maxLast = self.expensesLast?.max { item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        let max = maxNow>maxLast ? maxNow : maxLast
        
        let maxWithMargin: Double = Double((Int(max/Double(valueGridFix)) + 1) * valueGridFix)
        
        let calendar = Calendar.current
        Chart{
            ForEach(self.expensesNow){ day in
                LineMark(
                    x: .value("Day", day.date, unit: .day),
                    y: .value("R$", day.showData ? day.value : 0),
                    series: .value("Daily expenses Now", "DEN")
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.green)
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
                
            }
            ForEach(expensesLast ?? []){ day in
                LineMark(
                    x: .value("Day", day.date,unit: .day),
                    y: .value("R$", day.showData ? day.value : 0),
                    series: .value("Daily expenses Last", "DEL")
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.green.gradient.opacity(0.3))
                .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round))
            }
            RuleMark( y: .value("R$", self.averageRule))
                .interpolationMethod(.catmullRom)
                .foregroundStyle(.orange)
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, dash: [7, 12]))
        }
        .chartXAxis {
            AxisMarks(values: expensesNow.map { $0.date}) { date in
                AxisValueLabel(format: .dateTime.day(.twoDigits))
            }
        }
        //.chartXScale(domain: minDate...maxDate)
        .chartYScale(domain: 0...(maxAverage>maxWithMargin ? maxAverage : maxWithMargin))
        .onAppear {
            for (index,_) in expansesWeek.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05){
                    withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)){
                        expansesWeek[index].showData = true
                    }
                }
            }
        }
    }
}
