

import Foundation

@MainActor
class PlaceModel: ObservableObject {
    
    let webservice: Webservice
    @Published private(set) var places: [Place] = []
    @Published private(set) var login: Login = Login(_id: "", email: "")
    @Published private(set) var items: [Item] = []
    @Published private(set) var shares: SharePlace? = nil
    @Published var emails: [String] = []
    @Published private(set) var search: Search = Search()
    @Published private(set) var shareWithMe: [Place] = []
    @Published var onLogin: Bool = false
    
    init(webservice: Webservice){
        self.webservice = webservice
    }
    
    func populatePlaces(ownerId: String) async throws {
        places = try await webservice.getPlaces(ownerId: ownerId)
    }
    
    func login(login: Login) async throws {
        self.login = try await webservice.login(login: login)
    }
    
    func uploadLocation(placeRequest: PlaceRequest) async throws {
        let place = try await webservice.uploadPlaceImage(placeRequest: placeRequest)
        self.places.append(place)
    }
    
    func updateLocation(placeRequest: PlaceRequest) async throws {
        let place = try await webservice.updatePlace(placeRequest: placeRequest)
        let positionPlace = self.places.firstIndex { item in
            item._id == placeRequest._id
        }
        if positionPlace == nil {
            throw NetworkError.decodingError
        }
        self.places[positionPlace!] = place
    }
    
    func deleteLocation(placeID: String) async throws {
        let newPlaceID = try await webservice.deletePlace(placeID: placeID)
        let positionRemove = self.places.firstIndex { item in
            item._id == newPlaceID
        }
        if positionRemove == nil {
            throw NetworkError.decodingError
        }
        self.places.remove(atOffsets: IndexSet(integer: positionRemove!))
    }
    
    func getItemsByLocation(ownerID: String, locationID: String) async throws {
        items = try await webservice.getItemsByLocation(owner: ownerID, locationID: locationID)
    }
    
    func addItem(itemRequest: ItemRequest) async throws {
        let item = try await webservice.addItem(itemRequest: itemRequest)
        self.items.append(item)
    }
    
    func deleteItem(itemID: String) async throws {
        let newItemID = try await webservice.deleteItem(itemID: itemID)
        let positionRemove = self.items.firstIndex { item in
            item._id == newItemID
        }
        if positionRemove == nil {
            throw NetworkError.decodingError
        }
        self.items.remove(atOffsets: IndexSet(integer: positionRemove!))
    }
    
    func updateItem(itemRequest: ItemRequest, itemID: String) async throws {
        let item = try await webservice.updateItem(itemRequest: itemRequest, itemID: itemID)
        let positionItem = self.items.firstIndex { item in
            item._id == itemID
        }
        if positionItem == nil {
            throw NetworkError.decodingError
        }
        self.items[positionItem!] = item
    }
    
    func addSharePlace(sharePlaceRequest: SharePlaceRequest) async throws {
        let sharePlace = try await webservice.addSharePlace(sharePlaceRequest: sharePlaceRequest)
        self.shares = sharePlace
    }
    
    func getEmailSharePlace(locationID: String) async throws {
        let emails = try await webservice.getEmailSharePlace(locationID: locationID)
        self.emails = emails
    }
    
    func unShareEmailPlace(sharePlaceRequest: SharePlaceRequest) async throws {
        let emails = try await webservice.unsharePlace(sharePlaceRequest: sharePlaceRequest)
        self.emails = emails
    }
    
    func search(searchRequest: SearchRequest) async throws {
        let search = try await webservice.search(searchRequest: searchRequest)
        self.search = search
    }
    
    func shareWithMe(shareWithMeReques: ShareWithMeRequest) async throws {
        let place = try await webservice.shareWithMe(shareWithMeRequest: shareWithMeReques)
        self.shareWithMe = place
    }
    
    func clearData() {
        places = []
        login = Login(_id: "", email: "")
        items = []
        shares = nil
        emails = []
        search = Search()
    }
}
