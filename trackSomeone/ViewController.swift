//
//  ViewController.swift
//  trackSomeone
//
//  Created by Shang Chi Cheng on 2017/9/28.
//  Copyright © 2017年 shyon. All rights reserved.
//

import UIKit
import AVKit
import Vision

var theme: UIColor = UIColor.black
var lang:String = "zh-TW"

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = theme
    }
    
    @IBOutlet weak var CResult: UILabel!
    @IBAction func camBtn(_ sender: Any) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        let cameraPic = UIImagePickerController()
        cameraPic.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        cameraPic.sourceType = .camera
        cameraPic.allowsEditing = false
        present(cameraPic, animated: true)
    }
    
    @IBAction func libBtn(_ sender: Any) {
        let pic = UIImagePickerController()
        pic.allowsEditing = false
        pic.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        pic.sourceType = .photoLibrary
        present(pic, animated: true)
    }
    
    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get input from the device
        let capSession = AVCaptureSession()
        guard let capDevice = AVCaptureDevice.default(for: .video) else {
            return
        }
        guard let input = try? AVCaptureDeviceInput(device: capDevice) else {
            return
        }
        capSession.addInput(input)
        capSession.startRunning()
        
        // get output from the camera
        let camOutput = AVCaptureVideoDataOutput()
        camOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video"))
        capSession.addOutput(camOutput)
        
        // display the output
        let camPreview = AVCaptureVideoPreviewLayer(session: capSession)
        camPreview.frame = CGRect(x: 16, y: 20, width: cameraView.frame.width, height: cameraView.frame.height)
        cameraView.layer.addSublayer(camPreview)
        
    }
    
    //when camera have a frame, call this!
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        detectImage(pixelBuffer: pixelBuffer)
    }
    func detectImage(pixelBuffer: CVPixelBuffer) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            return
        }
        let req = VNCoreMLRequest(model: model) { (req, error) in
            guard let results = req.results as? [VNClassificationObservation] else {
                return
            }
            guard let firstResult = results.first else {
                return
            }
            //-->
            var params = ROGoogleTranslateParams(source: "en",
                                                 target: lang,
                                                 text:   String(firstResult.identifier))
            
            let translator = ROGoogleTranslate(with: "AIzaSyDTQ6hCQOKLWP8TfmLIRUPBzjX_3Ic7F_4")
            //<--
            DispatchQueue.main.async {
                self.resultLabel.text = firstResult.identifier
            }
            
            translator.translate(params: params) { (result) in
                DispatchQueue.main.async {
                    self.CResult.text = result
                }
            }
            
            
        }
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        DispatchQueue.global().async {
            try? handler.perform([req])
        }
    }
    
//    func resultTrans() {
//        var params = ROGoogleTranslateParams(source: "en",
//                                             target: "zh-TW",
//                                             text:   String(firstResult.identifier))
//
//        let translator = ROGoogleTranslate(with: "API Key here")
//
//        translator.translate(params: params) { (result) in
//            print("Translation: \(result)")
//        }
//    }
    
}
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
