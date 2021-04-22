//
//  PhotoSceneInteractor.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/20/21.
//

import UIKit

protocol PhotoInteractorInput {
    func fetchItems(request: PhotoModel.Fetch.Request)
}

protocol PhotoInteractorOutput {
    func presentFetchResults(response: PhotoModel.Fetch.Response)
}

class PhotoSceneInteractor : PhotoInteractorInput {
    
    var presenter: PhotoPresenterInput!
    var worker: PhotoSceneWorker!
    
    func fetchItems(request: PhotoModel.Fetch.Request) {
        if (request.page == 0 || request.limit == 0) {
            return presenter.presentFetchResults(response: PhotoModel.Fetch.Response(dataObj: nil, isError: true, message: "Fields may not be empty."))
        }
        worker = PhotoSceneWorker()
        worker.fetch(page: request.page, limit: request.limit, success: {
            (object) in
            self.presenter.presentFetchResults(response: object)
        }, fail: {(object) in
            self.presenter.presentFetchResults(response: object)
        })
    }
}
