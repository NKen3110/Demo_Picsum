//
//  PhotoViewController.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/20/21.
//

import UIKit
import SDWebImage

class PhotoViewController: BaseViewController, UICollectionViewDataSource, PhotoPresenterOutput {

    @IBOutlet weak var photoColleectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private let itemDataArray = NSMutableArray()
    private let sectionInsets = UIEdgeInsets(
        top: 5.0,
        left: 20.0,
        bottom: 50.0,
        right: 20.0
    )
    
    private var reachedEndOfItems = false
    private var page = 1
    private let limit = 100
    
    private var widthPerItem: CGFloat = 0
    private var itemsPerRow: CGFloat = 2
    private var selectedSegmentIndex = 0
    private let compactReuseIdentifier = "CompactCollectionViewCell"
    private let regularReuseIdentifier = "RegularCollectionViewCell"
    
    var interactor: PhotoInteractorInput?
    var router: PhotoRouterInput?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = PhotoSceneInteractor()
        let presenter = PhotoScenePresenter()
        let router = PhotoSceneRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.output = viewController
        router.viewController = viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showIndicator()
        self.interactor?.fetchItems(request: PhotoModel.Fetch.Request(page: self.page, limit: self.limit))
        
        self.setupUI()
    }
    
    private func setupUI() {
        navigationItem.title = "Demo Picsum"
        
        if let value = UserDefaults.standard.value(forKey: "SegmentIndex") {
            let selectedIndex = value as! Int
            segmentControl.selectedSegmentIndex = selectedIndex
            selectedSegmentIndex = selectedIndex
            print("Inital Selected Segment Index \(selectedSegmentIndex)")
        }
        
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        print("Inital Landscape \(UIApplication.shared.statusBarOrientation.isLandscape)")
        switch (deviceIdiom) {
            case .pad:
                if selectedSegmentIndex == 0 {
                    itemsPerRow = 2
                } else {
                    if UIApplication.shared.statusBarOrientation.isLandscape {
                        itemsPerRow = 5
                    } else {
                        itemsPerRow = 3
                    }
                }
                print("iPad style UI")
            case .phone:
                if selectedSegmentIndex == 0 {
                    itemsPerRow = 1
                } else {
                    itemsPerRow = 2
                }
                print("iPhone and iPod touch style UI")
            default:
                itemsPerRow = 0
                print("Unspecified UI idiom")
        }
        
        self.segmentControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        self.photoColleectionView.register(UINib(nibName: compactReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: compactReuseIdentifier)
        self.photoColleectionView.register(UINib(nibName: regularReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: regularReuseIdentifier)
        
        self.photoColleectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.photoColleectionView.delegate = self
        self.photoColleectionView.dataSource = self
        
        self.setupRefreshCOntrol()
    }
    
    func setupRefreshCOntrol() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .lightGray
//        refreshControl.addTarget(self, action: #selector(refreshData(_ :)), for: .valueChanged)
        self.photoColleectionView.refreshControl = refreshControl
        self.photoColleectionView.refreshControl?.addTarget(self, action: #selector(refreshData(_ :)), for: .valueChanged)
    }
    
    @objc func refreshData(_ sender: Any) {
        self.page = 1
        self.reachedEndOfItems = false
        self.itemDataArray.removeAllObjects()
        self.interactor?.fetchItems(request: PhotoModel.Fetch.Request(page: self.page, limit: self.limit))
        self.photoColleectionView.refreshControl?.endRefreshing()
    }
    
    func successFetchedItems(viewModel: PhotoModel.Fetch.ViewModel) {
        self.showIndicator(false)
        if (viewModel.photos?.count == 0) {
            self.reachedEndOfItems = true
        } else {
            itemDataArray.addObjects(from: viewModel.photos!)
            photoColleectionView.reloadData()
        }
//        print("Success Fetch Data \(String(describing: viewModel.photos))")
    }
    
    func errorFetchingItems(viewModel: PhotoModel.Fetch.ViewModel) {
        self.showIndicator(false)
        self.displayAlert(message: viewModel.message)
        print("Fail Fetch Data \(String(describing: viewModel.message))")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if (selectedSegmentIndex == 1) {
                if UIDevice.current.orientation.isLandscape {
                    print("iPad Landscape")
                    itemsPerRow = 5
                } else {
                    print("iPad Portrait")
                    itemsPerRow = 3
                }
            } else {
                itemsPerRow = 2
            }
            photoColleectionView?.reloadData()
        } else {
            if (selectedSegmentIndex == 1) {
                if UIDevice.current.orientation.isLandscape {
                    print("iPhone Landscape")
                    itemsPerRow = 4
                } else {
                    print("iPhone Portrait")
                    itemsPerRow = 2
                }
            } else {
                itemsPerRow = 1
            }
            photoColleectionView?.reloadData()
        }
    }

    @IBAction func segmentedControlChanged(_ sender: Any) {
        print("Segment change")
        switch segmentControl.selectedSegmentIndex {
            case 0:
                selectedSegmentIndex = 0
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    itemsPerRow = 2
                } else {
                    itemsPerRow = 1
                }
                segmentControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
                photoColleectionView.setContentOffset(.zero, animated: false)
                photoColleectionView.reloadData()
            case 1:
                selectedSegmentIndex = 1
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    if UIApplication.shared.statusBarOrientation.isLandscape {
                        print("iPad Landscape")
                        itemsPerRow = 5
                    } else {
                        print("iPad Portrait")
                        itemsPerRow = 3
                    }
                } else {
                    if UIApplication.shared.statusBarOrientation.isLandscape {
                        print("iPhone Landscape")
                        itemsPerRow = 4
                    } else {
                        print("iPhone Portrait")
                        itemsPerRow = 2
                    }
                }
                segmentControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
                photoColleectionView.setContentOffset(.zero, animated: false)
                photoColleectionView.reloadData()
        default:
            selectedSegmentIndex = 0
        }
        
        UserDefaults.standard.set(selectedSegmentIndex, forKey: "SegmentIndex")
    }
}

