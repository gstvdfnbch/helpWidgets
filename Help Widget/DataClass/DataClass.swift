//
//  DataClass.swift
//  Help Widget
//
//  Created by Gustavo Diefenbach on 02/10/23.
//

import Foundation
import SwiftUI

class BasicInfos {
    var titleTop: String
    var subtitle: String
    var unit: String
    var value: Double
    var percent: Double
    var percentRule: Bool
    var calc: String
    var color: Color
    var namedIcon: String
    var colorStroke: Color
    
    init(titleTop: String,
         subtitle: String? = nil,
         unit: String,
         value: Double,
         percent: Double? = nil,
         percentRule: Bool? = nil,
         calc: String? = nil,
         color: Color? = nil,
         namedIcon: String? = nil,
         colorStroke: Color? = nil) {
        
        self.titleTop = titleTop
        self.subtitle = subtitle ?? ""
        self.unit = unit
        self.value = value
        self.percent = percent ?? 0.0
        self.percentRule = percentRule ?? false
        self.calc = calc ?? ""
        self.color = color ?? Color.black
        self.namedIcon = namedIcon ?? "x"
        self.colorStroke = colorStroke ?? Color("greySystem6")
    }
    
    func formatValue(_ valor: Double) -> (String, String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let parteInteira = Int(valor)
        let parteDecimal = Int((valor - Double(parteInteira)) * 100) // Multiplica por 100 para obter os centavos como um número inteiro
        
        let parteInteiraFormatada = formatter.string(from: NSNumber(value: parteInteira)) ?? ""
        let parteDecimalFormatada = formatter.string(from: NSNumber(value: abs(parteDecimal))) ?? ""
        
        return (parteInteiraFormatada, parteDecimalFormatada)
    }
    
}



struct DataDoublePair: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
    var showData: Bool
    
    init(date: Date, value: Double) {
        self.date = date
        self.value = value
        self.showData = true
    }
    
}


func numberOfDaysInMonth(for date: Date) -> Int? {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    
    if let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
       let lastDayOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDayOfMonth) {
        let numberOfDays = calendar.component(.day, from: lastDayOfMonth)
        return numberOfDays
    }
    
    return nil
}

func calculateSummariesWithDates(_ list: [DataDoublePair]) -> [DataDoublePair] {
    var summaries: [DataDoublePair] = []
    var accumulated: Double = 0.0
    var lastSummationDate: Date?
    
    for item in list {
        accumulated += item.value
        lastSummationDate = item.date
        let summaryItem = DataDoublePair(date: lastSummationDate!, value: accumulated)
        summaries.append(summaryItem)
    }
    
    return summaries
}


func calculateAverageMonthly(_ list: [DataDoublePair], startValueCalc: Double) -> BasicInfos {
    var accumulated: Double = 0.0
    var percenteCalc: Double = 0.0
    var lastSummationDate: Date?
    
    for item in list {
        accumulated += item.value
        lastSummationDate = item.date
    }
    
    let maxDays: Int = numberOfDaysInMonth(for: lastSummationDate ?? Date()) ?? 31
    let average = startValueCalc/Double(maxDays)
    let averageSpent = accumulated/Double(list.count)
    
    percenteCalc = (averageSpent/average) - 1
    
    return BasicInfos(titleTop: "Average Spent",
                      subtitle: "Average daily spending you have done so far.",
                      unit: "R$",
                      value: averageSpent,
                      percent: percenteCalc,
                      calc: "/ day")
}

func calculateAverageDaily(_ list: [DataDoublePair], startValueCalc: Double) -> BasicInfos {
    var accumulated: Double = 0.0
    var lastSummationDate: Date?
    
    for item in list {
        accumulated += item.value
        lastSummationDate = item.date
    }
    
    let maxDays: Int = numberOfDaysInMonth(for: lastSummationDate ?? Date()) ?? 31
    
    let left =  (startValueCalc - accumulated) / Double(maxDays-list.count)
    
    let averageGoal = startValueCalc/Double(maxDays)
    
    let percent = (left/averageGoal) - 1
    
    return BasicInfos(titleTop: "Average Left Over",
                      subtitle: "Average daily spending limit, but you won't.",
                      unit: "R$",
                      value: left,
                      percent: percent,
                      percentRule: true,
                      calc: "/ day")
}

func todayExpense(_ list: [DataDoublePair], startValueCalc: Double) -> BasicInfos {
    var valueReturn: Double = 0
    var percentSign: Double = 0
    
    if let value = list.last?.value {
        valueReturn = value
    }
    
    let averageGoal = calculateAverageGoal(expansesOct, startValueCalc: startValueCalc).value
    
    percentSign = (valueReturn/averageGoal) - 1
    
    return BasicInfos(titleTop: "Today",
                      subtitle: "How much you spent today.",
                      unit: "R$",
                      value: valueReturn,
                      percent: percentSign)
}

