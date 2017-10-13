//
//  ScanViewController.swift
//  ReceiptMe
//
//  Created by Zachary Tipnis on 7/28/16.
//  Copyright © 2016 Zachal LLC. All rights reserved.
//

import UIKit
import IPDFCameraViewController
import PIRipple

class ScanViewController: UIViewController {

    //var scanView = IPDFCameraViewController()
    
    var imageFile:UIImage = UIImage()
    var RVC:UIViewController = UIViewController()
    @IBOutlet weak var scanView: IPDFCameraViewController!
    @IBOutlet weak var flashButton: UIButton!
    
    @IBAction func FocusGesture(sender: UITapGestureRecognizer) {
        let point = sender.locationInView(scanView)
        scanView.rippleFill(point, color: UIColor.whiteColor())
        scanView.focusAtPoint(point, completionHandler: {})
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //scanView = IPDFCameraViewController(frame: CGRectMake(0,0,self.view.bounds.width, self.view.bounds.height))
        //view.addSubview(scanView)
        scanView.setupCameraView()
        scanView.enableBorderDetection = true
        flashButton.titleLabel?.text = "Flash: OFF"
        scanView.enableTorch = false
        flashButton.tintColor = UIColor.whiteColor()
        flashButton.titleLabel?.textColor = UIColor.whiteColor()
        
        //scanView.
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scanView.start()
    }
    
    
    @IBAction func toggleFlash(sender: UIButton) {
        if(!scanView.enableTorch) {
            flashButton.titleLabel?.textColor = UIColor(red: 1, green: 0.6, blue: 0, alpha: 0)
            flashButton.setTitle("Flash: ON", forState: .Normal)
            flashButton.setTitleColor(UIColor(red: 1, green: 0.8, blue: 0.1, alpha: 1), forState: .Normal)
            scanView.enableTorch = true
        }else{
           flashButton.titleLabel?.text = "Flash: OFF"
            flashButton.setTitle("Flash: OFF", forState: .Normal)
            flashButton.tintColor = UIColor.whiteColor()
            flashButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
             scanView.enableTorch = false
        }
       
    }

    @IBAction func takePhoto(sender: UIButton) {
        scanView.captureImageWithCompletionHander(
            {
            (path) in
                let imageFilePath:UIImage = path as! UIImage
                NSLog(String(imageFilePath))
                self.imageFile = imageFilePath
                self.scanView.enableTorch = false
                self.performSegueWithIdentifier("capture", sender: self)
        })
    }
    
    @IBAction func cancelAndDelloc(sender: AnyObject) {
        
        scanView.stop()
        scanView.removeFromSuperview()
        scanView = nil
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
        
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.destinationViewController.isKindOfClass(ViewScanController){
            let dest = segue.destinationViewController as! ViewScanController
            dest.scanImg = self.imageFile
            dest.SVVC = self
        }
        
        
    }

}