extension PhotoViewController {
    
    func loadMoreItems() {
        guard !reachedEndOfItems else {
            print("Can not load more")
            return
        }
        
        self.showIndicator()
        DispatchQueue.global(qos: .background).async {
            self.page += 1
            self.interactor?.fetchItems(request: PhotoModel.Fetch.Request(page: self.page, limit: self.limit))
        }
    }
    
    private func emptyCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    private func createRegularCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: regularReuseIdentifier,for: indexPath) as? RegularCollectionViewCell
        // Configure the cell
        if (itemDataArray.count != 0) {
            cell?.updateCell(data: itemDataArray[indexPath.row] as! PhotoModel.Fetch.PhotoModel)
        }
        
        return cell ?? emptyCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    private func createCompactCollectionViewCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: compactReuseIdentifier,for: indexPath) as? CompactCollectionViewCell
        // Configure the cell
        if (itemDataArray.count != 0) {
            cell?.updateCell(data: itemDataArray[indexPath.row] as! PhotoModel.Fetch.PhotoModel)
        }
        
        return cell ?? emptyCell(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count cell \(itemDataArray.count)")
        return itemDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if selectedSegmentIndex == 0 {
            return createRegularCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            return createCompactCollectionViewCell(collectionView: collectionView, indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == itemDataArray.count - 1 {
//            reachedEndOfItems = true
            print("reachedEndOfItems \(reachedEndOfItems)")
            loadMoreItems()
        }
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath
      ) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        widthPerItem = availableWidth / itemsPerRow
        if (selectedSegmentIndex == 0) {
            return CGSize(width: widthPerItem, height: 120)
        }
        return CGSize(width: widthPerItem, height: widthPerItem + 50)
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int
      ) -> UIEdgeInsets {
        return sectionInsets
    }
      
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int
      ) -> CGFloat {
        return sectionInsets.left
    }
}
