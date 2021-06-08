//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML


class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    let swifter = Swifter(consumerKey: "please enter your API Key", consumerSecret: "Please enter your secret key")

    
    @IBOutlet weak var sentimentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func predictPressed(_ sender: Any) {
        
        if let searchText = textField.text{
            swifter.searchTweet(using: searchText, lang: "en", count: 100, tweetMode: .extended) { (results, metadata) in
                var tweets = [TweetSentimentClassifierInput]()
                
                for i in 0 ..< 100 {
                    if let tweet = results[i]["full_text"].string{
                        //print(tweet)
                        let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                        tweets.append(tweetForClassification)
                    }
                }
                
                
                do{
                   let predictions = try self.sentimentClassifier.predictions(inputs: tweets) // array
                   var sentimentScore = 0
                    for pred in predictions{
                        let sentiment = pred.label
                        if sentiment == "Pos"{
                            sentimentScore += 1
                        }else if sentiment == "Neg"{
                            sentimentScore -= 1
                        }
                   }
                    //print(sentimentScore)
                    if sentimentScore > 20{
                        self.sentimentLabel.text = "🥰"
                    } else if sentimentScore > 10{
                        self.sentimentLabel.text = "😘"
                    }else if sentimentScore > 0{
                        self.sentimentLabel.text = "😃"
                    }else if sentimentScore > -10{
                        self.sentimentLabel.text = "😐"
                    }else if sentimentScore > -20{
                        self.sentimentLabel.text = "😡"
                    }else{
                        self.sentimentLabel.text = "👺"
                    }
                }catch{
                    print("error in making prediction")
                }
            } failure: { error in
                print("error in API\(error)")
            }
        }
    
    }
    
}

