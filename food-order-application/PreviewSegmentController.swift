//
//  PreviewSegmentController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-27.
//

import UIKit


struct Objects{
    var sectionName:String!
    var sectionObjects:[ItemModels]!
}

var objectsArray=[Objects]()

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var tglAvailable: UISwitch!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblFoodDiscount: UILabel!
    @IBOutlet weak var lblFoodPrice: UILabel!
    @IBOutlet weak var imgFoodImage: UIImageView!
}

class PreviewSegmentController: UIViewController {

    var sectionItem:[String:[ItemModels]]=[:]

    
    @IBOutlet weak var tblCategoryItemTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeCategoryArray()
        print(objectsArray)
        self.tblCategoryItemTable.delegate=self
        self.tblCategoryItemTable.dataSource=self
        self.tblCategoryItemTable.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func makeCategoryArray(){
        for item in ItemData.itemList{
            if !self.sectionItem.keys.contains(item.category){
                self.sectionItem[item.category]=[]
                self.sectionItem[item.category]?.append(item)
            }else{
                self.sectionItem[item.category]?.append(item)
            }
        }
        for (key,value) in self.sectionItem{
            objectsArray.append(Objects(sectionName: key, sectionObjects: value))
        }
    }
    
}

extension PreviewSegmentController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension PreviewSegmentController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return objectsArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return objectsArray.count
    }
    
    func numberOfSectionsInTableView(table:UITableView)->Int{
        return objectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoryTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cellCategory") as! CategoryTableViewCell
        
        cell.imgFoodImage.imageFromServerURL(urlString: objectsArray[indexPath.section].sectionObjects[indexPath.row].itemThumbnail)
        cell.lblFoodName.text = objectsArray[indexPath.section].sectionObjects[indexPath.row].itemName
        cell.lblFoodDescription.text = objectsArray[indexPath.section].sectionObjects[indexPath.row].itemDescription
        cell.lblFoodPrice.text = String(format:"%.2f", objectsArray[indexPath.section].sectionObjects[indexPath.row].itemPrice)
        
        if objectsArray[indexPath.section].sectionObjects[indexPath.row].itemDiscount == 0.0{
            cell.lblFoodDiscount.isHidden=true
        }else{
            cell.lblFoodDiscount.text=String(format:"%.2f", objectsArray[indexPath.section].sectionObjects[indexPath.row].itemDiscount)
        }
        
        

        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        cell.layer.masksToBounds = false
        return cell
    }
}

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        self.image = nil
        let urlStringNew = urlString.replacingOccurrences(of: " ", with: "%20")
        URLSession.shared.dataTask(with: NSURL(string: urlStringNew)! as URL, completionHandler: { (data, response, error) -> Void in

            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })

        }).resume()

    }
}


