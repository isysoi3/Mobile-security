//
//  Presenter.swift
//  Hero Game Bot
//
//  Created by Ilya Sysoi on 3/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation
import Firebase
import Vision

class GamePresenter {
    
    // MARK: - properties
    
    let messageHandlerName: String = "iosHandler"
    
    private var isBotActive: Bool = false {
        didSet {
            view.setBotActivity(isBotActive)
            if isBotActive {
                hanldeWebViewDidLoadPage(url: currentURL)
            }
        }
    }
    
    private weak var view: GameViewProtocol!
    
    private var currentURL: URL
    
    private var timer: Timer?
    
    // MARK: - init
    init() {
        currentURL = GameURLsEnum.login
    }
}

// MARK: - handling view signals
extension GamePresenter {
    
    func hanldeViewDidLoad(view: GameViewProtocol) {
        self.view = view
        
        view.loadURLWithScript(currentURL)
    }
    
    func hanldeWebViewDidLoadPage(url: URL?) {
        guard let url = url else {
            view.loadURLWithScript(GameURLsEnum.login)
            return
        }
        self.currentURL = url
        
        switch url {
        case GameURLsEnum.login:
            guard isBotActive else { return }
            view.evaluateJavaScript(GameScripts.loginScript)
        case GameURLsEnum.assignments:
            setNextPageToWebViewWithDelay(url: GameURLsEnum.game)
        case GameURLsEnum.game:
            setNextPageToWebViewWithDelay(url: GameURLsEnum.campaign)
        case GameURLsEnum.campaign:
            setNextPageToWebViewWithDelay(url: GameURLsEnum.battle)
        case GameURLsEnum.battle:
            evaluateJavaScriptInWebViewWithDelay(script: GameScripts.battleScript)
        default:
            if url.absoluteString.contains("/game/battle/results/") {
                setNextPageToWebViewWithDelay(url: GameURLsEnum.battle)
            } else {
                setNextPageToWebViewWithDelay(url: GameURLsEnum.game)
            }
        }
    }
    
    func handleSwitchChangedValue(_ newVlaue: Bool) {
        isBotActive = newVlaue
    }
    
    func hanldeMessageFromWebView(message: String) {
        let splitedCharset = CharacterSet(arrayLiteral: " ")
        let values: [String] = message
            .split(separator: "\n")
            .compactMap {
                let splited = $0.split(separator: "~")
                return splited.last == nil ? nil : String(splited.last!).trimmingCharacters(in: splitedCharset)
        }
        print(values)
        
        guard isBotActive else { return }
        
        var alertMessage: String? = .none
        switch values.count {
        case 3:
            let timer = values[0]
            guard let fightsAvailable = values[1].split(separator: "/").first,
                let health = Int(values[2]) else { return }
            
            if fightsAvailable == "0" {
                alertMessage = "Бот был выключен: нет попыток для битв. Но будет включен через \(timer)"
                var timerValue: Double = 0
                timer.split(separator: ":").enumerated().forEach { index, element in
                    guard let elementInt = Double(element) else { return }
                    timerValue += elementInt * pow(60.0, Double(2 - index))
                }
                startTimer(value: timerValue)
            } else if health < 80 {
                alertMessage = "Бот был выключен: здоровья очень мало. Но будет включен через 5:00"
                startTimer(value: 300)
            }
        case 1 where message.contains("captcha"):
            guard let base64 = values.first else { return }
            imageParseAndRecognize(base64: base64)
            return
        case 1 where message.contains("notif"):
            guard let notif = values.first else { return }
            alertMessage = "Бот был выключен: \(notif)"
        case 0 where message.contains("hardCaptcha"):
            alertMessage = "Бот был выключен: встречена сложная капча"
        default:
            return
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
private extension GamePresenter {
    
    func startTimer(value: Double) {
        timer?.invalidate()
        
        var timerSeconds = value
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true) { [weak self] timer in
                guard timerSeconds != 0 else {
                    self?.view.setCurrentTimerValue(.none)
                    self?.isBotActive.toggle()
                    self?.view.showAlert(title: .none,
                                         message: "Бот снова включен")
                    timer.invalidate()
                    return
                }
                var timerStringValue = ""
                let minutes = Int(timerSeconds/60)
                let seconds = Int(timerSeconds.truncatingRemainder(dividingBy: 60))
                timerStringValue += (minutes >= 10 ? "" : "0") + "\(minutes):"
                timerStringValue += (seconds >= 10 ? "" : "0") + "\(seconds)"
                self?.view.setCurrentTimerValue(timerStringValue)
                timerSeconds -= 1
        }
    }
    
    func setNextPageToWebViewWithDelay(url: URL) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 + Double.random(in: 1...4)) { [unowned self] in
            guard self.isBotActive else { return }
            self.view.loadURLWithScript(url)
        }
    }
    
    func evaluateJavaScriptInWebViewWithDelay(script: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 + Double.random(in: 1...2)) { [unowned self] in
            guard self.isBotActive else { return }
            self.view.evaluateJavaScript(script)
        }
    }
    
    func imageParseAndRecognize(base64: String) {
        guard let dataDecoded = Data(base64Encoded: base64,
                                     options: .ignoreUnknownCharacters),
            let decodedimage = UIImage(data: dataDecoded) else { return }
        recognizeCaptcha(image: decodedimage) { value in
            guard let solution = value else { return }
            self.view.evaluateJavaScript("""
                var captcha = document.getElementById('captcha');
                captcha.value = "\(solution)";
                """)
            self.evaluateJavaScriptInWebViewWithDelay(script: "document.getElementsByName('commit')[0].click();")
        }
    }
    
    func recognizeCaptcha(image: UIImage,
                          completionBlock: @escaping (String?) -> ()) {
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        let image = VisionImage(image: image)
        textRecognizer.process(image) { result, error in
            guard error == nil, let result = result else {
                print(error.debugDescription)
                completionBlock(.none)
                return
            }
            print(result)
            completionBlock(result.text)
        }
    }
    
}
