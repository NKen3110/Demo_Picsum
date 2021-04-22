//
//  CompactCollectionViewCell.swift
//  DemoPicsum
//
//  Created by Nguyen Kiem on 4/21/21.
//

import UIKit

class CompactCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateCell(data: PhotoModel.Fetch.PhotoModel) {
        image.sd_setImage(with: URL(string: data.download_url), completed: nil)
        lblAuthor.text = "Author: \(data.author)"
        lblSize.text = "size: \(data.width)x\(data.height) "
    }
}
