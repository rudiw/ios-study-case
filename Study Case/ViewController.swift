//
//  ViewController.swift
//  Study Case
//
//  Created by Rudi Wijaya on 25/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ChameleonFramework


class ViewController: UITableViewController {
    
    var contents = ["category", "content1", "content2", "content3", "content4", "content5"];
    
    var listCategory: [Category] = [Category]();
    
    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController - view did load");
        
        loadCategories();
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.separatorStyle = .none;
        self.tableView.register(UINib(nibName: "CellContentCategory", bundle: nil), forCellReuseIdentifier: "cellContentCategory");
        
        
    }
    
    // MARK: - Load Categories
    func loadCategories() {
        let userToken = AppUtils.getUserToken();
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(userToken)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(AppUtils.LIST_CATEGORY_API, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
//            print("Got response result by calling '\(AppUtils.LIST_CATEGORY_API)': \(response.result)");
            
            if (response.response?.statusCode == 200) {
                print("Load categories successfully...");
                let json: JSON = JSON(response.result.value);
                for data in json["data"] {
//                    print("categoryJson: \(data.1)");
                    let category = Category(id: data.1["category_id"].intValue, name: data.1["category_name"].stringValue);
                    self.listCategory.append(category);
                }
                print("Loaded for \(self.listCategory.count) categories");
                
                self.tableView.reloadData();
            } else {
                print("Failed to load categories with errorResponse: \(response.error)");
                print("Failed to load categories with result: \(response.result.value)");
            }
        }
    }
    
    // MARK: - Table View Configurations
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let content = contents[indexPath.row];
        if (content == "category") {
            return 151.0;
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath);
        }
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let content = contents[indexPath.row];
        
        var cell: UITableViewCell;
        if (content == "category") {
           let cellContentCategory = tableView.dequeueReusableCell(withIdentifier: "cellContentCategory", for: indexPath) as! CellContentCategory;
            
            cell = cellContentCategory;
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellContent", for: indexPath);
            cell.textLabel?.text = contents[indexPath.row];
            cell.backgroundColor = UIColor.randomFlat;
        }
        
        return cell;
    }


}

