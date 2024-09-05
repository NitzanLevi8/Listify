//
//  HomeView.swift
//  Listify
//

import Foundation
import SwiftUI

struct HomeView: View {
    var upNext: ListInfo?
    var openUpNext: ((_: ListInfo)-> Void)?
    var openAddList: (()-> Void)?
    var body: some View {
        VStack(alignment: .leading){
            Text("Listify")
                .font(.sofia(35, .bold))
                .padding(.leading, 15)
                .padding(.top, 15)
                .padding(.bottom, 8)
            
                if upNext != nil{
                    Text("Up Next")
                        .font(.sofia(22, .semibold))
                        .padding(.leading, 15)
                    UpNext(listInfo: upNext!, openUpNext: openUpNext)
                    Text("Your next task, make it done").font(.sofiaMedium).opacity(0.7).padding(.leading, 18)
                }else{
                    Spacer()
                    Text("You do not have any lists").font(.sofia(20, .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 8)
                    //                    .padding(10)
                    Label("Add a list", systemImage: "note.text.badge.plus").font(.sofia(18, .semibold))
                        .foregroundStyle(.tint)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            openAddList?()
                        }
                }
            
            Spacer()
        }
    }
}

struct UpNext: View {
    var listInfo: ListInfo
    var openUpNext: ((_ listInfo: ListInfo)-> Void)?
    var daysLeft: Int = 0
    @Environment(\.colorScheme) var colorScheme

    init(listInfo: ListInfo, openUpNext: ((_: ListInfo) -> Void)? = nil) {
        self.listInfo = listInfo
        self.openUpNext = openUpNext
        if let date = listInfo.date {
            self.daysLeft = Calendar.current.dateComponents([.day], from: .now, to: Date(timeIntervalSince1970: TimeInterval(date))).day ?? 0
        }
    }
    
    var body: some View{
        VStack(alignment: .leading){
            Text(listInfo.name)
            .font(.sofia(22, .semibold))
            Text(listInfo.category)
                .padding(.vertical, 8)
                .padding(.horizontal,10)
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
            HStack{
                Spacer()
                Text("\(daysLeft > 0 ? daysLeft : 0) Days left")
            }
        }
        .font(.sofia(18, .medium))
        .padding(20).background(colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9) : Color(red: 0.15, green: 0.15, blue: 0.15))
            .contextMenu(ContextMenu(menuItems: {
                Button {
                   openUpNext?(listInfo)
                } label: {
                    Text("Open")
                }
            }))
            .onTapGesture {
                    openUpNext?(listInfo)
            }
            .cornerRadius(10)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
    }
}