func yesterdayExpense(_ list: [DataDoublePair], startValueCalc: Double) -> BasicInfos {
    let valueReturn: Double = list[list.count - 2].value
    var percentSign: Double = 0
    
    let averageGoal = calculateAverageGoal(expansesOct, startValueCalc: startValueCalc).value
    
    percentSign = (valueReturn/averageGoal) - 1
    
    return  BasicInfos(titleTop: "Yesterday",
                       subtitle: "How much you spent yesterday.",
                       unit: "R$",
                       value: valueReturn,
                       percent: percentSign)
    //return DataDoublePair(date: lastSummationDate!, value: average )
}

func startBalance(_ balance: Double) -> BasicInfos {
    
    return  BasicInfos(titleTop: "Start Balance",
                       //subtitle: "Big expenses, salary and all fixed bills.",
                       unit: "R$",
                       value: balance,
                       namedIcon: "start")
}

func nowBalance(_ list: [DataDoublePair], startValueCalc: Double) -> BasicInfos {
    let spent = calculateExpenseTotal(list).value
    let now = startValueCalc + spent
    return BasicInfos(titleTop: "Actual Balance",
                      //subtitle: "The current situation calls for spending only needed!",
                      unit: "R$",
                      value: now,
                      namedIcon: "wallet")
    
}

func calculateAverageGoal(_ list: [DataDoublePair], startValueCalc: Double) -> BasicInfos {
    var averageGoal: Double = 0.0
    let lastSummationDate: Date = list[0].date
    
    let maxDays: Int = numberOfDaysInMonth(for: lastSummationDate ) ?? 31
    
    averageGoal = startValueCalc/Double(maxDays)
    
    return BasicInfos(titleTop: "Average Goal",
                      subtitle: "This is THE right way! :)",
                      unit: "R$",
                      value: averageGoal,
                      calc: "/ day",
                      namedIcon: "target",
                      colorStroke: Color.yellow)
}

func calculateExpenseTotal(_ list: [DataDoublePair]) -> BasicInfos {
    var accumulated: Double = 0.0
    
    for item in list {
        accumulated += item.value
    }
    
    return  BasicInfos(titleTop: "Spent So Far",
                       subtitle: "Remenber to save money!",
                       unit: "R$",
                       value: -accumulated,
                       namedIcon: "expenses")
}

// Crie uma lista de pares DataDoublePair com datas e valores específicos
var expansesWeek: [DataDoublePair] = [
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 1).date!, value: 20.72),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 2).date!, value: 15.31),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 3).date!, value: 25.12),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 4).date!, value: 18.20),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 5).date!, value: 22.33),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 6).date!, value: 12.30),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 7).date!, value: 28.02),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 8).date!, value: 14.60),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 9).date!, value: 17.00),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 10).date!, value: 23.83),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 11).date!, value: 19.94),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 12).date!, value: 26.45),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 13).date!, value: 14.27),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 14).date!, value: 30.53),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 15).date!, value: 27.80),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 16).date!, value: 11.95),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 17).date!, value: 29.04),
]

var expansesOct: [DataDoublePair] = [
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 1).date!, value: 20.72),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 2).date!, value: 15.31),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 3).date!, value: 25.12),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 4).date!, value: 18.20),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 5).date!, value: 22.33),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 6).date!, value: 12.30),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 7).date!, value: 28.02),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 8).date!, value: 14.60),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 9).date!, value: 17.00),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 10).date!, value: 23.83),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 11).date!, value: 19.94),
    //    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 12).date!, value: 26.45),
    //    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 13).date!, value: 14.27),
    //    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 14).date!, value: 30.53),
    //    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 15).date!, value: 27.80),
    //    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 16).date!, value: 11.95),
    //    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 10, day: 17).date!, value: 29.04),
]

var expansesSet: [DataDoublePair] = [
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 1).date!, value: 22.27),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 2).date!, value: 13.32),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 3).date!, value: 20.30),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 4).date!, value: 25.64),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 5).date!, value: 10.04),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 6).date!, value: 20.13),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 7).date!, value: 30.89),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 8).date!, value: 29.27),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 9).date!, value: 13.32),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 10).date!, value: 20.30),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 11).date!, value: 15.64),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 12).date!, value: 30.04),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 13).date!, value: 20.13),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 14).date!, value: 30.89),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 15).date!, value: 26.27),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 16).date!, value: 13.32),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 17).date!, value: 20.30),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 18).date!, value: 25.64),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 19).date!, value: 10.04),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 20).date!, value: 22.13),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 21).date!, value: 30.89),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 22).date!, value: 22.27),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 23).date!, value: 13.32),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 24).date!, value: 20.30),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 25).date!, value: 15.64),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 26).date!, value: 35.04),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 27).date!, value: 10.13),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 28).date!, value: 27.89),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 29).date!, value: 13.04),
    DataDoublePair(date: DateComponents(calendar: Calendar.current, year: 2023, month: 9, day: 30).date!, value: 20.13)
]
