//
//  ViewController.swift
//  MAPD724-ICE-8
//
//  Created by Murtaza Haider Naqvi on 2023-03-26.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController
{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelDesc: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let imagePath = Bundle.main.path(forResource: "parrot", ofType: "jpg")
        let imageURL = NSURL.fileURL(withPath: imagePath!)
        
        let modelFile = MobileNetV2()
        let model = try! VNCoreMLModel(for: modelFile.model)
        
        let handler = VNImageRequestHandler(url: imageURL)
        let request = VNCoreMLRequest(model: model, completionHandler: findResults)
        try! handler.perform([request])
    }
    
    func findResults(request: VNRequest, error: Error?)
    {
       guard let results = request.results as? [VNClassificationObservation] else
        {
           fatalError("Unable to get results")
        }
        var bestGuess = ""
        var bestConfidence: VNConfidence = 0
        for classification in results
        {
          if (classification.confidence > bestConfidence)
            {
             bestConfidence = classification.confidence
             bestGuess = classification.identifier
            }
       }
        labelDesc.text = "Image: \(bestGuess) with confidence \(String(format: "%.3f", bestConfidence)) out of 1"
    }
}


