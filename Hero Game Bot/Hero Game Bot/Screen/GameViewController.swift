//
//  GameViewController.swift
//  Hero Game Bot
//
//  Created by Ilya Sysoi on 3/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class GameViewController: UIViewController {

    // MARK: - properties
    var webView: WKWebView!
    
    let botSwitch: UISwitch = {
        let `switch` = UISwitch()
        
        `switch`.isOn = false
        
        return `switch`
    }()
    
    let botInfoLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Активен ли бот?"
        
        return label
    }()
    
    let presenter = GamePresenter()
    
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


// MARK: - GameViewController: GameViewProtocol
extension GameViewController: GameViewProtocol {
    
    func loadURLWithScript(_ url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func evaluateJavaScript(_ script: String) {
        webView.evaluateJavaScript(script, completionHandler: .none)
    }
    
    func setBotActivity(_ isActive: Bool) {
        botSwitch.isOn = isActive
    }
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok",
                                      style: .default,
                                      handler: {_ in alert.dismiss(animated: true) }))
        
        present(alert, animated: true)
    }
    
}

// MARK: - ViewController: WKScriptMessageHandler
extension GameViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController,
                               didReceive message: WKScriptMessage) {
        guard let body = message.body as? String else { return }
        presenter.hanldeMessageFromWebView(message: body)
    }
    
    
}

// MARK: - ViewController: WKNavigationDelegate
extension GameViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.readyState") { [weak self] _, _ in
            self?.presenter.hanldeWebViewDidLoadPage(url: webView.url)
        }
        webView.evaluateJavaScript(GameScripts.validationScript, completionHandler: .none)
    }

}
