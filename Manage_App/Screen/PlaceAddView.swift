
import SwiftUI
import Alamofire

struct PlaceAddView: View {
    
    let userDefaults = UserDefaults.standard
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var model: PlaceModel
    
    @State private var image: Image? = Image("room")
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionSheet = false
    @State private var shouldPresentCamera = false
    
    @State private var imagelocation = ""
    @State private var namelocation = ""
    
    @State var showLoading = false
    // @Binding var showPlaceView: Bool
    
    var body: some View {
        VStack{
            Text("Add Place")
            .padding()
            NavigationView {
                if (self.showLoading == true) {
                    LoadingView()
                } else {
                    VStack {
                        image!
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .foregroundColor(.blue)
                            .shadow(radius: 10)
                        
                        Button("Add Image +") {
                            shouldPresentActionSheet = true
                        }
                        .sheet(isPresented: $shouldPresentImagePicker) {
                            SUImagePickerView(sourceType: shouldPresentCamera ? .camera : .photoLibrary, image: $image, isPresented: $shouldPresentImagePicker)
                        }
                        .actionSheet(isPresented: $shouldPresentActionSheet) {
                            ActionSheet(title: Text("Take Image"), message: Text("Choose image source"), buttons: [
                                .default(Text("Camera"), action: {
                                    shouldPresentImagePicker = true
                                    shouldPresentCamera = true
                                }),
                                .default(Text("Photo Library"), action: {
                                    shouldPresentImagePicker = true
                                    shouldPresentCamera = false
                                }),
                                .cancel()
                            ])
                        }
                        Spacer()
                       // Spacer()
                        Section {
                            
                            TextField("Place Name", text: $namelocation)
                                .padding(5)
                                .background(Color("gray1"))
                            
                        }
                        // Spacer()
                        .padding(50)
                        Spacer()
                        Button("Save") {
                            self.showLoading = true
                            ////
                            Task {
                                let size = CGSize(width: 300, height: 300)
                                let data : UIImage? = image?.getUIImage(newSize: size)
                                let base64 = convertImageToBase64String(img: data)
                                await saveLocation(base64: base64)
                            }
                        }
                        
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        Spacer()
                    }
                    // .navigationBarTitle("Add Place")
                }
            }
        }
    }
    private func saveLocation(base64: String) async {
        do {
            let timestamp = Date().currentTimeMillis()
            let requestLocation = PlaceRequest(
                namelocation: namelocation,
                imagebase64: base64, imagename: "\(timestamp).jpg",
                owner: userDefaults.string(forKey: "Owner")
            )
            try await model.uploadLocation(placeRequest: requestLocation)
            self.showLoading = false
            presentationMode.wrappedValue.dismiss()
        } catch {
            print(error)
        }
    }
}

func convertImageToBase64String (img: UIImage?) -> String {
    guard let image = img else {
        return ""
    }
    ///image
    let scaledImage = image.resize(tragetSize: CGSize(width: 300, height: 300))
    
    let imageData = scaledImage.jpegData(compressionQuality: 0.7)
    return imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
}

extension Image {
    @MainActor
    func getUIImage(newSize: CGSize) -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .frame(width: newSize.width, height: newSize.height)
            .clipped()
        return ImageRenderer(content: image).uiImage
    }
}

struct PlaceAddView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceAddView().environmentObject(PlaceModel(webservice: Webservice()))
    }
}
