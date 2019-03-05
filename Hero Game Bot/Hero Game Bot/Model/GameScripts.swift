//
//  GameScripts.swift
//  Hero Game Bot
//
//  Created by Ilya Sysoi on 3/4/19.
//  Copyright © 2019 Ilya Sysoi. All rights reserved.
//

import Foundation

  // MARK: - scripts
enum GameScripts {

    static let loginScript = """
        var username = document.getElementById('user_name');
        var password = document.getElementById('user_password');
        var captcha = document.getElementById('captcha');

        username.value = "isysoi";
        password.value = "123456";
        
        function getBase64Image(img) {
            
            
            return ;
        };

        var captchaImage = document.getElementsByClassName('captcha_image')[0].children[0];
        if (captchaImage) {
            var canvas = document.createElement("canvas");
            canvas.width = captchaImage.width;
            canvas.height = captchaImage.height;
            
            var ctx = canvas.getContext("2d");
            ctx.drawImage(captchaImage, 0, 0);
            
            var dataURL = canvas.toDataURL("image/png");
            window.webkit.messageHandlers.iosHandler.postMessage(`captcha ~ ${dataURL.replace(/^data:image\\/(png|jpg);base64,/, "")}`);
        }

        """
    
    static let battleScript = """
            var fightButton = document.getElementsByClassName("button_medium")[0];
            if (fightButton) {
                fightButton.click()
            }
    """
    
    static let validationScript = """
        var currentTimer = document.getElementById ('current_game_time');
        var currentAttemps = document.getElementById ('remaining_fights_count');
        var currentHealth = document.getElementById ( "current_user_health" );
        

        if (currentTimer, currentAttemps, currentHealth) {
            window.webkit.messageHandlers.iosHandler.postMessage(`timer ~ ${currentTimer.textContent.trim()}\nfights ~ ${currentAttemps.textContent.trim()}\nhealth ~ ${currentHealth.textContent.trim()}`);
        }

        var notif = document.getElementById('notifications_block').children[0].children[0].children[0].children[1];
        if (notif) {
            window.webkit.messageHandlers.iosHandler.postMessage(`notif ~ ${alertChild.textContent.trim()}`);
        }

        var captchaHardImage = document.getElementsByClassName('captcha_images_row');
        if (captchaHardImage.length != 0) {
            window.webkit.messageHandlers.iosHandler.postMessage(`hardCaptcha ~`);
        }
    
    """
}
