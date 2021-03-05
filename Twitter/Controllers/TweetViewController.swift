//
//  TweetViewController.swift
//  Twitter
//
//  Created by My Mac on 3/2/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var tweetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.text = "Write your thoughts"
        tweetTextView.textColor = UIColor.lightGray
        tweetTextView.delegate = self
        
        //brings up the keyboard
        tweetTextView.becomeFirstResponder()
        
        //bring the cursor to the begining of the textView
        tweetTextView.selectedTextRange = tweetTextView.textRange(from: tweetTextView.beginningOfDocument, to: tweetTextView.beginningOfDocument)
    }
    
    //UITextViewDelegates
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentTex:String = textView.text
        let updatedText = (currentTex as NSString).replacingCharacters(in: range, with: text)
        print(updatedText)
        if updatedText.isEmpty{
            textView.text = "Write your thoughts"
            textView.textColor = UIColor.lightGray
            
            //bring the cursor to the begining of the textView
            tweetTextView.selectedTextRange = tweetTextView.textRange(from: tweetTextView.beginningOfDocument, to: tweetTextView.beginningOfDocument)
        }else if textView.textColor == UIColor.lightGray && !text.isEmpty{
            textView.textColor = UIColor.black
            textView.text = text
        }else{
            return true
        }
        
        return false
    }
  
    
    
    
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
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
