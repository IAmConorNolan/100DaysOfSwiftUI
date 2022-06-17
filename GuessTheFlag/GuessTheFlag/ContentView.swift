//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Conor Nolan on 16/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var alertIsShowing = false
    @State private var gameWon = false

    @State private var score = 0

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State private var correctAnswerIndex = Int.random(in: 0...2)

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack(alignment: .center, spacing: 5) {
                Text("Guess The Flag")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.heavy)
                    .padding()

                Section {
                    VStack {
                        VStack {
                            Text("Tap the flag of")
                                .font(.subheadline)
                                .fontWeight(.heavy)
                            Text("\(countries[correctAnswerIndex])")
                                .font(.title)
                                .fontWeight(.semibold)
                        }
                        VStack(alignment: .center, spacing: 20) {
                            ForEach(0...2, id: \.self) { index in
                                Button {
                                    flagTapped(index: index)
                                } label: {
                                    Image(countries[index])
                                        .renderingMode(.original)
                                        .clipShape(Capsule())
                                        .shadow(radius: 5)
                                }
                            }
                        }
                    }.padding()
                }

                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))


                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding()

            }.alert(isPresented: $alertIsShowing) {
                Alert(title: Text("You've lost!"),
                      message: Text("Your score was \(score)"),
                      dismissButton: .default(Text("Restart"), action: {
                    loadGame(resetScore: true)
                }))
            }
            .alert("You've won!", isPresented: $gameWon) {
                Button("Restart game") { loadGame(resetScore: true) }
            }
        }.ignoresSafeArea(.all)
    }

    func flagTapped(index: Int) {
        if index == correctAnswerIndex {
            score += 1
        } else {
            alertIsShowing = true
        }
        loadGame()
    }

    func loadGame(resetScore: Bool = false) {
        if (resetScore) { score = 0 }
        if (score == 8) {
            gameWon = true
            return
        }
        countries.shuffle()
        correctAnswerIndex = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
