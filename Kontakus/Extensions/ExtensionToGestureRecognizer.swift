//
//  ExtensionToGestureRecognizer.swift
//  Kontakus
//
//  Created by Cüneyd on 13.01.2020.
//  Copyright © 2020 com.kontakus.www. All rights reserved.
//

import UIKit

extension MainViewController: UIGestureRecognizerDelegate {
    func viewSelector(panGesture: UIPanGestureRecognizer? = nil, tapGesture: UITapGestureRecognizer? = nil, longPressGesture: UILongPressGestureRecognizer? = nil) {
        if (panGesture != nil) {
            for i in 0..<cellArray.count {
                if panGesture?.view == cellArray[i] {
                    index = i
                }
            }
        }
        else if (tapGesture != nil){
            for i in 0..<cellArray.count{
                if tapGesture?.view == cellArray[i] {
                    index = i
                }
            }
        }
        else if (longPressGesture != nil){
            for i in 0..<cellArray.count{
                if longPressGesture?.view == cellArray[i] {
                    index = i
                }
            }
        }
    }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
        guard recognizer.view != nil else {return}
        viewSelector(panGesture: recognizer)
        let profileView = recognizer.view!
        let translation = recognizer.translation(in: view)
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: view)
        
        if (profileView.center.x) + translation.x + 60 < scrollView.contentSize.width && (profileView.center.y) + translation.y + 60 <
            scrollView.contentSize.height && (profileView.center.x) + translation.x - 60 > 0 && (profileView.center.y) + translation.y - 60 > 0 {
            profileView.center = CGPoint.init(x: (profileView.center.x) + translation.x, y: (profileView.center.y) + translation.y)
            if recognizer.state == .began {
                profileView.backgroundColor = .kontakBlue
                profileView.layer.zPosition = 1
            }
            else if recognizer.state == .ended {
                profileView.backgroundColor = nil
                personArray[index].centerX = Float((profileView.frame.minX))
                personArray[index].centerY = Float((profileView.frame.minY))
                DatabaseOperations.shared().saveContext()
            }
        }
    }
    
    @objc func tapGesture(recognizer: UITapGestureRecognizer) {
        searchController.searchBar.resignFirstResponder()
        guard recognizer.view != nil else {return}
        viewSelector(tapGesture: recognizer)
        
        let number = personArray[index].phone1
        let email = personArray[index].email
    
        if searchController.searchBar.selectedScopeButtonIndex == 0 {
            number?.phoneCall()
        }
        else if searchController.searchBar.selectedScopeButtonIndex == 1 {
            number?.whatsApp()
        }
        else if searchController.searchBar.selectedScopeButtonIndex == 2 {
            number?.faceTime()
        }
        else if searchController.searchBar.selectedScopeButtonIndex == 3 {
            email?.send(anEmailTo: email!)
        }        
    }
    
    @objc func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.view != nil else {return}
        viewSelector(longPressGesture: recognizer)
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default, handler: {
            (action) -> Void in self.openPhotoLibrary() })
        
        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default, handler: {
            (action) -> Void in self.openCameraRoll() })
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (action) -> Void in self.openCamera() })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(photoAction)
        optionMenu.addAction(cameraRollAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func dismissTheKeyboard() {
        searchController.searchBar.resignFirstResponder()
    }
}

extension MainViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //MARK:- Open Camera
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //MARK:- Open Photo Library
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //MARK:- Open Camera Roll
    func openCameraRoll() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //MARK:- Image Picker Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.editedImage] as? UIImage{
            DispatchQueue.main.asyncAfter(deadline: .now(), qos: .background, flags: .noQoS) {
                self.cellArray[self.index].imageView.image = chosenImage
                self.personArray[self.index].imageData = chosenImage.pngData()
                DatabaseOperations.shared().saveContext()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
