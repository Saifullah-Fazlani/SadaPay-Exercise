//
//  TrendingListTVC.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 19/06/2021.
//

import UIKit

class TrendingListTVC: UITableViewCell {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(object: Item?) {
        guard let repoItem = object, let avatarUrl = repoItem.owner?.avatarUrl else {return}
        avatarImageView.image = UIImage(named: avatarUrl)
        lblName.text = repoItem.name
        lblFullName.text = repoItem.fullName
        lblDescription.text = repoItem.itemDescription
        lblLanguage.text = repoItem.language
        lblRating.text = repoItem.stargazersCount?.description
    }
}
