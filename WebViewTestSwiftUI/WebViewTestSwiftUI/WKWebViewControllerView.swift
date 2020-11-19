import SwiftUI
import WebKit

// ref: https://qiita.com/s_emoto/items/dc3d61626155f5cf83e7
// ref: https://github.com/sEmoto0808/swf-WebKit-WKWebView/blob/master/swf-WKWebView-demo/swf-WKWebView-demo/ViewController.swift
final class WKWebViewController: UIViewController {
    var webView: WKWebView!
    var url = URL(string: "https://cocorus.excite.co.jp")!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureWebView()
        loadPage()
    }

    private func configureWebView() {
        let webViewConfig = WKWebViewConfiguration()
        print("view.frame: \(view.frame)")
        webView = WKWebView(frame: view.frame, configuration: webViewConfig)
        webView.navigationDelegate = self
        webView.uiDelegate = self

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
        webView.load(request)
    }

    @objc private func panAfter(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .recognized {
            print("go back.")
            dismiss(animated: true)
        }
    }
}

// MARK: - 読み込み・繊維関連
extension WKWebViewController: WKNavigationDelegate {
    /// リクエスト前
    /// UIWebViewDelegate::webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) に近い
    /// - Parameters:
    ///   - webView:
    ///   - navigationAction:
    ///   - decisionHandler:
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> ()
    ) {
        print("Before send request.")

        if let url = navigationAction.request.url {
            print("url: \(url)")
        }

        // 読み込み実行の可否(必須)
        decisionHandler(.allow)
    }

    /// ブラウジングモード設定
    @available(iOS 13.0, *)
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        preferences: WKWebpagePreferences,
        decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> ()
    ) {
        let browsingMode: String = {
            switch preferences.preferredContentMode {
            case .recommended: return "recommended"
            case .mobile: return "mobile"
            case .desktop: return "desktop"
            @unknown default: return "unknown (raw:\(preferences.preferredContentMode.rawValue))"
            }
        }()
        print("Browsing mode: \(browsingMode)")

        decisionHandler(.allow, preferences)
    }

    /// サーバレスポンス受信後
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationResponse: WKNavigationResponse,
        decisionHandler: @escaping (WKNavigationResponsePolicy) -> ()
    ) {
        print("After respond.")

        // レスポンスのロジック上の可否(必須)
        decisionHandler(.allow)
    }

    /// 読み込み準備開始
    /// UIWebViewDelegate::webViewDidStartLoad(_ webView: UIWebView) と同義
    /// - Parameters:
    ///   - webView:
    ///   - navigation:
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start loading page.")
    }

    /// リダイレクト時
    public func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("Detect redirect.")
    }

    /// ページ読み込み中のエラー
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Detect to fail loading. error message: \(error.localizedDescription)")
    }

    /// 読み込み開始
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Start loading main frame.")
    }

    /// ページ遷移完了
    /// UIWebViewDelegate::webViewDidFinishLoad(_ webView: UIWebView) と同義
    /// - Parameters:
    ///   - webView:
    ///   - navigation:
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish loading.")
    }

    /// ページ読み込み失敗
    /// UIWebViewDelegate::webView(_ webView: UIWebView, didFailLoadWithError error: Error) と同義
    /// - Parameters:
    ///   - webView:
    ///   - navigation:
    ///   - error:
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to loading. error message: \(error.localizedDescription)")
    }

    /// 認証
    public func webView(
        _ webView: WKWebView,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> ()
    ) {
        print("Authentication.")
        // 認証の可否(必須)
        completionHandler(.useCredential, nil)
    }

    /// コンテンツのプロセスが中断された
    public func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("Web content process is terminated.")
    }

    /// 非推奨のTLS接続時
    @available(iOS 14.0, *)
    public func webView(
        _ webView: WKWebView,
        authenticationChallenge challenge: URLAuthenticationChallenge,
        shouldAllowDeprecatedTLS decisionHandler: @escaping (Bool) -> ()
    ) {
        print("Connected by old TLS.")
        decisionHandler(false)
    }
}

// MARK: - (js連携)
extension WKWebViewController: WKUIDelegate {
    /// 通常のアラート
    public func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping () -> ()
    ) {
        let alertVC = UIAlertController(title: "ALERT!!!", message: message, preferredStyle: .alert)

        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in completionHandler()}))

        present(alertVC, animated: true)
    }

    /// 確認ダイアログ
    public func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> ()
    ) {
        let alertVC = UIAlertController(title: "Confirmation!", message: message, preferredStyle: .alert)

        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in completionHandler(false)}))
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in completionHandler(true)}))

        present(alertVC, animated: true)
    }

    /// プロンプト付きダイアログ
    public func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> ()
    ) {
        let promptVC = UIAlertController(title: "Prompt", message: prompt, preferredStyle: .alert)

        promptVC.addTextField(configurationHandler: {$0.text = defaultText})
        promptVC.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        promptVC.addAction(UIAlertAction(title: "Send", style: .default) {
            okAction in
            guard let inputText = promptVC.textFields?.first?.text else {
                completionHandler("")
                return
            }
            completionHandler(inputText)
        })

        present(promptVC, animated: true)
    }
}

struct WKWebViewControllerView: UIViewControllerRepresentable {
    typealias UIViewControllerType = WKWebViewController

    func makeUIViewController(context: Context) -> UIViewControllerType {
        WKWebViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
