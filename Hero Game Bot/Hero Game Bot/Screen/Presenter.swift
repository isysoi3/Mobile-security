//
//  Presenter.swift
//  Hero Game Bot
//
//  Created by Ilya Sysoi on 3/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class Presenter {
    
    // MARK: - properties
    
    let messageHandlerName: String = "iosHandler"
    
    private var isBotActive: Bool = false {
        didSet {
            if isBotActive {
                hanldeWebViewDidLoadPage(url: currentURL)
            }
        }
    }
    
    private weak var view: ViewProtocol!
    
    private var currentURL: URL
    
    // MARK: - scripts
    let loginScript = """
        var username = document.getElementById('user_name');
        var password = document.getElementById('user_password');
        var captcha = document.getElementById('captcha');

        username.value = "isysoi";
        password.value = "123456";
        captcha.focus()
        """
    
    let battleScript = """
            var fightButton = document.getElementsByClassName("button_medium")[0];
            if (fightButton) {
                window.webkit.messageHandlers.iosHandler.postMessage(`battleHref = ${fightButton.getAttribute("href")} `);
                fightButton.click()
            }
    """

    let validationScript = """
        var currentTimer = document.getElementById ('current_game_time');
        if (currentTimer) {
            window.webkit.messageHandlers.iosHandler.postMessage(`timer = ${currentTimer.textContent.trim()}`);
        }
    
        var currentAttemps = document.getElementById ('remaining_fights_count');
        if (currentAttemps) {
            window.webkit.messageHandlers.iosHandler.postMessage(`fights = ${currentAttemps.textContent.trim()}`);
        }

        var currentHealth = document.getElementById ( "current_user_health" );
        if (currentHealth) {
            window.webkit.messageHandlers.iosHandler.postMessage(`health = ${currentHealth.textContent.trim()}`);
        }

        var notif = document.getElementById('notifications_block');
        if (notif) {
            var alertChild = notif.children[0].children[0].children[0].children[1];
            if (alertChild) {
                window.webkit.messageHandlers.iosHandler.postMessage(`notif = ${alertChild.textContent.trim()}`);
            }
        }
    """
    
    // MARK: - init
    init() {
        currentURL = GameURLsEnum.login
    }
}

// MARK: - handling view signals
extension Presenter {
    
    func hanldeViewDidLoad(view: ViewProtocol) {
        self.view = view
        
        view.loadURLWithScript(currentURL)
    }
    
    func hanldeWebViewDidLoadPage(url: URL?) {
        guard let url = url else {
            view.loadURLWithScript(GameURLsEnum.login)
            return
        }
        currentURL = url
        guard isBotActive else { return }
        switch url {
        case GameURLsEnum.login:
            view.evaluateJavaScript(loginScript)
        case GameURLsEnum.assignments:
            setNextPageToWebViewWithDelay(url: GameURLsEnum.game)
        case GameURLsEnum.game:
            setNextPageToWebViewWithDelay(url: GameURLsEnum.campaign)
        case GameURLsEnum.campaign:
            setNextPageToWebViewWithDelay(url: GameURLsEnum.battle)
        case GameURLsEnum.battle:
            evaluateJavaScriptInWebViewWithDelay(script: battleScript)
        default:
            if url.absoluteString.contains("/game/battle/results/") {
                setNextPageToWebViewWithDelay(url: GameURLsEnum.battle)
            } else {
//                view.setBotActivity(false)
//                view.showAlert(title: .none,
//                               message: "Бот был выключен")
                setNextPageToWebViewWithDelay(url: GameURLsEnum.game)
            }
        }
    }
    
    func handleSwitchChangedValue(_ newVlaue: Bool) {
        isBotActive = newVlaue
    }
    
    func hanldeMessageFromWebView(message: String) {
        print(message)
        guard let stringValue = message.split(separator: "=")
            .last?
            .trimmingCharacters(in: CharacterSet(arrayLiteral: " ")) else { return }
        print(stringValue)
        
        guard isBotActive else { return }
        
        var alertMessage: String? = .none
        
        if message.contains("fights = ") {
            guard let fightsAvailable = stringValue.split(separator: "/").first,
                fightsAvailable == "0" else { return }
            alertMessage = "Бот был выключен: нет попыток для битв"
        } else if message.contains("timer = ") {

        } else if message.contains("health = ") {
            guard let health = Int(stringValue),
                health < 80 else { return }
            alertMessage = "Бот был выключен: здоровья очень мало"
        } else if message.contains("notif = ") {
            alertMessage = "Бот был выключен: \(stringValue)"
        }
        
        if alertMessage != nil {
            isBotActive = false
            view.setBotActivity(isBotActive)
            view.showAlert(title: .none,
                           message: alertMessage)
        }
    }
    
}

// MARK: - private presenter methods
private extension Presenter {
    
    func setNextPageToWebViewWithDelay(url: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 + Double.random(in: 1...4)) { [weak self] in
            self?.view.loadURLWithScript(url)
        }
    }
    
    func evaluateJavaScriptInWebViewWithDelay(script: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 + Double.random(in: 1...2)) { [weak self] in
            self?.view.evaluateJavaScript(script)
        }
    }
    
}
