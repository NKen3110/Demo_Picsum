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

protocol PhotoPresenterOutput: class
{
    func successFetchedItems(viewModel: PhotoModel.Fetch.ViewModel)
    func errorFetchingItems(viewModel: PhotoModel.Fetch.ViewModel)
}

class PhotoScenePresenter: PhotoPresenterInput {
    
    weak var output: PhotoPresenterOutput?
    
    // MARK: - Presentation logic
    func presentFetchResults(response: PhotoModel.Fetch.Response) {
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
