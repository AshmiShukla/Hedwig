//
//  ViewController.swift
//  CheckFood
//
//  Created by ASHMIT SHUKLA on 08/12/21.
//

import UIKit
import CoreML
import Vision
class ViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker=UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate=self
        imagePicker.sourceType = .photoLibrary
//        imagePicker.sourceType = .camera
        imagePicker.allowsEditing=false
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image=userPickedImage
            guard let ciimage=CIImage(image: userPickedImage) else {
                fatalError("can't convert to ciimage")
            }
            detect(image: ciimage)
        
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func detect(image:CIImage)
    {
        guard let model = try?VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("failed loading model")
        }
        let request=VNCoreMLRequest(model: model) { request, error in
            guard let result=request.results as? [VNClassificationObservation] else{
                fatalError("failed to process img")
            }
            print(result)
            if let firstanswer = result.first{
                print(firstanswer.description)
                
                let ans=firstanswer.identifier
                self.title=ans
                print(ans)
            }
            else
            {
                fatalError("Can't do that")
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        do{
            try handler.perform([request])
        }
        catch{
            print("error")
        }
    }

    @IBAction func CameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

