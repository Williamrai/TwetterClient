//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by My Mac on 2/24/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit


class HomeTableViewController: UITableViewController {
    
    //variables
    var tweetArray = [NSDictionary]()
    var numberOfTweets : Int!
    var userInfo = NSDictionary()
    
    
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserInformations()
        
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTweets()
    }
    
    //get Data from the Twitter API and stre them in tweetArray
    //use these data to populate the tableViewCell or TweetCell
    @objc func loadTweets(){
        
        numberOfTweets = 10
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count":numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets : [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }, failure: { (Error) in
            print(Error)
            print("Could not retrieve tweets \(Error)")
        })
    }
    
    //func for loading more data
    //runs when user scroll to the end
    func loadMoreTweets(){
        numberOfTweets += 10
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count":numberOfTweets]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets : [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
    }
    
    //get User Informations
    func getUserInformations(){
        let url = "https://api.twitter.com/1.1/users/show.json";
        let params = ["screen_name" : "Okayhowareyou2"];
        TwitterAPICaller.client?.getUserInformations(url: url, parameters: params, success: { (userInfos : NSDictionary) in
            self.userInfo = userInfos
        }, failure: { (error : Error) in
            print("could not load user informations : \(error)")
        })
        
    }

    //func that triggers the users to log out
    @IBAction func onLogOut(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        UserDefaults.standard.setValue(false, forKey: "userLoggedIn")
        self.dismiss(animated: true, completion: nil)
    }
    
    //where each table view data is created
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        let entities = tweetArray[indexPath.row]["entities"] as! NSDictionary
        let medias = entities["media"] as? [NSDictionary]
        
       
        
        let name = user["name"] as? String
        cell.userNameLabel.text = name
        cell.tweetContentLabel.text = tweetArray[indexPath.row]["text"] as? String
        
        //medias
        if medias != nil{
            for media in medias!{
               
//                cell.tweetImageView.autoresizingMask = []
//                cell.tweetImageView.frame.size.height = 160.0
                
//                let screenSize: CGRect = UIScreen.main.bounds
//                cell.tweetImageView.frame = CGRect(x: 0, y: 0, width: 50, height: screenSize.height * 100)
                
//                let imageUrl = URL(string: (media["media_url_https"] as? String)!)
//                print("image URL",imageUrl)
//                let data = try? Data(contentsOf: imageUrl!)
//                if let imageData = data{
//                    cell.tweetImageView.autoresizingMask = []
//                    cell.tweetImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 160.0)
//                    cell.tweetImageView.image = UIImage(data: imageData)
//                }
//
//                let profileBannerImageUrl = URL(string: (userInfos["profile_banner_url"] as? String)!)
//                let bannerData = try? Data(contentsOf: profileBannerImageUrl!)
//                if let bannerDataData = bannerData{
//                    profileBannerImgView.image = UIImage(data: bannerDataData)
//                }
               // cell.tweetImageView.isHidden = false
                
        
              
            }
            
        }else{
//            cell.tweetImageView.frame = CGRect(x: 0, y: 0, width: 0.0 , height: 0.0)
//            cell.tweetImageView.isHidden = true
//            print("no meida for the tweet")
        }
        
        
        let relativeDate = getRelativeDate(date: (tweetArray[indexPath.row]["created_at"] as! String))
        let screenNameSection = "@\(user["screen_name"] as! String) \u{2022} \(relativeDate)"
        cell.twitterHandlerLabel.text = screenNameSection
        
        //setting up image in XCode
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data{
            cell.profileImageView.layer.masksToBounds = true
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.bounds.width / 2
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetArray[indexPath.row]["favorited"] as! Bool)
        cell.tweetId = tweetArray[indexPath.row]["id"] as! Int
        cell.setReTweeted(tweetArray[indexPath.row]["retweeted"] as! Bool)
        
        return cell
    }
    
    //section for the tableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //number of rows for the table
    //# of tableViewCell
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }
    
    //when scroll reaches the end of the screen
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if(indexPath.row + 1 == tweetArray.count){
//            //loadMoreTweets()
//        }
//    }

    
    //get the post date and convert it to relative date
    func getRelativeDate(date: String) -> String{
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"

        // Convert String to Date
        let convertedDate = dateFormatter.date(from: date) // Oct 29, 2019 at 7:15 PM


        //to relative date
        if #available(iOS 13.0, *) {
             let formatter = RelativeDateTimeFormatter()
             formatter.unitsStyle = .short
             let currentDate = Date()
            var nDate : String = formatter.localizedString(for: convertedDate!, relativeTo: currentDate) // 1 mo. ago
            if let index = nDate.firstIndex(of: "."){
                nDate.removeSubrange(index..<nDate.endIndex)
            }
            
            return nDate
            
        } else {
            // Fallback on earlier versions
            return ""
        }
    }
    
    //prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let imgUrl = userInfo["profile_image_url_https"] as? String
        
        if segue.identifier == "homeToProfile"{
            let nav = segue.destination as! UINavigationController
            let profileViewController = nav.topViewController as! ProfileViewController
            profileViewController.userInfos = userInfo
            
        }else{
            //when there is a navigation view controller
            let nav = segue.destination as! UINavigationController
            let tweetViewController = nav.topViewController as! TweetViewController
            tweetViewController.imageString = imgUrl
        }
    }
    

}
