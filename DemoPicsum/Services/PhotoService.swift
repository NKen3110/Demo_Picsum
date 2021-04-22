//
//  PhotoService.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/20/21.
//

import UIKit

class PhotoService: NSObject {

    func FetchPhotoFromServer(page: Int, limit: Int, handleComplete: @escaping (_ items:NSArray) -> (), fail:@escaping(_ error: Bool, _ message: String) -> ()) {    GlobalServices.httpService.sendHttpRequestForGetData("https://picsum.photos/v2/list?page=\(page)&limit=\(limit)") { (isok, error, code, data) in
            if (isok) {
                if let arrayPhotDic = data?.toArray() {
                    handleComplete(arrayPhotDic)
                }
            } else {
                fail(isok, error)
            }
        }
    }
}
