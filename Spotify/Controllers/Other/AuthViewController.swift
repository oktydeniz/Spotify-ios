//
//  AuthViewController.swift
//  Spotify
//
//  Created by oktay on 10.06.2023.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero,
        configuration: config)
        return webView
        
    }()
    
    public var completionHandler: ((Bool) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    private func initUI() {
        title = "Sign in"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.singInURL else {
            return
        }
        webView.load(URLRequest(url: url))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else {
            return
        }
        // Exchange the code for access token
        let companent = URLComponents(string: url.absoluteString)
        guard let code = companent?.queryItems?.first(where: {$0.name == "code" })?.value else {
            return
        }
        
    }

}
