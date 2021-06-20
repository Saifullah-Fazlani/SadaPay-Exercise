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
        prepareViews()
        fetchData()
    }
    
    // Prepare views, nibs and controls
    func prepareViews() {
        tableView.register(UINib(nibName: "TrendingListTVC", bundle: nil), forCellReuseIdentifier: "TrendingListTVC")
        setupRefreshControl()
        hideRetryView()
    }
    
    func setupRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
    
    func showRetryView(message: String) {
       
        // Add fade transition while showing RetryAnimation View
        UIView.transition(with: self.view, duration: 0.75, options: [.transitionCrossDissolve], animations: {
            self.containerView.isHidden = false
        }, completion: nil)
        
        // Check either controller is already initialized
        if self.controller == nil {
            let controller = storyboard?.instantiateViewController(withIdentifier: "RetryAnimationVC") as! RetryAnimationVC
            controller.delegate = self
            controller.errorMessage = message
            controller.view.frame = containerView.bounds
            self.containerView.addSubview(controller.view)
            self.addChild(controller)
            controller.didMove(toParent: self)
            
            // Save controller reference for checking next time this function is called.
            self.controller = controller
        }
    }
    
    func hideRetryView() {
        if !containerView.isHidden {
            UIView.transition(with: self.view, duration: 0.75, options: [.transitionCrossDissolve], animations: {
                self.containerView.isHidden = true
            }, completion: nil)
        }
    }
    
}

// MARK: - tableView Datasource and Delegate
extension TrendingListVC: SkeletonTableViewDataSource, UITableViewDelegate {
    
    // Set cell identifier for skeletonView
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "TrendingListTVC"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Check either repository data is not null
        guard let repositoryItems = self.repositoryData?.items else {
            // Display 5 skeleton cells if data is null
            return 5
        }
        return repositoryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrendingListTVC", for: indexPath) as! TrendingListTVC
        guard let repositoryItems = repositoryData?.items else {
            return cell
        }
        cell.setData(object: repositoryItems[indexPath.row])
        // Hide skeleton when data is populated in cell
        cell.hideSkeleton()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK: - Network Service Methods
extension TrendingListVC {
    @objc func fetchData() {
        
        //Hide RetryAnimation View
        self.hideRetryView()
        
        // Post a notification to tableview cell to show skeleton view
        NotificationCenter.default.post(.init(name: .didShowSkeletons))
        
        // Make network call to fetch data from API
        NetworkService.sharedInstance.getRepositoryList { (response, errorMessage) in
            
            //Check either response is not null
            guard let responseData = response else {
                // Show RetryAnimation View if response is null
                self.showRetryView(message: errorMessage ?? Strings.signalBlocked)
                return
            }
            
            // Set response data to class variable
            self.repositoryData = responseData
            
            // Reload table view to show newly fetched data
            self.tableView.reloadData()
            
            // Stop refresh animation of refreshControl
            self.refreshControl.endRefreshing()
        
        }
    }
}

// MARK: - Delegate functions
extension TrendingListVC: RetryDelegate {
    func didTappedRetry() {
        self.fetchData()
    }
}
