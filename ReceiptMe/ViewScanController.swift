//
//  ViewScanController.swift
//  Pods
//
//  Created by Zachary Tipnis on 7/29/16.
//
//

import UIKit
import CoreData
import TesseractOCR

class ViewScanController: UIViewController, G8TesseractDelegate {
    
    var scanImg:UIImage = UIImage()
    var SVVC:UIViewController = UIViewController()
    var text = ""

    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var percentBar: UIProgressView!
    
    func ocrMe() {
        /*let tess = G8Tesseract(language: "eng+spa+jpn")
        tess.delegate = self
        
        tess.image = scanImg
        tess.recognize()
        print(tess.recognizedText)*/
        //percentBar.progress = 0.01
        percentBar.setProgress(0.01, animated: false)
        percentBar.hidden = false
        
        
        SaveButton.setTitleColor(UIColor.grayColor(), forState: .Normal)
        
        SaveButton.enabled = false
        
        print(TesseractOCRVersionNumber)
        activityIndic.hidden = false
        activityIndic.startAnimating()
        sleep(2)
        let tesseract = G8RecognitionOperation(language: "eng")
        tesseract.tesseract.delegate = self
        tesseract.tesseract.image = scanImg
        tesseract.tesseract.charWhitelist = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ$%_-()&#@!.?,;:'\""
        tesseract.tesseract.engineMode = G8OCREngineMode.TesseractOnly
        tesseract.recognitionCompleteBlock = {
            (recognized) in
            self.text = recognized.recognizedText
            print(recognized.recognizedText)
            self.activityIndic.stopAnimating()
           // self.activityIndic.hidden = true
            self.SaveButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            self.SaveButton.enabled = true
            self.percentBar.hidden = true
        
        }
        
       let opQue = NSOperationQueue()
        opQue.addOperation(tesseract)
        
    
    }
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func progressImageRecognitionForTesseract(tesseract: G8Tesseract!) {
        
        
        
        
        let progress:Int = Int(tesseract.progress) - 29
        
        NSLog("progress: %lu", progress)
        
        let floatProgress:Float = Float(progress)/64.0
        
        print(floatProgress)
        percentBar.progress = floatProgress
        percentBar.setProgress(floatProgress, animated: true)
        //NSLog("%lu", )
        
        //percentBar.setProgress(Float(Double(tesseract.progress) / 100.0), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        ImageView.image = scanImg
        sleep(1)
        ocrMe()
    }
    
    @IBAction func saveAndSegue(sender: AnyObject) {
        let alert = UIAlertController(title: "Save",
                                      message: "Add a new reciept",
                                      preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .Default,
                                       handler: { (action:UIAlertAction) -> Void in
                                        
                                        let textField = alert.textFields!.first
                                        self.saveImage(textField!.text!)
                                        //self.names.append(textField!.text!)
                                        //self.tableView.reloadData()
        })
    
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    func saveImage(stringTitl: String) {
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        //2
        let entity =  NSEntityDescription.entityForName("Reciept",
                                                        inManagedObjectContext:managedContext)
        
        let reciept = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        //3
        reciept.setValue(stringTitl, forKey: "title")
        reciept.setValue(text, forKey: "text")
        reciept.setValue(NSDate(), forKey: "date")
        let imgdata = NSData(data: UIImagePNGRepresentation(self.scanImg)!)
        reciept.setValue(imgdata, forKey: "image")
        
        //4
        do {
            try managedContext.save()
            //5
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        let rootVC = self.presentingViewController?.presentingViewController!
        //rootVC.tableView.reloadData()
        let SVVCn = SVVC as! ScanViewController
        let tabVC = SVVCn.RVC as! tableDelegate
        tabVC.tableView.reloadData()
        rootVC!.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func cancelAndSegue(sender: AnyObject) {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: {})
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
