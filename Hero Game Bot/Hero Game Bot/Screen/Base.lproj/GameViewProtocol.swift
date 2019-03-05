//
//  GameViewProtocol.swift
//  Hero Game Bot
//
//  Created by Ilya Sysoi on 3/2/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

protocol GameViewProtocol: class {
    
    func loadURLWithScript(_ url: URL)
    
    func evaluateJavaScript(_ script: String)
    
    func setBotActivity(_ isActive: Bool)
    
    func showAlert(title: String?, message: String?)
    
    func setCurrentTimerValue(_ value: String?)
    
}
