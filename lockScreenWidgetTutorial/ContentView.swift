//
//  ContentView.swift
//  lockScreenWidgetTutorial
//
//  Created by 최동권 on 2022/08/25.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button("start10") {
                print("start")
                if let UserDefaultsAppGroup = UserDefaults(suiteName: "group.ccdkk") {
                    UserDefaultsAppGroup.set(10, forKey: "lockScreen")
                    WidgetCenter.shared.reloadAllTimelines()
                }
                
                print("end")
            }
            Button("start20") {
                print("start")
                if let UserDefaultsAppGroup = UserDefaults(suiteName: "group.ccdkk") {
                    UserDefaultsAppGroup.set(20, forKey: "lockScreen")
                    WidgetCenter.shared.reloadAllTimelines()
                }
                print("end")
            }
        }
        .padding()
    }
    
    func setupTimer() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
