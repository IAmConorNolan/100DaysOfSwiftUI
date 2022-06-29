//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Conor Nolan on 29/06/2022.
//

import SwiftUI

enum GameResult: CaseIterable {
    case win
    case lose

    var stringValue: String {
        switch self {
        case .win:
            return "win"
        case .lose:
            return "lose"
        }
    }
}

enum Weapon: CaseIterable {
    case rock
    case paper
    case scissors

    var stringValue: String {
        switch self {
        case .rock:
            return "🪨"
        case .paper:
            return "📃"
        case .scissors:
            return "✂️"
        }
    }
}

struct ContentView: View {
    @State private var score = 0
    @State private var numberOfQuestionsAsked = 0
    @State private var prompt: GameResult = .win
    @State private var challenge: Weapon = .rock
    @State private var scoreIsShowing = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan, .indigo], startPoint: .init(x: 0.3, y: 0.3), endPoint: .bottom)
                .ignoresSafeArea()
            VStack(spacing: 40) {
                Spacer()
                Text(challenge.stringValue)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20.0))
                    .font(.largeTitle)
                Text("versus")
                    .foregroundStyle(.white)
                    .bold()
                HStack(spacing: 10) {
                    ForEach(Weapon.allCases, id: \.self) { weapon in
                        Button {
                            weaponTapped(weapon)
                        } label: {
                            Text(weapon.stringValue)
                                .font(.largeTitle)
                        }

                    }
                }
                .padding()
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20.0))
                Spacer()
                Text("\(numberOfQuestionsAsked)/10")
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding()
                Text("Goal: \(prompt.stringValue.uppercased())")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .bold()
                    .padding()

            }
            .onAppear {
                newRound()
            }.alert("Your score was: \(score)", isPresented: $scoreIsShowing) {
                Button("Ok") {
                    numberOfQuestionsAsked = 0
                    score = 0
                    newRound()
                }
            }
        }
    }

    private func weaponTapped(_ weapon: Weapon) {
        var playerWon = false

        switch challenge {
        case .rock:
            playerWon = weapon == .paper
        case .paper:
            playerWon = weapon == .scissors
        case .scissors:
            playerWon = weapon == .rock
        }

        if (prompt == .win && playerWon || prompt == .lose && !playerWon) {
            score += 1
        } else {
            score -= 1
        }

        newRound()
    }

    private func newRound() {
        guard numberOfQuestionsAsked < 10 else {
            endGame()
            return
        }
        numberOfQuestionsAsked += 1
        challenge = .allCases.randomElement()!
        prompt = .allCases.randomElement()!
    }

    private func endGame() {
        scoreIsShowing.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
