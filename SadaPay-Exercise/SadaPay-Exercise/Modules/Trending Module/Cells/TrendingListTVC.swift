//
//  TrendingListTVC.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 19/06/2021.
//

import UIKit
import SDWebImage
import SkeletonView

class TrendingListTVC: UITableViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var blueDot: UIView!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareViews()
    }
    
    func prepareViews() {
        avatarImageView.makeRounded()
        blueDot.makeRounded()
        starImageView.makeRounded()
        setSkeleton()
    }
    
    func setSkeleton() {
        SkeletonAppearance.default.multilineLastLineFillPercent = Int.random(in: 20...70)
        SkeletonAppearance.default.multilineCornerRadius = 8
    }
    
    func showSkeleton() {
        contentView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray5), animation: nil, transition: .crossDissolve(0.25))
    }
    
    func hideSkeleton() {
        contentView.stopSkeletonAnimation()
        contentView.hideSkeleton()
    }
    
    func setData(object: Item?) {
        
        // Safely unwrap the object and avatarUrl
        guard let repoItem = object, let avatarUrl = repoItem.owner?.avatarUrl else {return}
        
        // Set relevant data
        avatarImageView.sd_setImage(with: URL(string: avatarUrl), placeholderImage: #imageLiteral(resourceName: "placeholderImage"))
        lblName.text = repoItem.name ?? "N/A"
        lblFullName.text = repoItem.fullName ?? "N/A"
        lblDescription.text = repoItem.itemDescription ?? "N/A"
        lblLanguage.text = repoItem.language ?? "N/A"
        lblRating.text = repoItem.stargazersCount?.description ?? "N/A"
        
        // Show/hide bottom view depending on the isExpandable flag of the object
        showBottomViews(value: object?.isExpandable ?? false)   // Set value to false if isExpandable is nil
        
        // Hide skeleton once data has been populated
        self.hideSkeleton()
    }
    
    func showBottomViews(value: Bool) {
        lblDescription.isHidden = !value
        bottomStackView.isHidden = !value
    }
    
}
