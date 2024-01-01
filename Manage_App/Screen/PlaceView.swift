



import SwiftUI

struct PlaceView: View {
    
    let userDefaults = UserDefaults.standard
    
    @EnvironmentObject private var model: PlaceModel
    
    @State var navigateTo: AnyView?
    @State var isNavigationActive = false
    @State var showImagePicker: Bool = false
    @State private var showingSheet = false
    @State private var settingsDetent = PresentationDetent.medium
    @State private var namePlace = ""
    @State private var placeID = ""
    
    func populatePlace() async {
        do {
            let ownerId = userDefaults.string(forKey: "Owner") ?? ""
            try await model.populatePlaces(ownerId: ownerId)
        } catch {
            print(error)
        }
    }
    
    private var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible())]
    
    var body: some View {
        
        NavigationView {
            VStack{
                if let firstLocation = model.shareWithMe.first {
                        HStack {
                            Text("Hello...")
                                .foregroundColor(.gray)
                            Text(firstLocation.shared_with_id ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                    }
                }

                VStack{
                    ZStack{
                        
                        ScrollView {
                            LazyVGrid(columns: gridItemLayout, alignment: .center, spacing: 10) {
                                ForEach(model.places, id:\.self) { location in
                                    NavigationLink(destination: LocationDetailView(place: location, isModify: true)) {
                                        
                                        CardViewPlace(place: location) { locationID, locationName in
                                            namePlace = locationName
                                            placeID = locationID
                                            showingSheet.toggle()
                                            
                                        }
                                    }
                                }
                            }
                        }.task {
                            await populatePlace()
                        }
                        
                        .navigationTitle("My Place")
                        .toolbarBackground(
                            Color("g2") ,
                            for: .navigationBar)
                        VStack{
                            Spacer()
                            Spacer()
                            ZStack(alignment: .bottomTrailing) {
                                HStack{
                                    Spacer()
                                    Button(action: {
                                    }){
                                        NavigationLink(destination: PlaceAddView()){
                                            Image(systemName: "plus")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 12,height: 12)
                                                .padding(30)
                                        }
                                    }
                                    .background(Color("g4"))
                                    .foregroundColor(.white)
                                    .cornerRadius(.infinity).padding()
                                }
                            }
                        }.sheet(isPresented: $showingSheet) {
                            SheetView(placeID: self.$placeID ,namePlace: self.$namePlace).presentationDetents([.large], selection: $settingsDetent)
                        }
                    }
                }
            }
        }
    }
}

struct SheetView: View {
    @Binding var placeID: String
    @Binding var namePlace: String
    
    @EnvironmentObject private var model: PlaceModel
    
    @Environment(\.dismiss) var dismiss
    @State private var email = ""
    @State private var inValid = ""
    
    private func addSharePlace(sharePlaceRequest: SharePlaceRequest) async {
        do {
            try await model.addSharePlace(sharePlaceRequest: sharePlaceRequest)
            
        } catch {
            print(error)
        }
    }
    
    private func getEmailSharePlace(locationID: String) async {
        do {
            try await model.getEmailSharePlace(locationID: locationID)
        } catch {
            print(error)
        }
    }
    
    private func unShareEmailPlace(sharePlaceRequest: SharePlaceRequest) async {
        do {
            try await model.unShareEmailPlace(sharePlaceRequest: sharePlaceRequest)
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Text("Share Place\(namePlace)").font(.largeTitle)
                    TextField("email", text: $email)
                        .font(.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            if email.isValidEmail() {
                                model.emails.append(email)
                                email = ""
                                inValid = ""
                            } else {
                                inValid = "The email format is incorrect."
                            }
                        }.submitLabel(.done)
                    if inValid != "" {
                        Text(inValid)
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    
                    if (model.shares?.checkemailerror?.count != nil) && (model.shares?.checkemailerror?.count != 0 ){
                        Text("Cannot be shared with emails that are not in the system.")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    }
                    
                    LazyVStack(spacing: 1) {
                        ForEach(Array(model.emails.enumerated()), id: \.element) { index, email in
                            VStack {
                                ShareDetailView(email: email, index: index, checkemailerror: model.shares?.checkemailerror ?? []) { email, index in
                                    Task {
                                        await unShareEmailPlace(sharePlaceRequest: SharePlaceRequest(idlocation: placeID, emailowner: [email]))
                                    }
                                }
                            }
                        }
                    }
                }
            }.task {
                await getEmailSharePlace(locationID: placeID)
            }
            
            VStack {
                Spacer()
                Spacer()
                Button("Share") {
                    Task {
                        await addSharePlace(sharePlaceRequest: SharePlaceRequest(idlocation: placeID, emailowner:model.emails))
                    }
                }.disabled(model.emails.count < 1)
                    .buttonStyle(GrowingButton())
            }
            
        }.padding(20)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color("fah"))
            .foregroundStyle(.black)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct ShareDetailView: View {
    let email: String
    let index: Int
    var checkemailerror: [String]? = []
    var removeEmail: (_ email: String, _ index: Int) -> Void
    var body: some View {
        HStack {
            if (checkemailerror == nil || !(checkemailerror?.contains(email))!) {
                HStack {
                    Text(email)
                    Button {
                        removeEmail(email, index)
                    } label: {
                        Image(systemName: "xmark")
                    }
                    
                }.padding()
                    .background(.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 1)
                    )
            } else {
                HStack {
                    Text(email)
                    Button {
                        removeEmail(email, index)
                    } label: {
                        Image(systemName: "xmark")
                    }
                    
                }.padding()
                    .background(.white)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.red, lineWidth: 1)
                    )
            }
            
            Spacer()
        }.padding(.top, 1)
    }
    
}

struct PlaceView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceView().environmentObject(PlaceModel(webservice: Webservice()))
    }
}
