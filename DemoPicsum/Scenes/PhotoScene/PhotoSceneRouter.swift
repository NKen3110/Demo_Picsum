//
//  PhotoSceneRouter.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/20/21.
//

import UIKit

protocol PhotoRouterInput {
    func showSomeVC()
}

class PhotoSceneRouter: PhotoRouterInput
{
    weak var viewController: PhotoViewController!
    
    func showSomeVC() {
        viewController.performSegue(withIdentifier: "someVC", sender: nil)
    }
        
    func passDataToNextScene(segue: UIStoryboardSegue)
    {
        if segue.identifier == "someOtherVC" {

        }
    }
}
