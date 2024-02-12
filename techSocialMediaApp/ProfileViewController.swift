//
//  ProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Jacob Davis on 2/5/24.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var actualNameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var techInterestsLabel: UILabel!
    
    var user: User = User.current!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProfileView()
        // Do any additional setup after loading the view.
    }
    
    func setupProfileView() {
        
        userNameLabel.text = user.userName
        actualNameLabel.text = user.firstName + " " + user.lastName
        bioLabel.text = "Enter bio here..."
        techInterestsLabel.text = "Enter tech interests here..."
        print(user.secret)
//        print(user.userUUID)
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
