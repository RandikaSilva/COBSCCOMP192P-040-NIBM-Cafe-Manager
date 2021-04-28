//
//  CategorSegmentController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-27.
//

import UIKit

class CategoryTableViewCells: UITableViewCell {
   @IBOutlet weak var lblCategoryName: UILabel!
}

class CategorSegmentController: UIViewController {

    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var tblCategory: UITableView!
    @IBOutlet weak var addCategoryBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addCategoryBtn.addTarget(self, action: #selector(self.addNewCategory(sender:)), for: .touchUpInside)
        FirebaseService().getAllCategories(){
            completion in
            self.tblCategory.delegate=self
            self.tblCategory.dataSource=self
            self.tblCategory.reloadData()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        
    }
    
    @objc func addNewCategory(sender:UIButton){
        print("234")
        let categoryId = NSUUID().uuidString.replacingOccurrences(of:"-", with: "")
        let categoryName = self.txtCategory.text as! String
        let category:CategoryModel = CategoryModel(categoryId:categoryId, categoryName:categoryName)
        FirebaseService().addNewCategory(category: category){
            completion in
            print("Category Added")
            self.tblCategory.reloadData()
        }
    }
}

extension CategorSegmentController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension CategorSegmentController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CategoryData.categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoryTableViewCells =  tableView.dequeueReusableCell(withIdentifier: "tblCategoryCell") as! CategoryTableViewCells
        cell.lblCategoryName.text=CategoryData.categoryList[indexPath.row].categoryName
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}


