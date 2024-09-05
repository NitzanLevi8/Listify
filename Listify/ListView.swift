//
//  ListView.swift
//  Listify
//
//

import SwiftUI

struct ListView: View {
    var list: ListInfo?
    @State private var selection = Set<String>()
    @Environment(\.colorScheme) var colorScheme
    @State private var showSheet = false
    @EnvironmentObject var model:AppModel
    
    var body: some View {
        if let items:[ListItem] = model.lists?.first(where: {return $0.documentId == list?.documentId})?.items{
            if items.count == 0{
                Text("No items in this list").font(.sofiaMedium).opacity(0.7).padding(.top, 50)
            }
            List{
                ForEach(items){
                    item in
                    Item(item: item)
                }
                .onDelete(perform: { indexSet in
                    indexSet.forEach{
                        index in
                        Task{
                            guard let list = model.lists?.first(where: {$0.documentId == list?.documentId}), let itemId = list.items?[index].id else {return}
                            let result = try? await model.deleteItem(listId: list.documentId, itemId: itemId)
                        }
                    }
                })
                .listRowBackground(
                    colorScheme == .light ?
                    Color(red: 0.95, green: 0.95, blue: 0.95):
                        Color(red: 0.15, green: 0.15, blue: 0.15)
                )
            }.padding(.top, 10)
                .scrollContentBackground(.hidden)
                .navigationTitle(list?.name ?? "None")
                .toolbar {
                    EditButton()
                        .disabled(list?.items?.count == 0)
                        .font(.sofiaMedium)
                }
            Button {
                showSheet = true
            } label: {
                Label("Add Item", systemImage: "plus.square.fill.on.square.fill").font(.sofiaMedium)
                    .frame(maxWidth: .infinity)
                    .padding(6)
            }.buttonStyle(BorderedProminentButtonStyle())
                .padding(10)
                .sheet(isPresented: $showSheet) {
                    AddItemView(dismiss: {
                        showSheet = false
                    }, listId: list?.documentId)
                }
        }
    }
}

struct Item: View {
    var item: ListItem
    @State var isExpanded = false
    @State var image:UIImage?
    var body: some View {
        //Image
        HStack{
            if !isExpanded
            {
                HStack{
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width:20,height: 20)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                        .clipped()
                        .redacted(reason: image == nil ? .placeholder : [])
                    Text(item.title).font(.sofia(20))
                    Spacer()
                    Text("\(item.quantity)")
                        .foregroundStyle(.tint).opacity(0.85)
                }.task {
                    image = await AppModel.loadImage(item.imageUrl ?? "")
                }
                
            }else{
                VStack{
                    Text(item.title)
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .scaledToFit()
                    //                        .frame(width:50,height: 50)
                        .containerRelativeFrame(.horizontal){
                            size, axis in
                            return size * 0.9
                        }
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(15)
                        .clipped()
                        .frame(maxWidth: .infinity)
                        .redacted(reason: image == nil ? .placeholder : []);                    Spacer()
                    Text("\(item.quantity) items")
                        .foregroundStyle(.tint).opacity(0.85)
                }.padding(5)
                //                Spacer()
            }
        }
        .font(.sofiaMedium)
        //        .background(.red)
        .contentShape(Rectangle())
        .onTapGesture {
            isExpanded = !isExpanded
        }
    }
}

//#Preview {
//    ListView(list:
//        ListInfo(name: "Cool Shopping List", category: "Weird", items: [
//            ListItem(image: "", title: "Apples", quantity: 3),
//            ListItem(image: "", title: "Pineapple", quantity: 3)
//        ])
//    )
//}
