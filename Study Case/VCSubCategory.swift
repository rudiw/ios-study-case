//
//  VCSubCategory.swift
//  Study Case
//
//  Created by Rudi Wijaya on 12/03/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit


class VCSubCategory: UITableViewController {
    
    var parentCategory: Category?
    
    var contents: [String] = ["banner", "indicator", "subcategory", "product"];
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        print("VCSubCategory - view did load");
        
        title = parentCategory!.name;
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellSubCategory", for: indexPath);
        cell.textLabel?.text = contents[indexPath.row];
        return cell;
    }
    
}
