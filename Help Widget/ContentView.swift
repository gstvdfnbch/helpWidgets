//
//  ContentView.swift
//  Help Widget
//
//  Created by Gustavo Diefenbach on 02/10/23.
//

import SwiftUI


struct ContentView: View {
    @State private var isModalAddExpense = false
    
    private var startValue: Double = 700
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack{
                        VStack(spacing: 16){
                            HStack(spacing: 16){
                                Spacer()
                                Image(systemName: "chevron.left")
                                    .font(.title)
                                    .foregroundStyle(.secondary)
                                VStack{
                                    Text("October")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.primary)
                                    Text("07 - 14 October 2023")
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                }
                                Image(systemName: "chevron.right")
                                    .font(.title)
                                    .foregroundStyle(.secondary)

                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            HStack(spacing: 16) {
                                ValueRectWidget(data: startBalance(startValue))
                                ValueRectWidget(data: nowBalance(expansesOct, startValueCalc: startValue))
                                
                            }
                            HStack(spacing: 16) {
                                ValueRectWidget(data: calculateAverageGoal(expansesOct, startValueCalc: startValue))
                                ValueRectWidget(data: calculateExpenseTotal(expansesOct))
                            }
                            HStack{
                                Text("Chart Expenses")
                                    .foregroundStyle(.primary)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        ScrollView(.horizontal){
                            HStack(spacing: 16){
                                Spacer().frame(width: 0)
                                ChartsBarsWidget(title: "Weekly Expenses",
                                             sizeRect: geometry.size,
                                             expensesNow: expansesOct,
                                                 averageRule: calculateAverageGoal(expansesOct,startValueCalc: startValue).value)
                                
                                ChartsLineCompareWidget(title: "Monthly Expenses",
                                             sizeRect: geometry.size,
                                             expensesLast: calculateSummariesWithDates(expansesSet),
                                             expensesNow: calculateSummariesWithDates(expansesOct),
                                             averageRule: self.startValue)
                                Spacer().frame(width: 0)
                            }
                            .padding(.vertical, 6)
                        }
                        //.scrollClipDisabled()
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                        VStack(spacing: 16){
                            HStack{
                                Text("Expenses Review")
                                    .foregroundStyle(.primary)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            HStack(spacing: 16){
                                ValueRectWidget(data: calculateAverageMonthly(expansesOct, startValueCalc: startValue))
                                ValueRectWidget(data: calculateAverageDaily(expansesOct, startValueCalc: startValue))
                            }
                            HStack(spacing: 16){
                                ValueRectWidget(data: todayExpense(expansesOct, startValueCalc: startValue))
                                ValueRectWidget(data: yesterdayExpense(expansesOct, startValueCalc: startValue))
                            }
                            BottomRect()
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .navigationTitle("Save money, #$&@%!")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                    Image(systemName: "plus.app")
                    .font(.title2)
                    .onTapGesture {
                        isModalAddExpense.toggle()
                    }
                )
                .sheet(isPresented: $isModalAddExpense) {
                    AddItemView()
                }
                //                .fullScreenCover(isPresented: $isModalAddExpense) {
                //                    AddItemView()
                //                }
            }
        }
    }
}

#Preview {
    ContentView()
}
