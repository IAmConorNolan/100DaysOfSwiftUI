//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Conor Nolan on 17/06/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Happy Pride! #100DaysOfSwiftUI")
            .font(.title.bold())
            .foregroundStyle(.white)
            .padding()
            .background(.red)
            .padding()
            .background(.orange)
            .padding()
            .background(.yellow)
            .padding()
            .background(.green)
            .padding()
            .background(.blue)
            .padding()
            .background(.indigo)
            .padding()
            .background(.purple)
            .blur(radius: 2)
    }
}

struct Pride: ViewModifier {
    typealias Body = <#type#>

    func body(cont)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.sizeThatFits)
    }
}
