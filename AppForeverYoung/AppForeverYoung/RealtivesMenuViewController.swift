//
//  RealtivesMenuViewController.swift
//  AppForeverYoung
//
//  Created by Renato Tramontano on 26/02/17.
//  Copyright © 2017 iosparthenopedeveloper. All rights reserved.
//

import UIKit
import UserNotifications // LEVARE

var name = ""
var surname = ""
var imagex = ""

class RealtivesMenuViewController: UIViewController {
    
    @IBOutlet var imagePerson: UIImageView!
    @IBOutlet var namePerson: UILabel!
    @IBOutlet var surnamePerson: UILabel!
    
    
    @IBOutlet var ms1: UILabel!
    @IBOutlet var ms2: UILabel!
    @IBOutlet var ms3: UILabel!
    @IBOutlet var ms4: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imagex != "" {
            downloadImage(url: URL(string: imagex)!, imageView: imagePerson)
            self.imagePerson.layer.cornerRadius = self.imagePerson.frame.size.width / 2
            self.imagePerson.clipsToBounds = true
            namePerson.text = name
            surnamePerson.text = surname
//            ms1.text = lastSms
//            ms2.text = lastNotify
//            ms3.text = lastPosition
//            ms4.text = goodMorning
        }
        
        scheduleNotification() // LEVARE
    }
    
    // LEVARE
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Answer"
        //content.subtitle = "Let's see how smart you are!"
        content.body = "I'm fine thanks"
        content.badge = 0
        content.categoryIdentifier = "quizCategory"
        content.sound = UNNotificationSound.default()
        let url = Bundle.main.url(forResource: "vincenzo", withExtension: "jpg")
        
        if let attachment = try? UNNotificationAttachment(identifier: "africaQuiz", url: url!, options: nil) {
            content.attachments = [attachment]
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let requestIdentifier = "africaQuiz"
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            // handle error
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, imageView: UIImageView) {
        print("Download Started")
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                imageView.image = UIImage(data: data)
            }
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
}
