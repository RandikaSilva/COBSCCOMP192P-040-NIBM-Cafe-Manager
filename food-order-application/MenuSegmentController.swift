//
//  MenuSegmentController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-27.
//

import UIKit

class MenuSegmentController:  UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var imagePicker: ImagePicker!
    var pickerData:[String]=[]
    var pickedImage:Data!
    var pickerCategory:String!=""
    @IBOutlet weak var pkrCategory: UIPickerView!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var imgItemViewer: UIImageView!
    @IBOutlet weak var txtItemName: UITextField!
    @IBOutlet weak var txtItemPrice: UITextField!
    @IBOutlet weak var txtItemDiscount: UITextField!
    @IBOutlet weak var txtItemDescription: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pkrCategory.delegate = self
        self.pkrCategory.dataSource = self
        self.btnAddItem.addTarget(self, action: #selector(self.addNewItem(sender:)), for: .touchUpInside)
        
        FirebaseService().getAllCategories(){
            completion in
            self.makePickerData(){
                completion in
                
                self.imagePicker = ImagePicker(presentationController: self, delegate: self)
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.loadImageButtonTapped(tapGestureRecognizer:)))
                self.imgItemViewer.isUserInteractionEnabled = true
                self.imgItemViewer.addGestureRecognizer(tapGestureRecognizer)
                self.pkrCategory.reloadAllComponents()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerCategory=self.pickerData[row]
    }
    
    @IBAction func loadImageButtonTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.imagePicker.present(from: self.view)
    }
    
    @objc func addNewItem(sender:UIButton){
        let itemId=NSUUID().uuidString.replacingOccurrences(of:"-", with: "")
        
        FirebaseService().upload(data:self.pickedImage , itemId: itemId){
            completion in
            
            let itemName=self.txtItemName.text!
            let itemPrice=Float(self.txtItemPrice.text ?? "0.0")!
            let itemDiscount=Float(self.txtItemDiscount.text ?? "0.0")!
            let itemThumbnail=completion as! String
            let itemDescription=self.txtItemDescription.text!
            let category=self.pickerCategory!
            
            let item:ItemModels=ItemModels(itemId: itemId, itemName: itemName, itemThumbnail: itemThumbnail, itemDescription: itemDescription, itemPrice: itemPrice,itemDiscount:itemDiscount,isAvailable:true, category: category)
            
            FirebaseService().addNewItem(item: item){
                completion in
                
                print("New Item Added")
            }
        }
    }
    
    private func makePickerData(completion: @escaping (Any)->()){
        self.pickerData.removeAll()
        for category in CategoryData.categoryList{
            self.pickerData.append(category.categoryName)
        }
        completion(true)
    }
}

extension MenuSegmentController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.imgItemViewer.image = image
        self.pickedImage=image?.pngData()
    }
}

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
}

open class ImagePicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension ImagePicker: UINavigationControllerDelegate {
}
