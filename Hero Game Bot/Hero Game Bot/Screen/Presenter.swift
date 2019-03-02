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
            fightButton.click();
        }
    """
    
}

extension Presenter {
    
    func hanldeViewDidLoad(view: ViewProtocol) {
        self.view = view
        
        view.loadURLWithScript(GameURLsEnum.login)
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
            view.evaluateJavaScript(battleScript)
        default:
            if url.absoluteString.contains("/game/battle/results/") {
                setNextPageToWebViewWithDelay(url: GameURLsEnum.battle)
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
    
}
