//
//  GlobalServices.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/20/21.
//

import UIKit

class GlobalServices: NSObject {
    static let httpService = HttpServices()
    static let photoService = PhotoService()
}
