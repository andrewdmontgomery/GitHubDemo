//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()
    var gitRepos: [GithubRepo]?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // add search bar to navigation bar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        doSearch()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func doSearch() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        GithubRepo.fetchRepos(searchSettings, successCallback: { (repos) -> Void in
            self.gitRepos = repos
            for repo in repos {
                println("[Name: \(repo.name!)]" +
                    "\n\t[Stars: \(repo.stars!)]" +
                    "\n\t[Forks: \(repo.forks!)]" +
                    "\n\t[Owner: \(repo.ownerHandle!)]" +
                    "\n\t[Avatar: \(repo.ownerAvatarURL!)]")
                println("\n\t[Description: \(repo.description!)]")
            }
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.tableView.reloadData()
        }, error: { (error) -> Void in
            println(error)
        })
    }

    // MARK: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numRows = 0
        if gitRepos != nil {
            numRows = gitRepos!.count
        }
        return numRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("repoCell") as! RepositoryTableViewCell
        let gitRepo = gitRepos![indexPath.row]
        cell.repoNameLabel.text = gitRepo.name!
        cell.starsLabel.text = String(gitRepo.stars!)
        cell.forksLabel.text = String(gitRepo.forks!)
        cell.ownerLabel.text = gitRepo.ownerHandle!
        cell.descriptionLabel.text = gitRepo.description!
        
        if let url = NSURL(string: gitRepo.ownerAvatarURL!) {
            cell.avatarImage.setImageWithURL(url)
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowSettings" {
            if let settingsNavVC = segue.destinationViewController as? UINavigationController {
                if let settingsVC = settingsNavVC.topViewController as? SettingsTableViewController {
                    settingsVC.githubRepoSearchSettings = searchSettings
                    println("searchSettings: \(searchSettings)")
                    println("githubRepoSearchSettings: \(settingsVC.githubRepoSearchSettings)")
                }
            }
        }
    }
    
    @IBAction func didSaveSettingsUnwind(segue: UIStoryboardSegue) {
        if let settingsVC = segue.sourceViewController as? SettingsTableViewController {
            if settingsVC.githubRepoSearchSettings != nil {
                searchSettings = settingsVC.githubRepoSearchSettings!
                doSearch()
            }
        }
    }
    
    @IBAction func didCancelSettingsUnwind(segue: UIStoryboardSegue) {
        if let settingsVC = segue.sourceViewController as? SettingsTableViewController {
            settingsVC.githubRepoSearchSettings = nil
        }
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}