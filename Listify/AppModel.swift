import FirebaseFirestore
import FirebaseStorage
import Foundation
import SwiftUI

@MainActor
class AppModel: ObservableObject {
    @Published var lists: [ListInfo]?
    var ref: Firestore
    
    init(){
        ref = Firestore.firestore()
        print(Date().timeIntervalSince1970)
    }
    
    private func uploadImage(_ image:UIImage?) async -> String?{
        guard let image = image else {return nil}
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        return try? await ref.putDataAsync(image.pngData() ?? Data()).path
    }
    
    static func loadImage(_ path: String, image: Binding<UIImage?>){
        if path == ""{
            return;
        }
        Storage.storage().reference(withPath: path).getData(maxSize: .max) { data, error in
            if error == nil {
                if let _data = data, let newImage = UIImage(data: _data){
                    image.wrappedValue = newImage
                }
            }
        }
    }
    
    static func loadImage(_ path: String) async -> UIImage?{
        if path == ""{
            return nil
        }
        
        guard let data = try? await Storage.storage().reference(withPath: path).data(maxSize: .max)
        else {
            return nil
        }
        
        return UIImage(data: data)
    }
    
    private func deleteImage(at path:String) async -> Bool{
        if path == ""{
            return true;
        }
        let deleted: ()? = try? await Storage.storage().reference(withPath: path).delete()
        if deleted != nil{
            return true
        }
        return false
    }
    
    func uploadItem(info item: ListItem, listId: String?) async throws -> Bool{
        guard let id = listId else {
           return false
        }
        
        var info = item
        let path = await self.uploadImage(info.image) ?? ""
        info.imageUrl = path
        
        do{
            let result = try await ref.runTransaction { transaction, error in
                let documentRef = self.ref.collection("lists").document(id)
                let document = try? transaction.getDocument(documentRef)
                guard document != nil, var items = try? document?.data(as: ListInfo.self).items else { return false}
                
                items.append(info)
                
                transaction.updateData(["items" : items.map {
                    $0.dictionary
                }], forDocument: documentRef)
                return nil
            }
            if result != nil{
                return false
            }
        }catch{
            print("Here:")
            return false
        }

        guard let index = self.lists?.firstIndex(where: { info in
            return info.documentId == listId
        }) as? Int else { return false; }
        
            
        self.lists?[index].items?.append(info)
        
        return true
    }
    
    func addList(info: ListInfo) async throws{
        do{
            let document = try await ref.collection("lists").addDocument(data: info.dictionary)
            var _info = info
            _info.documentId = document.documentID
            _info.items = []
            self.lists?.append(_info)
        }catch{}
    }
    
    func deleteList(listId: String){
        ref.collection("lists").document(listId).delete()
        //TODO: delete all item images..
    }
    
    func deleteItem(listId:String?, itemId: String?)async throws->Bool{
        guard let id = listId, itemId != nil else {
           return false
        }
        
        if let item = self.lists?.first(where: {$0.documentId == id})?.items?.first(where: {$0.id == itemId}){
            //TODO: delete if again if failed
            let _ = await deleteImage(at: item.imageUrl ?? "")
        }
        
        do{
            let result = try await ref.runTransaction { transaction, error in
                let documentRef = self.ref.collection("lists").document(id)
                let document = try? transaction.getDocument(documentRef)
                guard document != nil, var items = try? document?.data(as: ListInfo.self).items else { return false}
                guard let index = items.firstIndex(where: {
                    return $0.id == itemId
                }) else {
                    return false
                }
                items.remove(at: index)
                
                transaction.updateData(["items" : items.map {
                    $0.dictionary
                }], forDocument: documentRef)
                return nil
            }
            if result != nil{
                return false
            }
        }catch{
            return false
        }

        guard let listIndex = self.lists?.firstIndex(where: {
                return $0.documentId == listId
        }) as? Int else {
            return false
        }
        
        if let index = self.lists![listIndex].items?.firstIndex(where: {return $0.id == itemId}) {
            self.lists![listIndex].items!.remove(at: index)
            return true
        }

        return false
    }
    
    func getAllLists() async{
        do{
            print("Getting")
            let lists = try await ref.collection("lists").getDocuments()
            print("Started")
            self.lists = lists.documents.map {
                list in
                print(list.data())
                do {
                    var info = try list.data(as: ListInfo.self)
                    info.documentId = list.documentID
                    return info
                }catch{
                    print(error)
                    return ListInfo(name: "", category: "")
                }
            }.filter({
                return $0.name != ""
            })
        }catch{
            print(error)
            self.lists = []
        }
    }
}
