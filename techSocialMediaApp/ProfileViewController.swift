//
//  ProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/5/24.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: Variables
    
    @IBOutlet weak var userPostsTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var actualNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var techInterestsLabel: UILabel!
    
    var user: User = User.current!
    private var userPosts: [Post]?
    var postController = PostController()
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userPostsTableView.dataSource = self
        userPostsTableView.delegate = self
        
        Task {
            do {
               let fetchedUserPosts = try await postController.fetchUserPosts(pageNumber: 0)
                userPosts = fetchedUserPosts
                userPostsTableView.reloadData()
                print("It has reached this point")
            } catch {
                print("An error occurred: \(error)")
            }
        }
        setupProfileView()
        
    }
    
    // MARK: Functions
    
    func deletePost(post: Post) async throws {
        try await postController.deletePost(postid: post.postid)
    }
    
    func setupProfileView() {
        userNameLabel.text = user.userName
        actualNameLabel.text = user.firstName + " " + user.lastName
        bioLabel.text = "Enter bio here..."
        techInterestsLabel.text = "Enter tech interests here..."
        
    }
    
     // MARK: - Navigation
    
    @IBAction func unwindToUserPostTableView(segue: UIStoryboardSegue) {
        guard let sourceVC = segue.source as? CreateNewPostTableViewController, let post = sourceVC.post else { return }
        
        if let indexPath = userPostsTableView.indexPathForSelectedRow {
            userPosts?.remove(at: indexPath.row)
            userPosts?.insert(post, at: indexPath.row)
            userPostsTableView.deselectRow(at: indexPath, animated: true)
            userPostsTableView.reloadRows(at: [indexPath], with: .automatic)
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postToDelete = userPosts![indexPath.row]
            let alertController = UIAlertController(title: "Delete Post?", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                Task {
                    do {
                        try await self.deletePost(post: postToDelete)
                        self.userPosts?.remove(at: indexPath.row)
                        self.userPostsTableView.deleteRows(at: [indexPath], with: .automatic)
                    } catch {
                        print("There was an error: \(error)")
                    }
                }
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true)
            
        }
    }
}
