//
//  MemoryInterfaceController.swift
//  AppForeverYoung
//
//  Created by Renato Tramontano on 02/03/17.
//  Copyright © 2017 iosparthenopedeveloper. All rights reserved.
//

import WatchKit
import Foundation


class MemoryInterfaceController: WKInterfaceController {
    

    @IBOutlet var tableView: WKInterfaceTable!
    
    let memory = DataBase.getMemory()
    var classMemory: [MemoryInterfaceController] = []

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        tableView.setNumberOfRows(memory.count, withRowType: "MemoryRows")
        setupTable()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func setupTable() {
        for i in 0 ... memory.count {
            if let row = tableView.rowController(at: i) as? MemoryRow {
                row.tit.setText(memory[i].titleMemory)
                row.date.setText(memory[i].dateMemory)
                row.time.setText(memory[i].timeMemory)
                row.body.setText(memory[i].bodyMemory)
                downloadImage(url: URL(string: ("http://kingborn187.altervista.org/AppForeverYoung/MemoryService/api/"+memory[i].telephone+memory[i].titleMemory+".jpg"))!, imageView: row.image)
                print("http://kingborn187.altervista.org/AppForeverYoung/MemoryService/api/"+memory[i].telephone+memory[i].titleMemory+".jpg")
            }
        }
    }
    
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL, imageView: WKInterfaceImage) {
        print("Download Started")
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                imageView.setImage(UIImage(data: data))
            }
        }
    }

}

