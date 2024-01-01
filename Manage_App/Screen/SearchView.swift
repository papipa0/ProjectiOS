//
//  SearchView.swift
//  Manage_App

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject private var model: PlaceModel
    
    let userDefaults = UserDefaults.standard
    @State private var searchText = ""
    
    private func search(word: String, owner: String) async {
        do {
            try await model.search(searchRequest: SearchRequest(word: word, ownerid: owner))
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack  {
                    SearchBar() { word in
                        self.searchText = word
                        Task {
                            let ownerId = userDefaults.string(forKey: "Owner") ?? ""
                            await search(word:word, owner: ownerId)
                        }
                    }
                    //list
                        LazyVStack {
                            if model.search.locationList.count > 0 {
                                    HStack {
                                        Text("Place")
                                            .font(.largeTitle)
                                        Spacer()
                                        Spacer()
                                    }.padding(.horizontal, 4)
                                ForEach(model.search.locationList , id:\.self) { location in
                                    NavigationLink(destination: LocationDetailView(place: location, isModify: true)) {
                                        HStack {
                                            AsyncImage(url: URL(string: location.imagelocation )) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 50)
                                                    .cornerRadius(10)
                                            }
                                        placeholder: {
                                            ProgressView()
                                        }
                                            Text(location.namelocation )
                                                .bold()
                                                .frame(maxWidth: .infinity)
                                            Spacer()
                                            
                                        }.frame(maxWidth: .infinity,alignment: .center)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                                            }
                                    }
                                }
                            } else {
                               if searchText != "" {
                                   HStack {
                                       Text("Place")
                                           .font(.largeTitle)
                                       Spacer()
                                       Spacer()
                                   }.padding(.horizontal, 4)
                                   Text("No Place \(self.searchText) ")
                               }
                           }
                        }
                        LazyVStack {
                            if model.search.itemList.count > 0 {
                                    HStack {
                                        Text("Item")
                                            .font(.largeTitle)
                                        Spacer()
                                    }.padding(.horizontal, 4)
                                ForEach(model.search.itemList , id:\.self) { item in
                                    NavigationLink(destination: ItemDetailView(itemDetail: item, isModify: true)) { 
                                        HStack {
                                            AsyncImage(url: URL(string: item.imageitem ?? "")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 50)
                                                    .cornerRadius(10)
                                            }
                                        placeholder: {
                                            ProgressView()
                                        }
                                            Text(item.nameItem ?? "")
                                                .bold()
                                                .frame(maxWidth: .infinity)
                                            Spacer()
                                            
                                        }.frame(maxWidth: .infinity,alignment: .center)
                                            .cornerRadius(10)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
                                            }
                                    }
                                }
                            } else {
                                if searchText != "" {
                                    HStack {
                                        Text("Item")
                                            .font(.largeTitle)
                                        Spacer()
                                    }.padding(.horizontal, 4)
                                    Text("No Item \(self.searchText)")
                                }
                            }
                        }
                }
                .navigationBarTitle(Text("Search"))
            }
        }
        
    }
}

struct SearchBar: View {
    var clickSearch: (_ word: String) -> Void
    
    @State private var text = ""
    var body: some View {
        
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color("fahw"))
                .cornerRadius(8)
            
            Button(action: {
                clickSearch(self.text)
            }) {
                Text("Search")
               
            }
            
            .padding(.trailing, 8)
            .transition(.move(edge: .trailing))
            .animation(.default)
        }
        .padding(.horizontal)
        Spacer()
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(PlaceModel(webservice: Webservice()))
    }
}
