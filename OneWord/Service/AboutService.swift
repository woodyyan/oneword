//
//  AboutService.swift
//  OneWord
//
//  Created by Songbai Yan on 14/07/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import Foundation

class AboutService {
    func getCurrentVersion(_ bundleVersion:Bool = false) -> String{
        guard let infoDic = Bundle.main.infoDictionary else {return ""}
        guard let currentVersion = infoDic["CFBundleShortVersionString"] as? String else {return ""}
        if let buildVersion = infoDic["CFBundleVersion"] as? String , bundleVersion == true {
            return currentVersion + buildVersion
        }else {
            return currentVersion
        }
    }
}
