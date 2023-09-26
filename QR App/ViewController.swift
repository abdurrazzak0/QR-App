//
//  ViewController.swift
//  QR App
//
//  Created by Abdur Razzak on 26/9/23.
//

import UIKit
import AVFoundation
import PhotosUI

class ViewController: UIViewController {


    @IBOutlet weak var qrFileBarButton: UIBarButtonItem!
    @IBOutlet weak var qrlistTableView: UITableView!
    @IBOutlet weak var qrimageView: UIImageView!
    @IBOutlet weak var getTextButton: UIButton!
    
    
    var imageArray = UIImage()
    
    var getData = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    @IBAction func qrFileBarButtonAction(_ sender: Any) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let pickerVC = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        self.present(pickerVC, animated: true)
    }
    
    
    

    @IBAction func getTextButtonAction(_ sender: Any) {
        
        
    }
    
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    self.imageArray = image
                }
                
                DispatchQueue.main.async { [self] in
                    self.qrimageView.image = imageArray
                }
            }
        }
    }
}






func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
    if let image = image, let ciImage = CIImage.init(image: image){
        var options: [String: Any]
        let context = CIContext()
        options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
        if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
            options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
        } else {
            options = [CIDetectorImageOrientation: 1]
        }
        let features = qrDetector?.features(in: ciImage, options: options)
        return features
        
    }
    return nil
}





extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        imageArray = image
        DispatchQueue.main.async { [self] in
            self.qrimageView.image = image
            
            
        }
    }
    
}
