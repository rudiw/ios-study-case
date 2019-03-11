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


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblCategory: UITableView!
    
    var listCategory: [Category] = [Category]();
    
    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController - view did load");
        
        loadCategories();
        
        tblCategory.delegate = self;
        tblCategory.dataSource = self;
        tblCategory.separatorStyle = .none;
        //TODO: Register your CategoryCell.xib file here:
        tblCategory.register(UINib(nibName: "CellCategory", bundle: nil), forCellReuseIdentifier: "myCellCategory");
        
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
                
                self.tblCategory.reloadData();
            } else {
                print("Failed to load categories with errorResponse: \(response.error)");
                print("Failed to load categories with result: \(response.result.value)");
            }
        }
    }
    
    // MARK: - Table View Configurations
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listCategory.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCellCategory", for: indexPath) as! CellCategory;
        
        let category = listCategory[indexPath.row];
        cell.lblCategoryName.text  = category.name;
        cell.imgCategory.image = UIImage(named: "category");
        
        return cell;
    }
    
    //TODO: Declare configureTableView here:
    func configureTableView() {
        tblCategory.rowHeight = UITableView.automaticDimension;
        tblCategory.estimatedRowHeight = 151.0;
    }


}

