

import SwiftUI

struct Home: View {
    
    var body: some View {
        GeometryReader{proxy in
            let safeAreaTop = proxy.safeAreaInsets.top
            
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    HeadView(safeAreaTop)
                   
                }
            }
            
            .edgesIgnoringSafeArea(.top)
            
        }
    }
    @ViewBuilder
    func HeadView(_ safeAreaTop: CGFloat) -> some View{
        VStack(spacing: 15){
            HStack(spacing: 15){
                HStack(spacing: 8){
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                    
                    TextField("Search", text: .constant(""))
                       
                        .tint(.black)
                }
                .padding(.vertical,10)
                .padding(.horizontal,15)
                .background{
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.black.opacity(0.2))
                }
                ///profile
            }
         
        }
        .environment(\.colorScheme, .dark)
        .padding([.horizontal, .bottom],15)
        .padding(.top,safeAreaTop + 10)
        .background{
            Rectangle()
                .fill(.mint.gradient)
        }
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
