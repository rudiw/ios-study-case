//
//  VCSubCategory.swift
//  Study Case
//
//  Created by Rudi Wijaya on 12/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import ChameleonFramework
import Alamofire
import SwiftyJSON


class VCSubCategory: UITableViewController, UICollectionViewDataSource,
UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var parentCategory: Category?
    var breadcrumbs: [Breadcrumb] = [Breadcrumb]();
    var subCategories: [Category] = [Category]();
    
    var contents: [String] = ["banner", "breadcrumb", "subcategory", "product"];
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        print("VCSubCategory - view did load");
        
        title = parentCategory!.name;
        
        let categoryBreadcrumb = Breadcrumb(id: "\(parentCategory!.id)", name: parentCategory!.name, child: nil);
        let rootBreadcrumb = Breadcrumb(id: "home", name: "Home >", child: categoryBreadcrumb);
        breadcrumbs.append(rootBreadcrumb);
        breadcrumbs.append(categoryBreadcrumb);
        
        tableView.register(UINib(nibName: "CellBannerSubCategory", bundle: nil), forCellReuseIdentifier: "cellBannerSubCategory");
        tableView.register(UINib(nibName: "CellBreadcrumbSubCategory", bundle: nil), forCellReuseIdentifier: "cellBreadcrumbSubCategory");
        
        loadSubCategories();
    }
    
    //MARK: - Update NavBar
    override func viewWillAppear(_ animated: Bool) {
        updateNavBar()
    }
    
    func updateNavBar() {
        guard let navbar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist in VCSubCategory");
        }
        
//        guard let navbarColor = UIColor(hexString: colorHexCode) else {fatalError("Navbar color from category must not be null!")}
//
//        navbar.barTintColor = navbarColor;
//        navbar.tintColor = ContrastColorOf(navbarColor, returnFlat: true);
//        navbar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navbarColor, returnFlat: true) ]
//
//        searchBar.barTintColor = navbarColor;
        
    }
    
    // MARK: - Table Configurations
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (contents[indexPath.row] == "banner") {
            return 96.0;
        } else if (contents[indexPath.row] == "breadcrumb") {
            return 44.0
        } else {
            return 88.0;
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if (contents[indexPath.row] == "banner") {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellBannerSubCategory", for: indexPath);
        } else if contents[indexPath.row] == "breadcrumb" {
            let cellBreadcrumb = tableView.dequeueReusableCell(withIdentifier: "cellBreadcrumbSubCategory", for: indexPath) as! CellBreadcrumbSubCategory;
            cellBreadcrumb.collectionView.dataSource = self;
            cellBreadcrumb.collectionView.delegate = self;
            cellBreadcrumb.collectionView.register(UINib(nibName: "CellBreadcrumb", bundle: nil), forCellWithReuseIdentifier: "cellBreadcrumb");
            
            cell = cellBreadcrumb;
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "cellSubCategory", for: indexPath);
            cell.textLabel?.text = contents[indexPath.row];
            cell.backgroundColor = UIColor.randomFlat;
        }
        
        return cell;
    }
    
    // MARK: - Collection View Configuration
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return breadcrumbs.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let breadcrumb = breadcrumbs[indexPath.row];
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellBreadcrumb", for: indexPath) as! CellBreadcrumb;
        var txtBreadcrumb = breadcrumb.name;
        if (breadcrumb.child != nil) {
            cell.lblBreadcrumb.textColor = UIColor.purple;
        }
        cell.lblBreadcrumb.text = txtBreadcrumb;
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let breadcrumb = breadcrumbs[indexPath.row];
        let sizeText = (breadcrumb.name as! NSString).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]);
        
        return CGSize(width: sizeText.width, height: 44.0);
    }
    
    //MARK: - Load Sub Categories
    func loadSubCategories() {
        let userToken = AppUtils.getUserToken();
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(userToken)",
            "Accept": "application/json"
        ]
        
        Alamofire.request(AppUtils.LIST_SUB_CATEGORY_API + "\(parentCategory!.id)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            if (response.response?.statusCode == 200) {
                print("Load sub categories by parent \(self.parentCategory!.id) successfully...");
                let json: JSON = JSON(response.result.value);
                for data in json["data"] {
                    //                    print("categoryJson: \(data.1)");
                    let category = Category(id: data.1["subcategory_id"].intValue, name: data.1["subcategory_name"].stringValue, parent: self.parentCategory!);
                    self.subCategories.append(category);
                }
                print("Loaded for \(self.subCategories.count) sub categories by parent \(self.parentCategory!.name)");
                
//                let firstCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0));
//                if (firstCell is CellContentCategory) {
//                    let cellContentCategory = firstCell as! CellContentCategory;
//                    print("Reload sub category list view...");
//                    cellContentCategory.collViewCategory.reloadData();
//                }
                
            } else {
                print("Failed to load categories with errorResponse: \(response.error)");
                print("Failed to load categories with result: \(response.result.value)");
            }
        }
    }
    
}
