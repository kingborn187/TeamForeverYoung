//
//  RealtivesMenuViewController.swift
//  AppForeverYoung
//
//  Created by Renato Tramontano on 26/02/17.
//  Copyright © 2017 iosparthenopedeveloper. All rights reserved.
//

import UIKit

class RealtivesMenuViewController: UIViewController {
    
    @IBOutlet var imagePerson: UIImageView!
    @IBOutlet var namePerson: UILabel!
    @IBOutlet var surnamePerson: UILabel!
    
    var name = ""
    var surname = ""
    var imagex = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        namePerson.text = name
        surnamePerson.text = surname
        if imagex != "" {
            downloadImage(url: URL(string: imagex)!, imageView: imagePerson)
        }
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
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
}
