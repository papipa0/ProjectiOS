
import SwiftUI

struct CardViewPlace: View {
    
    let place: Place
    var clickShare: (_ locationID: String, _ locationName: String) -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Color("bgg")
                VStack {
                    
                AsyncImage(url: URL(string: place.imagelocation)) { image in
                    image
                        .resizable()
                        //.cornerRadius(12)
                        //.frame(width: 165,height: 170)
                    //.aspectRatio(1, contentMode: .fit)
                }
            placeholder: {
                ProgressView()
            }
                    HStack {
                        Spacer()
                        Text(place.namelocation)
                            .font(.headline)
                            .fontWeight(.black)
                            .foregroundColor(.black)
                            .lineLimit(2)
                            .padding(.vertical,1.5)
                   
                   
                      Spacer()
                        Button(action: {
                            clickShare(place._id, place.namelocation)
                        }) {
                            Image(systemName: "square.and.arrow.up.circle.fill")
                                .resizable()
                               // .background(Color("fahmid"))
                                .foregroundColor(.black)
                                .frame(width:35,height: 35)
                                .padding(.trailing)
                                //.clipShape(Circle())
                        }
                    }
                   
                }
               
            }
        }
        .frame(width: 170,height: 225)
        .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
            }
           
            .padding([.top, .horizontal])
    }
}
