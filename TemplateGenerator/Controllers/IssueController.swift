//
//  IssueController.swift
//  TemplateGenerator
//
//  Created by Rihards Mednis on 20/09/2020.
//  Copyright © 2020 Rihards Mednis. All rights reserved.
//

import UIKit

class IssueController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let roomField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Room number"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        return field
    }()
    
    private let descriptionField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Comment"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.textColor = .black
        return field
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Add issue"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(roomField)
        scrollView.addSubview(descriptionField)
        scrollView.addSubview(imageView)
        scrollView.addSubview(addButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapAddPicture))
        
        imageView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds

        roomField.frame = CGRect(x: 10,
                                 y: 20,
                                 width: scrollView.width-20,
                                 height: 50)
        descriptionField.frame = CGRect(x: 10,
                                    y: roomField.bottom + 10,
                                    width: scrollView.width-20,
                                    height: 50)
        imageView.frame = CGRect(x: 10,
                                 y: descriptionField.bottom + 10,
                                 width: scrollView.width-20,
                                 height: scrollView.width-20)
        addButton.frame = CGRect(x: 10,
                                 y: imageView.bottom + 10,
                                 width: scrollView.width-20,
                                 height: 50)
    }
    
    @objc func didTapAddPicture() {
        presentPhotoActionSheet()
        
    }

    @objc func didTapAdd() {

        guard let room = roomField.text, let description = descriptionField.text, !room.isEmpty, !description.isEmpty else {
            AlertService.alertMsg(in: self, message: "Fill up all information")
            return
        }

//        let issue = Issue(room: roomField.text!, description: descriptionField.text!, imageFileName: "\(roomField.text)_\(UUID.self)", imageData: (imageView.image?.pngData())!)
        
        let issue = Issue(room: roomField.text!, description: descriptionField.text!, imageFileName: "\(String(describing: roomField.text))_\(UUID.self)")

        issues.append(issue)
        self.dismiss(animated: true, completion: nil)
        
    }
}

extension IssueController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Photo",
                                            message: "Choose a way to upload the photo",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take a photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose a photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentImagePicker()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
//        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentImagePicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
//        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.imageView.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
