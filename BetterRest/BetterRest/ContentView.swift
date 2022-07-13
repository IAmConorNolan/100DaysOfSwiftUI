//
//  ContentView.swift
//  BetterRest
//
//  Created by Conor Nolan on 13/07/2022.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = defaultWakeTime
    @State private var dailyCoffee = 1
    @State private var hoursOfSleep = 8.0
    
    private static var defaultWakeTime: Date {
        let components = DateComponents(hour: 9, minute: 0)
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    DatePicker("Wake up time",
                               selection: $wakeUpTime,
                               displayedComponents: [.hourAndMinute])
                    
                    
                    Picker("Cups of coffee", selection: $dailyCoffee) {
                        ForEach(0..<20) { Text("\($0)") }
                    }
                    
                    Stepper("\(dailyCoffee) cups of coffee",
                            value: $dailyCoffee, in: 1...20)
                    
                    Stepper("\(hoursOfSleep.formatted()) hours sleep",
                            value: $hoursOfSleep,
                            in: 4...14,
                            step: 0.25)
                    
                    Section {
                        HStack {
                            Text("Suggested Bed Time")
                                .font(.body)
                                .bold()
                            Spacer()
                            Text(calculateSuggestedBedTime() ?? "")
                        }
                    }
                }
            }
            .navigationTitle("BetterRest 💤")
        }
    }
    
    private func calculateSuggestedBedTime() -> String? {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalc(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hoursInSeconds = components.hour ?? 0 * 60 * 60
            let minutesInSeconds = components.minute ?? 0 * 60
            
            let prediction = try model.prediction(wake: Double(hoursInSeconds + minutesInSeconds),
                                                  estimatedSleep: hoursOfSleep,
                                                  coffee: Double(dailyCoffee))
            
            let suggestedSleepTime = wakeUpTime - prediction.actualSleep
            
            return suggestedSleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            print(error)
        }
        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 13 mini")
    }
}
