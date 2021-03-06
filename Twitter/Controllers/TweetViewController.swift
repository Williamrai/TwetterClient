//
//  TweetViewController.swift
//  Twitter
//
//  Created by My Mac on 3/2/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    //outlets
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var dpForTweetImageView: UIImageView!
    @IBOutlet weak var countbottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var charCountLabel: UILabel!
    
    //constants
    let placeholder = "Write your thoughts"
    var imageString : String!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        charCountLabel.text = "characters : 280"
        tweetTextView.text = placeholder
        tweetTextView.textColor = UIColor.lightGray
        tweetTextView.delegate = self
        
        //brings up the keyboard
        tweetTextView.becomeFirstResponder()
        
        //bring the cursor to the begining of the textView
        tweetTextView.selectedTextRange = tweetTextView.textRange(from: tweetTextView.beginningOfDocument, to: tweetTextView.beginningOfDocument)
        
        //observer
        
        
        let imageUrl = URL(string: imageString)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data{
            dpForTweetImageView.layer.masksToBounds = true
            dpForTweetImageView.layer.cornerRadius = dpForTweetImageView.bounds.width / 2
            dpForTweetImageView.image = UIImage(data: imageData)
        }
        
        
        
    }//end of viewDidLoad()
    
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }//end of cancel()
    
    @IBAction func tweet(_ sender: Any) {
        if(!tweetTextView.text.isEmpty && tweetTextView.text != "Write your thoughts"){
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error: Error) in
                print("Error posting tweet \(error)")
            })
        }else{
            dismiss(animated: true, completion: nil)
        }
    }//end of tweeet()
    
 
    

    
    //UITextViewDelegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentTex:String = textView.text
        var characterLimit = 280
        
        let updatedText = (currentTex as NSString).replacingCharacters(in: range, with: text)

        
        if updatedText.isEmpty{
            textView.text = placeholder
            textView.textColor = UIColor.lightGray
            
            //bring the cursor to the begining of the textView
            tweetTextView.selectedTextRange = tweetTextView.textRange(from: tweetTextView.beginningOfDocument, to: tweetTextView.beginningOfDocument)
        }else if textView.textColor == UIColor.lightGray && !text.isEmpty{
            textView.textColor = UIColor.black
            textView.text = nil
            print("text after: ",text)
        }
        
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
        
        characterLimit -=  newText.count
        charCountLabel.text = "characters : \(String(characterLimit))"
        
        return newText.count < characterLimit
        
    }//end of textView should Change Text In delegate
    
    //for always setting the cursor at the begining when textview color is light gray
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil{
            if tweetTextView.textColor == UIColor.lightGray{
                tweetTextView.selectedTextRange = tweetTextView.textRange(from: tweetTextView.beginningOfDocument, to: tweetTextView.beginningOfDocument)
            }
        }
    }//end of text View Did Change Selection delegate
    
   
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
