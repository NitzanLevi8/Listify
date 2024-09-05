//
//  AllListsView.swift
//  Listify
//
//

import SwiftUI

struct AllListsView:View {
    @Binding var list:[ListInfo]?
    @State var counter: Int = 0
    @Binding var showAddList: Bool
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.font) private var font
    @EnvironmentObject private var model:AppModel
    @Binding var path:[ListInfo]

    var body: some View {
        NavigationStack(path: $path){
            if list == nil {
                    ProgressView()
            }
            else if list!.count == 0{
                
            }
            List{
                ForEach(model.lists ?? []) { item in
                    NavigationLink(value: item) {
                        ListInfoView(title: item.name, category: item.category)
                    }
                    .listRowBackground(
                        colorScheme == .light ?
                        Color(red: 0.95, green: 0.95, blue: 0.95):
                            Color(red: 0.15, green: 0.15, blue: 0.15)
                    ).tag(item.documentId)
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach { index in
                        if let id = list?[index].documentId {
                            model.deleteList(listId: id)
                        }
                    }
                    list?.remove(atOffsets: indexSet)
                })
            }
            .navigationDestination(for: ListInfo.self, destination: {
                info in
                ListView(list: info)
            })
            .refreshable {
                await model.getAllLists()
            }
            .background(colorScheme == .light ? .white:.black)
            .contentMargins(.top, 10)
            .scrollContentBackground(.hidden)
            .navigationTitleFont(name: "SofiaPro-Bold", size: 30)
            .navigationTitle("My Lists")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                        .disabled(list == nil || list?.count == 0)
                        .font(.sofia(18, .semibold))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddList = true
                    } label: {
                        Text("Add").font(.sofia(18, .semibold))
                        Image(systemName: "plus.circle").imageScale(.large)
                            .fontWeight(.semibold)
                    }
                }
            }.sheet(isPresented: $showAddList, content: {
                AddListView {
                    showAddList = false
                }
            })
            Spacer()
        }
    }
}

struct ListInfoView:View {
    var title: String
    var category: String
    
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .font(.sofia(20, .medium))
                Text(category)
            }
            .font(.sofia(16))
            .padding(10)
            Spacer()
            Image("").onTapGesture {
                
            }
        }
    }
}

struct AddListView: View {
    @State var name: String = ""
    @State var category: String = ""
    @State var date: Date = Date()
    @EnvironmentObject var model:AppModel
    var shouldClose: (()-> Void)?
//    var addList: ((_ name: String,_ category: String)-> Void)?
    //TODO: add to list
    
    var body: some View {
        VStack{
            HStack(alignment: .top) {
                Text("Add List")
                    .font(.sofia(28, .semibold))
                    .padding(.top, 20)
                Spacer()
                Button{
                    shouldClose?()
                } label: {
                    Text("Cancel")
                        .font(.sofia(18, .semibold))
                }
            }
            .alignmentGuide(.leading, computeValue: { dimension in
                return 0
            })
            .padding(.horizontal, 8)
            .padding(.top, 5)
            
            VStack{
                Field(title: "Name:", placeholder: "Shop list, plannings etc.", input: $name)
                Field(title: "Category:", placeholder: "Food, Work etc.", input: $category)
            }.padding(.horizontal, 5)
            DatePicker(selection: $date) {
                Text("Due Date")
            }
            .font(.sofia(20, .medium))
            .padding(10)
            .datePickerStyle(.compact)
            Spacer()
            Button {
                Task {
                    guard name != "" && category != "" else{ return };
                    do{
                        try await model.addList(info: ListInfo(name: name, category: category, date: Int(date.timeIntervalSince1970)))
                    } catch {}
                    shouldClose?()
                }
            } label: {
                Label("Add List", systemImage: "note.text.badge.plus").font(.sofiaMedium)
                    .frame(maxWidth: .infinity)
                    .padding(6)
                    .font(.sofiaMedium)
            }.buttonStyle(BorderedProminentButtonStyle())
            .disabled(name == "" || category == "")
            .padding(10)
            .buttonStyle(BorderedProminentButtonStyle())
        }
        .padding(10)
        Spacer()
    }
}
