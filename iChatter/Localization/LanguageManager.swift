//
//  LanguageManager.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 7/27/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class LanguageManager: NSObject {
    static let shared = LanguageManager()
    private var languages = Array<LanguageItem>()
    let APPLE_LANGUAGE_KEY = "AppleLanguages"
    
    func getLanguages() ->Array<LanguageItem>{
        return languages
    }
    
    func loadLanguages() {
        languages = Array<LanguageItem>()
        let english = LanguageItem(0,"English", false, "en-US")
        let vietnamese = LanguageItem(1,"Vietnamese", false, "vi-VN")
        languages.append(english)
        languages.append(vietnamese)
        let languageSelected = getSelectedLanguage()
        languages[languageSelected.index].state = true
    }
    
    func getSelectedLanguage() -> LanguageItem {
        var languageSelectedIndex = UserDefaults.standard.integer(forKey: "LanguageIndex")
        var languageSelectedTitle = UserDefaults.standard.string(forKey: "LanguageTitle")
        var languageSelectedValue = UserDefaults.standard.string(forKey: "LanguageValue")
        
        if languageSelectedTitle == nil {
            let deviceLang = getLanguageISO()
            languageSelectedTitle = deviceLang.language
            languageSelectedValue = deviceLang.code
            languageSelectedIndex = deviceLang.index
        }
        let langague = LanguageItem(languageSelectedIndex, languageSelectedTitle!, false, languageSelectedValue!)
        return langague
    }
    
    func getLanguageISO() -> (language : String, code : String, index :Int) {
        let locale = Locale.current
        guard let languageCode = locale.languageCode,
            let _ = locale.regionCode else {
                return ("English","en-US", 0)
        }
        if languageCode == "vi" {
            return ("Vietnamese","vi-VN", 1)
        }else {
            return ("English","en-US", 0)
        }
    }
    
    func changeLanguage(language : LanguageItem) {
        UserDefaults.standard.set(language.index, forKey: "LanguageIndex")
        UserDefaults.standard.set(language.title, forKey: "LanguageTitle")
        UserDefaults.standard.set(language.value, forKey: "LanguageValue")
        let langs : Array<String> = [language.value, currentAppleLanguage()]
        UserDefaults.standard.set(langs, forKey: APPLE_LANGUAGE_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func currentAppleLanguage() -> String {
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! Array<String>
        let current = langArray[0]
        return current
    }
}
