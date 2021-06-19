//
//  ViewController.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 19/06/2021.
//

import UIKit
import SkeletonView

class TrendingListVC: UIViewController {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var repositoryData: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        prepareData()
    }

    func initViews() {
        self.title = "Trending"
        tableView.register(UINib(nibName: "TrendingListTVC", bundle: nil), forCellReuseIdentifier: "TrendingListTVC")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func prepareData() {
        NetworkService.sharedInstance.getRepositoryList { (response, errorMessage) in
            guard let responseData = response else {
                return
            }
            self.repositoryData = responseData
            self.tableView.reloadData()
        }
    }

}

extension TrendingListVC: SkeletonTableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let repositoryItems = self.repositoryData?.items else {
            return 5
        }
        return repositoryItems.count
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TrendingListTVC"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingListTVC", for: indexPath) as! TrendingListTVC
        guard let repositoryItems = repositoryData?.items else {
            return cell
        }
        cell.hideSkeleton()
        cell.setData(object: repositoryItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    

}
