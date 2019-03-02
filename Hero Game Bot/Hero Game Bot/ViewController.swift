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

    let webView: WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .green
        
        configureSubviews()
        addSubviews()
        configureConstraints()
    }

    private func configureSubviews() {
        
    }
    
    private func addSubviews() {
        [webView,
         botInfoLabel,
         botSwitch].forEach(view.addSubview)
    }
    
    private func configureConstraints() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        botInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(botSwitch.snp.right)
        }
        
        botSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(botInfoLabel)
            make.right.equalToSuperview().inset(10)
        }
        
        
    }

}

