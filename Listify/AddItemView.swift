import SwiftUI

struct AddItemView: View {
    @State var name: String = ""
    @State var quantity: String = ""
    @State var isPresented = true
    @State var isPicking = false
    @State var image: UIImage? = nil
    @State var opacity:Double = 1
    @GestureState var hovered = false
    @EnvironmentObject var model: AppModel
    @State var isLoading = false
    var title: String = ""
    var dismiss: (()-> Void)?
    var listId: String?

    var body: some View {
        Text(title).font(.system(size: 26)).fontWeight(.bold)
        VStack(alignment: .leading){
 
        VStack(alignment: .leading){
                HStack{
                    if(name != "" && Int(quantity) != nil){
                        Label("upload", systemImage: "arrow.up")
                            .imageScale(.medium)
                            .font(.sofia(18, .semibold))
                            .foregroundStyle(.tint)
                            .onTapGesture {
                            Task{
                                if isLoading {
                                    return;
                                }
                                isLoading = true
                                let info = ListItem(imageUrl: "", image: image, title: name, quantity: Int(quantity) ?? 0)
                                let result = try? await model.uploadItem(info: info, listId: listId)
                                if result == true{
                                    dismiss?()
                                }
                                isLoading = false
                            }
                        }
                    }
                    Spacer()
                    Text("cancel")
                        .foregroundStyle(.tint)
                        .font(.sofia(18, .semibold))
                        .onTapGesture {
                            if !isLoading {
                                dismiss?()
                            }
                    }
                    
                
                }.padding(10)
                Text("Add item to list: ")
                    .font(.sofia(24, .semibold)).padding(.vertical, 4).padding(.horizontal, 10)
                Field(title: "Name", placeholder: "Item name", orientation: "v", input: $name)
                Field(title: "Quantity", placeholder: "Amount of items", orientation: "v", input: $quantity)
                if image != nil{
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                        .frame(width:100,height: 100)
                        .containerRelativeFrame(.horizontal){
                            size, axis in
                            return size * 0.3
                        }
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                
                Label(image == nil ? "Add Image":"Change Image", systemImage: "photo.badge.plus")
                    .padding(10)
                    .padding(.horizontal, 10)
                    .background(.tint)
                    .foregroundStyle(.white)
                    .font(.sofia(18, .medium))
                    .opacity(hovered ? 0.7:1)
                    .onTapGesture {
                        if isLoading{
                            return;
                        }
                        if !isPicking{
                            isPicking = true
                        }
                    }
                    .gesture(DragGesture(minimumDistance: 0).updating($hovered, body: {
                        _, hovered, _ in
                        hovered = true
                    }))
                    .cornerRadius(15)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)

            }.font(.system(size: 18)).padding(4)
                .sheet(isPresented: $isPicking){
                    ImagePicker(image: $image)
                }
            Spacer()
        }.padding(5)
//            .background(.background)
        .overlay {
            if isLoading {
                ProgressView()
            }
        }
    }
}
