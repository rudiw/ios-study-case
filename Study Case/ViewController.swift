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


class ViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    var contents = ["category", "content1", "content2", "content3", "content4", "content5", "content6", "content7", "content8", "content9", "content10"];
    
    var listCategory: [Category] = [Category]();
    
    var selectedParentCategory: Category?
    
    // MARK: - View Did Load

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewController - view did load");
        
        loadCategories();
//        listCategory.append(Category(id: 1, name: "category 1"));
//        listCategory.append(Category(id: 2, name: "category 2"));
//        listCategory.append(Category(id: 3, name: "category 3"));
//        listCategory.append(Category(id: 4, name: "category 4"));
//        listCategory.append(Category(id: 5, name: "category 5"));
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.separatorStyle = .none;
        self.tableView.register(UINib(nibName: "CellContentCategory", bundle: nil), forCellReuseIdentifier: "cellContentCategory");

    }
    
    
    // MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {

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
                
                let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0));
                if (firstCell is CellContentCategory) {
                    let cellContentCategory = firstCell as! CellContentCategory;
                    print("Reload category list view...");
                    cellContentCategory.collViewCategory.reloadData();
                }
                
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
//            return super.tableView(tableView, heightForRowAt: indexPath);
            return 88.0;
        }
        
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contents.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let content = contents[indexPath.row];
        
        var cell: UITableViewCell;
        if (content == "category") {
            let cellContentCategory = tableView.dequeueReusableCell(withIdentifier:  "cellContentCategory", for: indexPath) as! CellContentCategory;
            
            cellContentCategory.collViewCategory.dataSource = self;
            cellContentCategory.collViewCategory.delegate = self;
            cellContentCategory.collViewCategory.register(UINib(nibName: "CellCategory", bundle: nil), forCellWithReuseIdentifier: "cellCategory");

            cell = cellContentCategory;
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellContent", for: indexPath);
            cell.textLabel?.text = contents[indexPath.row];
            cell.backgroundColor = UIColor.randomFlat;
        }
        
        return cell;
    }
    
    // MARK: - List Category View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCategory.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCategory", for: indexPath) as! CellCategory;
        
        let category = listCategory[indexPath.row];
        
        cell.lblCategoryName.text = category.name;
        cell.imgCategory.image = UIImage(named: "category");
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 151.0, height: 151.0);
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedParentCategory = listCategory[indexPath.row]
//        print("Selected at \(indexPath.row) category: \(selectedParentCategory.name)");
        
        performSegue(withIdentifier: "viewControllerToVcSubCategory", sender: self);
    }

    // MARK: - Event Rotate
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.tableView.reloadData();
    }
    
    // MARK: - Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination;
        if (destination is VCSubCategory) {
            let vcSubCategory = destination as! VCSubCategory;
            vcSubCategory.parentCategory = selectedParentCategory!;
        }
    }

}

