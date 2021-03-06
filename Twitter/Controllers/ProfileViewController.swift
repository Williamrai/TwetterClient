//
//  ProfileViewController.swift
//  Twitter
//
//  Created by My Mac on 3/5/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileBannerImgView: UIImageView!
    @IBOutlet weak var dpImgView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var screenNamelabel: UILabel!
    @IBOutlet weak var userFollowingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var userInfos = NSDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set images
        let dpImageUrl = URL(string: (userInfos["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: dpImageUrl!)
        if let dpImageData = data{
            dpImgView.layer.masksToBounds = true
            dpImgView.layer.cornerRadius = dpImgView.bounds.width / 2
            dpImgView.image = UIImage(data: dpImageData)
        }
        
        let profileBannerImageUrl = URL(string: (userInfos["profile_banner_url"] as? String)!)
        let bannerData = try? Data(contentsOf: profileBannerImageUrl!)
        if let bannerDataData = bannerData{
            profileBannerImgView.image = UIImage(data: bannerDataData)
        }
        
        //set labels
        userName.text = userInfos["name"] as? String
        screenNamelabel.text = userInfos["screen_name"] as? String
        let followerCount = userInfos["friends_count"] as? Int
        userFollowingLabel.text = String(followerCount!) + " Following"
        let followers = userInfos["followers_count"] as? Int
        followersLabel.text = String(followers!) + " Followers"
        

    }
    
    @IBAction func bacButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
