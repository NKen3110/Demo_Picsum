//
//  PhotoSceneWorker.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/20/21.
//

import UIKit

typealias responseHandler = (_ response: PhotoModel.Fetch.Response) ->()

class PhotoSceneWorker {
    
    func fetch(page:Int!, limit:Int!, success:@escaping(responseHandler), fail:@escaping(responseHandler)) {
        GlobalServices.photoService.FetchPhotoFromServer(page: page, limit: limit, handleComplete: { data in
            let photos = PhotoModel.Fetch.ViewModel(photos: data.map {
                let obj = $0 as? NSDictionary
                return PhotoModel.Fetch.PhotoModel(id: obj?.value(forKey: "id") as! String,
                                            author: obj?.value(forKey: "author") as! String,
                                            width: obj?.value(forKey: "width") as! Int,
                                            height: obj?.value(forKey: "height") as! Int,
                                            url: obj?.value(forKey: "url") as! String,
                                            download_url: obj?.value(forKey: "download_url") as! String)},
                isError: false, message: nil)
            success(PhotoModel.Fetch.Response(dataObj: photos, isError: false, message: nil))
        }, fail: { (error, meaasge) in
            fail(PhotoModel.Fetch.Response(dataObj: nil, isError: true, message: meaasge))
        })
    }
}
