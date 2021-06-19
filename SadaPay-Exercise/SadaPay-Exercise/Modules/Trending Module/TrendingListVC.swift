//
//  ViewController.swift
//  SadaPay-Exercise
//
//  Created by Saifullah on 19/06/2021.
//

import UIKit
import SkeletonView

protocol RetryDelegate {
    func didTappedRetry()
}

class TrendingListVC: UIViewController {

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    
    private let refreshControl = UIRefreshControl()
    var repositoryData: Repository?
    var controller: RetryAnimationVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        fetchData()
    }

    func initViews() {
        tableView.addSubview(refreshControl)
        tableView.register(UINib(nibName: "TrendingListTVC", bundle: nil), forCellReuseIdentifier: "TrendingListTVC")
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        hideRetryView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func fetchData() {
        NetworkService.sharedInstance.getRepositoryList { (response, errorMessage) in
            guard let responseData = response else {
                print(errorMessage as Any)
                self.showRetryView(message: errorMessage ?? Strings.signalBlocked)
                return
            }
            print(responseData as Any)
            self.hideRetryView()
            self.repositoryData = responseData
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func showRetryView(message: String) {
        containerView.isHidden = false
        if self.controller == nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: "RetryAnimationVC") as! RetryAnimationVC
            controller.delegate = self
            controller.errorMessage = message
            controller.view.frame = containerView.bounds
            containerView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            self.controller = controller
        }
    }
    
    func hideRetryView() {
        containerView.isHidden = true
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

extension TrendingListVC: RetryDelegate {
    func didTappedRetry() {
        self.fetchData()
    }
}
