//
//  ViewController.swift
//  DetectObject
//
//  Created by TAIGA ITO on 2024/10/09.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detectLabel: UILabel!
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("Image not found.")
            return
        }
        
        imageView.image = image
    }

    @IBAction func selectFromPhotoLibraryTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("Photo Library not available.")
        }
    }
    
    @IBAction func tapDetect() {
        guard let image = imageView.image else { return }
        Methods.shared.detectObject(image: image) { labels in
            self.detectLabel.text = labels.joined(separator: "\n")
        }
    }
}

