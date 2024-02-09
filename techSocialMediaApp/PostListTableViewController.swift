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
                posts = try await postController.fetchPosts(userSecret: user.secret, pageNumber: <#T##Int?#>)
            } catch {
                print("There was an error: \(error.localizedDescription)")
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell()}
        
        cell.configure(for: posts[indexPath.row])
        
        return cell
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
