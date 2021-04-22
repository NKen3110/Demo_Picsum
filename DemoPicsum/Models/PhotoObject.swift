//
//  PhotoObject.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/20/21.
//

import Foundation

struct PhotoModel{
    struct Fetch {
        struct Request
        {
            var page = 1
            var limit = 100
        }

        struct Response
        {
            var dataObj: ViewModel?
            var isError: Bool
            var message: String?
        }
        
        struct ViewModel {
            let photos: [PhotoModel]?
            let isError: Bool
            let message: String?
        }

        struct PhotoModel {
            let id: String
            let author: String
            let width: Int
            let height: Int
            let url: String
            let download_url: String
        }
    }
}
