//
//  ContentView.swift
//  Listify
//

import SwiftUI

struct MainPage: View {
    @Binding var list: [ListInfo]?
    @State private var selection = 0
    @State private var path: [ListInfo] = []
    @State private var showAddList = false
    var upNextList: ListInfo? {
        return list?.sorted(by: { first, second in
                let _first = first.date ?? -1
                let _second = second.date ?? -1
                return _first > _second
        }).first
    }
    
    var body: some View {
        TabView(selection: $selection) {
            HomeView(upNext: upNextList,
                     openUpNext: { info in
                selection = 1
                if upNextList != nil{
                    path = [upNextList!]
                    print("Available")
                }else{
                    print("NON")
                }
            }, openAddList: {
                selection = 1
                showAddList = true
            })
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }.tag(0)
           
            AllListsView(list: $list, showAddList: $showAddList, path: $path)
                .tabItem {
                Label("Lists", systemImage: "list.dash")
            }
            .tag(1)
        }
        .tabsFont(name: "SofiaPro-Medium", size: 12)
    }
}

struct Field: View {
    var title: String
    var placeholder: String?
    var orientation: String = "v"
    @Binding var input: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if orientation == "v" {
            VStack(alignment: .leading){
                Text(title)
                    .font(.sofia(20, .medium))
                TextField(placeholder ?? "", text: $input)
                    .font(.sofia(18))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        colorScheme == .light ?
                        Color(red: 0.9, green: 0.9, blue: 0.9):
                            Color(red: 0.15, green: 0.15, blue: 0.15))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 7)
            .padding(.top, 4)
            .padding(.bottom, 6)
            .font(.system(size: 20))
        }else{
            HStack(alignment: .center){
                Text(title)
                TextField(placeholder ?? "", text: $input)
                    .font(.system(size: 18))
                    .padding(.vertical, 5)
                    .padding(.horizontal, 12)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
            }
        }
    }
}

//#Preview("All Lists"){
//    AllListsView(list: [ ListInfo(name: "shop list", category: "cat"), ListInfo(name: "shop list", category: "cat")])
//}

//#Preview("Main Page") {
//    MainPage()
//}
