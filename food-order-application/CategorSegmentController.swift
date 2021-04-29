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

    @IBOutlet weak var CategoryTxt: UITextField!
    
    @IBOutlet weak var CategoryTbl: UITableView!
    @IBOutlet weak var CategoryAdd: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.CategoryAdd.addTarget(self, action: #selector(self.addNewCategory(sender:)), for: .touchUpInside)
        FirebaseService().GetCategoryAll(){
            completion in
            self.CategoryTbl.delegate=self
            self.CategoryTbl.dataSource=self
            self.CategoryTbl.reloadData()
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        super.viewWillAppear(animated)
        
    }
    
    @objc func addNewCategory(sender:UIButton){
        
        let categoryId = NSUUID().uuidString.replacingOccurrences(of:"-", with: "")
        let categoryName = self.CategoryTxt.text as! String
        let category:CategoryModel = CategoryModel(categoryId:categoryId, categoryName:categoryName)
        FirebaseService().AddCategoryNew(category: category){
            completion in
            print("Category Added")
            self.CategoryTbl.reloadData()
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


