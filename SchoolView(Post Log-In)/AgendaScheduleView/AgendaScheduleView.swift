//
//  AgendaScheduleView.swift
//  Unibell
//
//  Created by hyunsuh ham on 3/28/24.
//


import FirebaseFirestoreSwift
import Foundation
import FirebaseAuth
import FirebaseFirestore
import SwiftUI
import FirebaseStorage

struct AgendaScheduleView: View {
    @Environment(\.xLargePaddingSize) var xLargePaddingSize
    @Environment(\.largePaddingSize) var largePaddingSize
    @Environment(\.mediumPaddingSize) var mediumPaddingSize
    @Environment(\.smallPaddingSize) var smallPaddingSize
    @Environment(\.xSmallPaddingSize) var xSmallPaddingSize
    @Environment(\.xLargeFontSize) var xLargeFontSize
    @Environment(\.largeFontSize) var largeFontSize
    @Environment(\.mediumFontSize) var mediumFontSize
    @Environment(\.smallFontSize) var smallFontSize
    @Environment(\.xSmallFontSize) var xSmallFontSize
    @StateObject private var queryManager = FirestoreQueryManager()
    @State private var currentDate: Date = .init()
    @StateObject var loginModel = LoginViewViewModel()
    @State var sizeHeight: CGFloat = UIScreen.main.bounds.height
    @State var sizeWidth: CGFloat = UIScreen.main.bounds.width
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @Namespace private var animation
    @State private var createWeek: Bool = false
    @State private var createNewItem: Bool = false
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0, content: {
            
            HeaderView()
            
            ScrollView(.vertical) {
                
                VStack(alignment: .leading, spacing: 35) {
                    ForEach(queryManager.items) { item in
                        AgendaTasksRowView(scheduleModel: AgendaScheduleViewViewModel(userUID: loginModel.userUID), item: item)
                            .padding(mediumPaddingSize)
                    }
                    
                }
                .overlay {
                    if queryManager.items.isEmpty {
                        Text("No Tasks Found")
                            .font(.caption)
                            .foregroundStyle(Color(hex: "A0BAFA"))
                            .frame(width: 150)
                    }
                }
                .padding([.vertical, .leading], 15)
                .padding(.top, 15)
                .hSpacing(.center)
                .vSpacing(.center)
            }
            .scrollIndicators(.hidden)
        })
        .onAppear {
            updateQuery(with: currentDate)
        }
        
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                createNewItem.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(Color(hex: "2A48AE").shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
                
            })
            .padding(15)
        })
        .onAppear(perform: {
            if weekSlider.isEmpty {
                let currentWeek = Date().fetchWeek()
                
                if let firstDate = currentWeek.first?.date {
                    weekSlider.append(firstDate.createPreviousWeek())
                }
                weekSlider.append(currentWeek)
                
                if let lastDate = currentWeek.last?.date {
                    weekSlider.append(lastDate.createNextWeek())
                    
                }
            }
        })
        .sheet(isPresented: $createNewItem, content: {
            NewAgendaItemView(newItemPresented: Binding(get: {
                return true
            }, set: { _ in
            }))
            .presentationDragIndicator(.hidden)
            .interactiveDismissDisabled()
            .presentationCornerRadius(35)
            .presentationBackground(.white)
            
        })
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5){
                Text(currentDate.format("MMMM"))
                    .foregroundStyle(Color(hex: "2A48AE"))
                    .font(.system(size: 35))
                
                Text(currentDate.format("YYYY"))
                    .foregroundStyle(Color(hex: "A0BAFA"))
                    .font(.system(size: 35))
            }
            .fontWeight(.bold)
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(Color(hex: "B0D8EE"))
            
            //Week Slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never ))
            .frame(height: 90)
            
            
        }
        .padding(15)
        .hSpacing(.leading)
        .background(.white)
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
        
        
    }
    
    /// Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View{
        HStack(spacing: 0){
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("EE"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(Color(hex: "B0D8EE"))
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : Color(hex: "B0D8EE"))
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(Color(hex: "2A48AE"))
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            if day.date.isToday {
                                Circle()
                                    .fill(Color(hex: "2A48AE"))
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        })
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    /// Updating Current Date
                    withAnimation(.snappy) {
                        currentDate = day.date
                        updateQuery(with: currentDate)
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
    private func updateQuery(with date: Date) {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
      
        print("Updating query with collectionPath: \(uid) and date: \(date)")
        queryManager.updateQuery(userUID: uid, currentDate: date)
    }
    func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate =  weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            if let lastDate =  weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
        print(weekSlider.count)
    }
}
struct AgendaScheduleView_Previews: PreviewProvider {
    static var previews: some View{
        
        ContentView()
    }
}



