//
//  DetailViewController.swift
//  Project4
//
//  Created by Thiago Alves on 7/11/19.
//  Copyright © 2019 Thiago Alves. All rights reserved.
//

// swiftlint:disable identifier_name

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var progressView: UIProgressView!
    var observer: NSKeyValueObservation?
    var websites = [String]()
    var selectedWebsite = 0

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self,
                                                            action: #selector(openTapped))

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView,
                                      action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView,
                                      action: #selector(webView.goForward))

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)

        toolbarItems = [back, forward, spacer, progressButton, spacer, refresh]
        navigationController?.isToolbarHidden = false

        observer = webView.observe(\.estimatedProgress, options: [.new]) { [weak self] object, _ in
            self?.progressView.progress = Float(object.estimatedProgress)
        }

        if !websites.isEmpty {
            let url = URL(string: "https://" + websites[selectedWebsite])!
            webView.load(URLRequest(url: url))
        } else {
            let url = URL(string: "about:blank")!
            webView.load(URLRequest(url: url))
        }
        webView.allowsBackForwardNavigationGestures = true
    }

    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)

        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }

    func openPage(action: UIAlertAction) {
        guard let actionTitle = action.title else { return }
        guard let url = URL(string: "https://" + actionTitle) else { return }
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }

            if let urlString = url?.absoluteString {
                let ac = UIAlertController(title: "URL blocked!",
                                           message: "You are trying to visit a URL (\(urlString)) that isn't allowed.",
                                           preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Continue", style: .default))
                present(ac, animated: true)
            }
        }

        decisionHandler(.cancel)
    }

    deinit {
        // This is required for iOS 10.
        // It is not required anymore in iOS 11+.
        observer = nil
    }

}
