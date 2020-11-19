import SwiftUI

struct ContentView: View {
    @State var isShowNewWebView = false
    @State var isShowOldWebView = false
    var body: some View {
        List {
            Button(action: {
                isShowNewWebView.toggle()
            }) {
                Text("New WebView")
            }
                .fullScreenCover(isPresented: $isShowNewWebView, content: WKWebViewControllerView.init)
            Button(action: {
                isShowOldWebView.toggle()
            }) {
                Text("Old WebView")
            }
                .fullScreenCover(isPresented: $isShowOldWebView, content: UIWebViewControllerView.init)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
