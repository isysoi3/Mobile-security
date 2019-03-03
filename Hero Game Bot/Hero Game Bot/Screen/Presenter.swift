//
//  Presenter.swift
//  Hero Game Bot
//
//  Created by Ilya Sysoi on 3/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

class Presenter {
    
    let messageHandlerName: String = "iosHandler"
    
    private var isBotActive: Bool = false {
        didSet {
            if isBotActive {
                //TODO: go to ne
                setNextPageToWebViewWithDelay(url: GameURLsEnum.login)
            }
        }
    }
    
    private weak var view: ViewProtocol!
    
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
                window.webkit.messageHandlers.iosHandler.postMessage(fightButton.getAttribute("href"));
                fightButton.click()
            }
    """
    
    
//    let battleScript = """
//    window.webkit.messageHandlers.iosHandler.postMessage('11');
//        $(document).ready(function(){
//            var fightButton = document.getElementsByClassName("button_medium")[0];
//            if (fightButton) {
//                window.webkit.messageHandlers.iosHandler.postMessage(fightButton.getAttribute("href"));
//            }
//        });
//    """
    
}

extension Presenter {
    
    func hanldeViewDidLoad(view: ViewProtocol) {
        self.view = view
        
        view.loadURLWithScript(GameURLsEnum.game)
    }
    
    func hanldeWebViewDidLoadPage(url: URL?) {
        guard isBotActive else { return }
        guard let url = url else {
            view.loadURLWithScript(GameURLsEnum.login)
            return
        }
        
        switch url {
        case GameURLsEnum.login:
            view.evaluateJavaScript(loginScript)
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
                view.setBotActivity(false)
               // setNextPageToWebViewWithDelay(url: GameURLsEnum.login)
            }
        }
    }
    
    func handleSwitchChangedValue(_ newVlaue: Bool) {
        isBotActive = newVlaue
    }
    
}

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
