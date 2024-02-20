//
//  CreateNewPostTableViewController.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/12/24.
//

import UIKit

class CreateNewPostTableViewController: UITableViewController {
    
    enum FormMode {
        case create, edit
    }
    
    var formMode: FormMode
    var post: Post?
    var postController = PostController()
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    init?(coder: NSCoder, sentPost: Post?, formMode: FormMode) {
        self.post = sentPost
        self.formMode = formMode
        super.init(coder: coder)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if formMode == .edit {
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        guard let title = titleTextfield.text, let body = bodyTextView.text else { return }
        
        
        if formMode == .edit {
            
        }
        Task {
            do {
                post = try await postController.createNewPost(title: title, bodyText: body)
                performSegue(withIdentifier: "UnwindToPostListTable", sender: self)
            } catch {
                print("There was an error: \(error)")
            }
        }
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
