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

	@StateObject var loginModel = LoginViewViewModel()
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @Namespace private var animation
    @State private var createWeek: Bool = false
    @State private var createNewItem: Bool = false
    
	var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HeaderView()
            
            ScrollView(.vertical) {
                AgendaTasksView(currentDate: $currentDate, userUID: loginModel.userUID)
            }
            .scrollIndicators(.hidden)
        })
     
        .vSpacing(.top)
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                createNewItem.toggle()
            }, label: {
                Image(systemName: "plus")
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 55, height: 55)
                    .background(.black.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
                
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
                .presentationDetents([.height(300)])
                .interactiveDismissDisabled()
                .presentationCornerRadius(30)
                .presentationBackground(.white)
            
        })
	}
	
	@ViewBuilder
	func HeaderView() -> some View {
		VStack(alignment: .leading, spacing: 6) {
			HStack(spacing: 5){
				Text(currentDate.format("MMMM"))
					.foregroundStyle(.black)
                    .font(.system(size: 35))
                    
				Text(currentDate.format("YYYY"))
					.foregroundStyle(.gray)
                    .font(.system(size: 35))
			}
            .fontWeight(.bold)
			
			Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
				.fontWeight(.semibold)
				.textScale(.secondary)
				.foregroundStyle(.gray)
            
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
                        .foregroundStyle(.gray)
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(.black)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            if day.date.isToday {
                                Circle()
                                    .fill(.black)
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



