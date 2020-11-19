import SwiftUI
import WebKit

/// ref https://qiita.com/noby111/items/2830d9f9c76c83df79a1
final class OldWebViewController: UIViewController {
    var webView: UIWebView!
    var url = URL(string: "https://cocorus.excite.co.jp")!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureWebView()
        loadPage()
    }

    private func configureWebView() {
        webView = UIWebView(frame: .zero)
        webView.delegate = self

        let backPanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(panAfter(_:)))
        backPanGesture.edges = .left

        webView.addGestureRecognizer(backPanGesture)

        view = webView
        view.addGestureRecognizer(backPanGesture)

    }

    private func loadPage(with urlStr: String? = nil) {
        if let urlStr = urlStr, let url = URL(string: urlStr) {
            self.url = url
        }
        let request = URLRequest(url: url)
        webView.loadRequest(request)
    }

    @objc private func panAfter(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            print("go back.")
            dismiss(animated: true)
        }
    }
}

extension OldWebViewController: UIWebViewDelegate {
    /// 読み込み開始
    public func webViewDidStartLoad(_ webView: UIWebView) {
        print("Start loading.")
    }

    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        print("load control.")
        // 遷移の制御など(問題ない場合はtrueを返す)
        return true
    }

    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Failed to load. error: \(error.localizedDescription)")
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        print("Finish loading.")
    }
}

struct UIWebViewControllerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = OldWebViewController

    func makeUIViewController(context: Context) -> OldWebViewController {
        OldWebViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
