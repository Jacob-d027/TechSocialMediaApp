//
//  PostListTableViewController.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/8/24.
//

import UIKit

class PostListTableViewController: UITableViewController {
    
    var user = User.current!
    var posts: [Post] = []
    var postController = PostController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                posts = try await postController.fetchPosts(pageNumber: 0)
                print("Operation Successful")
                tableView.reloadData()
            } catch {
                print("There was an error: \(error)")
            }
            
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        
        cell.configure(for: posts[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    @IBSegueAction func createNewPost(_ coder: NSCoder, sender: Any?) -> CreateNewPostTableViewController? {
        return CreateNewPostTableViewController(coder: coder, sentPost: nil, formMode: .create)
    }
    
    @IBAction func unwindToPostListTable(segue: UIStoryboardSegue) {
        guard let source = segue.source as? CreateNewPostTableViewController,
              let newPost = source.post else { return }
        
        posts.append(newPost)
        tableView.reloadData()
    }
    
}
