
import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError
    case badUrl
}

class Webservice {
    
    func login(login: Login)async throws -> Login {
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/user/create") else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(login)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let newLogin = try? JSONDecoder().decode(Login.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return newLogin
    }
    
    func getPlaces(ownerId: String) async throws -> [Place] {
        
        // https://island-bramble.glitch.me/test/orders
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/location/getall?owner=\(ownerId)") else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let places = try? JSONDecoder().decode([Place].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return places
    }
    
    func uploadPlaceImage(placeRequest: PlaceRequest) async throws -> Place  {
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/location/create") else {
            throw NetworkError.badUrl
        }
        //เตรียมก่อนส่ง api
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")//ส่งแบบ json
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(placeRequest)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let places = try? JSONDecoder().decode(Place.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return places
        
    }
    
    func updatePlace(placeRequest: PlaceRequest) async throws -> Place  {
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/location/update") else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(placeRequest)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let place = try? JSONDecoder().decode(Place.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return place
    }
    
    func deletePlace(placeID: String) async throws -> String {
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/location/delete/\(placeID)") else {
            throw NetworkError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        return placeID
    }
    
    func getItemsByLocation(owner: String, locationID: String) async throws -> [Item] {
        
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/item/getall?owner=\(owner)&location=\(locationID)") else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let items = try? JSONDecoder().decode([Item].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return items
    }
    
    func addItem(itemRequest: ItemRequest)async throws -> Item {
        
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/item/create") else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(itemRequest)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let item = try? JSONDecoder().decode(Item.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return item
    }
    
    func deleteItem(itemID : String)async throws -> String {
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/item/delete/\(itemID)") else {
            throw NetworkError.badUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        return itemID
    }
    
    func updateItem(itemRequest: ItemRequest, itemID: String)async throws -> Item {
        
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/item/update/\(itemID)") else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(itemRequest)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let item = try? JSONDecoder().decode(Item.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return item
    }
    
    func getEmailSharePlace(locationID: String) async throws -> [String] {
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/share/getshare/\(locationID)") else {
            throw NetworkError.badUrl
        }
        
        let request = URLRequest(url: url)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let emails = try? JSONDecoder().decode([String].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return emails
    }
    
    func addSharePlace(sharePlaceRequest: SharePlaceRequest) async throws -> SharePlace {
        
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/share/addshare") else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(sharePlaceRequest)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let sharePlace = try? JSONDecoder().decode(SharePlace.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return sharePlace
    }
    
    func unsharePlace(sharePlaceRequest: SharePlaceRequest) async throws -> [String] {
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/share/unshare") else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(sharePlaceRequest)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let emails = try? JSONDecoder().decode([String].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return emails
    }
    
    func search(searchRequest: SearchRequest) async throws -> Search {
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/share/search") else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(searchRequest)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let search = try? JSONDecoder().decode(Search.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return search
    }
    
    func shareWithMe(shareWithMeRequest: ShareWithMeRequest) async throws -> [Place] {
        guard let url = URL(string: "\(ConstantData.baseUrl)/api/share/sharewithme") else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(shareWithMeRequest)
        
        let (data,response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let place = try? JSONDecoder().decode([Place].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return place
    }
}
