

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView() {
                Text("Loading...")
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
