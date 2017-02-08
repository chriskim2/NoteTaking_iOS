//
//  MemoViewController.swift
//  NoteTaking
//
//  Created by donghyun kim on 2016-12-24.
//  Copyright © 2016 donghyun kim. All rights reserved.
//

import UIKit
import CoreLocation

class MemoViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var txtField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var btnMap: UIButton!
    
    var nItem: Memo? = nil
    var imageUri: String? = nil
    var currentLat: CLLocationDegrees = 43.642411
    var currentLng: CLLocationDegrees = -79.386713

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = nItem {
            txtField.text = nItem?.note
            if item.img_uri != nil && item.img_uri != "" {
                showImage()
                self.currentLat = item.lat
                self.currentLng = item.lng
                
                photoBtnEnable(false)
                mapBtnEnable(true)
            }
            // no Image
            else {
                photoBtnEnable(true)
                mapBtnEnable(false)
            }
        }
        else {
            photoBtnEnable(true)
            mapBtnEnable(false)
        }
        
        // Do any additional setup after loading the view.
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.currentLat = Double(locValue.latitude)
        self.currentLng = Double(locValue.longitude)
        self.locationManager.stopUpdatingLocation()
    }

    @IBAction func btnPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
        }
        else {
            let image = UIImage(named: "cn_tower")
            imageView.image = image
            imageUri = "unknown"
        }
        
        photoBtnEnable(false)
        mapBtnEnable(true)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        navigationController!.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if nItem != nil {
            editItem()
        }
        else {
            newItem()
        }
    }
    
    func photoBtnEnable(_ value: Bool) {
        btnPhoto.isEnabled = value
        btnPhoto.alpha = value ? 1 : 0.5
    }
    
    func mapBtnEnable(_ value: Bool) {
        btnMap.isEnabled = value
        btnMap.alpha = value ? 1 : 0.5
    }
    
    func showImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
        }
        else {
            let image = UIImage(named: "cn_tower")
            imageView.image = image
        }
    }
    
    func newItem() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let memo = Memo(context: context)
        
        memo.title = getCurrentDate()
        memo.note = txtField.text!
        
        if let img = self.imageUri {
            memo.img_uri = img
            memo.lat = Double(self.currentLat)
            memo.lng = Double(self.currentLng)
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    func editItem() {
        nItem!.title = getCurrentDate()
        nItem!.note = txtField.text!
        
        if let img = self.imageUri {
            nItem!.img_uri = img
            nItem!.lat = Double(self.currentLat)
            nItem!.lng = Double(self.currentLng)
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController!.popViewController(animated: true)
    }
    
    func getCurrentDate() -> String {
        let now = NSDate() as Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: now)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "show_map" {
            let dest : MapViewController = segue.destination as! MapViewController
            
            if nItem != nil && nItem?.img_uri != nil {
                dest.currentLat = nItem!.lat
                dest.currentLng = nItem!.lng
            }
            else {
                dest.currentLat = self.currentLat
                dest.currentLng = self.currentLng
            }
        }
    }
}
