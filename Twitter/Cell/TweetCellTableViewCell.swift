//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by My Mac on 2/24/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    //Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var twitterHandlerLabel: UILabel!
    @IBOutlet weak var retweetBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var tweetImageView: UIImageView!
    
    var favorited : Bool = false
    var tweetId : Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    @IBAction func retweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.setReTweeted(true)
        }, failure: { (Error) in
            print("Retweet Failed \(Error)")
        })
    }
    
    @IBAction func favoriteTweet(_ sender: Any) {
        let toBeFavorited = !favorited
        if toBeFavorited {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(true)
            }, failure: { (Error) in
                print("Favorite did not succeed \(Error)")
            })
        }else{
            TwitterAPICaller.client?.unFavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(false)
            }, failure: { (Error) in
                print("UnFavorite did not succeed \(Error)")
            })
        }
    }
    
    
    //helper function
    //@func favorite
    func setFavorite(_ isFavorited : Bool) {
        favorited = isFavorited
        
        if favorited {
            favBtn.setImage(UIImage(named: "heart"), for: UIControl.State.normal)
        }else{
            favBtn.setImage(UIImage(named: "X_heart"), for: UIControl.State.normal)
        }
    }
    
    func setReTweeted(_ isRetweeted : Bool){
        if isRetweeted {
            retweetBtn.setImage(UIImage(named: "retweet_set"), for: UIControl.State.normal)
            retweetBtn.isEnabled = false
        }else{
            retweetBtn.setImage(UIImage(named: "retweet"), for: UIControl.State.normal)
            retweetBtn.isEnabled = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
