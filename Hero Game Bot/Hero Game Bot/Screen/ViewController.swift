//
//  ViewController.swift
//  Hero Game Bot
//
//  Created by Ilya Sysoi on 3/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class ViewController: UIViewController {

    // MARK: - properties
    var webView: WKWebView!
    
    let botSwitch: UISwitch = {
        let `switch` = UISwitch()
        
        `switch`.isOn = false
        
        return `switch`
    }()
    
    let botInfoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Активин ли бот?"
        
        return label
    }()
    
    private let contentController = WKUserContentController()
    
    let presenter = Presenter()
    
    // MARK: - view configuring
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        configureSubviews()
        addSubviews()
        configureConstraints()
        
        presenter.hanldeViewDidLoad(view: self)
    }

    private func configureSubviews() {
        let config = WKWebViewConfiguration()
        config.userContentController.add(self,
                                         name: presenter.messageHandlerName)
        config.userContentController = contentController
       
        webView = WKWebView(frame: .zero,
                            configuration: config)
        webView.navigationDelegate = self
        
        
        botSwitch.addTarget(self,
                            action: #selector(botSwitchValueChanged),
                            for: .valueChanged)
    }
    
    private func addSubviews() {
        [webView,
         botInfoLabel,
         botSwitch].forEach(view.addSubview)
    }
    
    private func configureConstraints() {
        botInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(botSwitch.snp.right)
        }
        
        botSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(botInfoLabel)
            make.right.equalToSuperview().inset(10)
        }
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(botInfoLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    @objc private func botSwitchValueChanged(_ sender: UISwitch) {
        presenter.handleSwitchChangedValue(sender.isOn)
    }
    
}


extension ViewController: ViewProtocol {
    
    func loadURLWithScript(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func evaluateJavaScript(_ script: String) {
        let userScript = WKUserScript(source: script,
                                      injectionTime: .atDocumentEnd,
                                      forMainFrameOnly: true)
        contentController.addUserScript(userScript)
    }
    
}

extension ViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        
    }
    
    
}

extension ViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState") { [weak self] _, _ in
            self?.presenter.hanldeWebViewDidLoadPage(url: webView.url)
        }
    }
    
    
}
