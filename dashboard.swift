//
//  DashboardViewController.swift
//  Digital Health Passport
//
//  Created by student on 3/29/22.
//

import UIKit
import Foundation


struct Transactions: Codable {
    let _id, transaction_id, issuer_id, holder_id: String?
    let createdAt, updatedAt: String?
    let __v: Int?
    var info: Info?
}

struct Info: Codable {
    let reportType, name, report, by, fullname, serviceType, serviceName, contact, eligibleToFly: String?

}

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        postData()
        // Do any additional setup after loading the view.
    }
    
    var user: User? = nil
    var token: String = ""
    
    
    var txs: [Transactions] = []
    
    func postData() {
        let userid = user?._id ?? ""
        let reqURL = "https://dhp-server.herokuapp.com/api/holder/search/all/\(userid)"
        print(reqURL)
        // 1) create URL
        guard let url = URL(string:reqURL) else { fatalError("error with URL ")}
        // 2) create request
        var httpRequest = URLRequest(url: url)
        httpRequest.httpMethod = "GET"
        httpRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
       
        // 3) create data task with closures
        let dataTask = URLSession.shared.dataTask(with: httpRequest) {( data, response, Error) in
            
            // 3.1) null check
            guard let data = data else {return }
         
            // 3.2) parsing the JSON to struct
            do {
                let decoded = try JSONDecoder().decode([Transactions].self, from: data);
                DispatchQueue.main.async {
                    self.txs = decoded
                }
               
            } catch let error {
                print("Error in JSON parsing", error)
            }
        }
        // 4) make an API call
        dataTask.resume()
    }

}
