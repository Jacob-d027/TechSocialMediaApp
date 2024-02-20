//
//  ProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/5/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userPostsTableView: UITableView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var actualNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var techInterestsLabel: UILabel!
    
    var user: User = User.current!
    private var userPosts: [Post]?
    var postController = PostController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPostsTableView.dataSource = self
        userPostsTableView.delegate = self
        
        Task {
            do {
                userPosts = try await postController.fetchUserPosts(pageNumber: 0)
                userPostsTableView.reloadData()
                print("It has reached this point")
            } catch {
                print("An error occurred: \(error)")
            }
        }
        
        
        
        setupProfileView()
        // Do any additional setup after loading the view.
    }
    
    func setupProfileView() {
        
        userNameLabel.text = user.userName
        actualNameLabel.text = user.firstName + " " + user.lastName
        bioLabel.text = "Enter bio here..."
        techInterestsLabel.text = "Enter tech interests here..."
        
        //        print(user.secret)
        //        print(user.userUUID)
    }
    
     // MARK: - Navigation
    
    @IBAction func unwindToUserPostTableView(segue: UIStoryboardSegue) {
        guard let sourceVC = segue.source as? CreateNewPostTableViewController, let post = sourceVC.post, var userPosts = userPosts else { return }
        
        if let indexPath = userPostsTableView.indexPathForSelectedRow {
            userPosts.remove(at: indexPath.row)
            userPosts.insert(post, at: indexPath.row)
            userPostsTableView.deselectRow(at: indexPath, animated: true)
            userPostsTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            userPosts.append(post)
            userPostsTableView.insertRows(at: [IndexPath(row: userPosts.count - 1, section: 0)], with: .automatic)
        }
    }
     
    @IBSegueAction func editUserPost(_ coder: NSCoder, sender: Any?) -> CreateNewPostTableViewController? {
        
        // Checks to make sure that cell tapped is actually a post, keeps indexpath of cell, and unwraps userPosts to work with.
        guard let cell = sender as? PostTableViewCell, let indexPath = userPostsTableView.indexPath(for: cell), let userPosts = userPosts else {
            return nil
        }
        
        let editPost = userPosts[indexPath.row]
        
        return CreateNewPostTableViewController(coder: coder, sentPost: editPost, formMode: .edit)
    }
    
}

// MARK: User Posts TableView

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = userPostsTableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell, let posts = userPosts else {
            return UITableViewCell()
        }
        
        cell.configure(for: posts[indexPath.row])
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let userPosts = userPosts else { return }
//        let editPost = userPosts[indexPath.row]
//        
//        performSegue(withIdentifier: "editUserPost", sender: editPost)
//    }
//    
    
}
