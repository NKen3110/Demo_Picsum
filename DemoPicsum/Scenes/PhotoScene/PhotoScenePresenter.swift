//
//  PhotoScenePresenter.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/20/21.
//

import UIKit

protocol PhotoPresenterInput
{
    func presentFetchResults(response: PhotoModel.Fetch.Response);
}

class PhotoScenePresenter: PhotoPresenterInput {
    
    weak var output: PhotoPresenterOutput?
    
    // MARK: - Presentation logic
    func presentFetchResults(response: PhotoModel.Fetch.Response) {
        // NOTE: Format the response from the Interactor and pass the result back to the View Controller
        let viewModel = PhotoModel.Fetch.ViewModel(photos: response.dataObj?.photos, isError: response.isError, message: response.message)
        
        if response.isError{
            if let output = self.output {
                output.errorFetchingItems(viewModel: viewModel)
            }
        } else {
            if let output = self.output {
                output.successFetchedItems(viewModel: viewModel)
            }
        }
    }
}
