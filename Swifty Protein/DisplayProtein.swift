//
//  DisplayProtein.swift
//  Swifty Protein
//
//  Created by Dillon MATHER on 2017/12/08.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//

import UIKit
import SceneKit

class DisplayProtein: UIViewController {
    
    var Protein: String?
    var scnView: SCNView!
    var scnScene: SCNScene!

    @IBOutlet weak var proteinView: UIView!
    @IBOutlet weak var elementLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = Protein
        
        scnView = self.proteinView as! SCNView
        
        if let ligand = Protein {
            load(ligand)
        }
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(DisplayProtein.didTap(_:)))
        self.view.addGestureRecognizer(tapGR)
        
    }
    
    override var shouldAutorotate: Bool { return true }
    override var prefersStatusBarHidden: Bool { return true }
    
    /* Function that loads in the ligand info from RCSB */
    func load(_ ligand: String) {
        let first = "https://files.rcsb.org/ligands/view/"
        let last = "_ideal.pdb"
        
        // Show activity indicator
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let url = URL(string: first + ligand + last)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            
            if error == nil {
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode >= 200 && response.statusCode <= 299 {
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            // Hide activity indicator
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            
                            let urlContent = NSString(data: data!, encoding: String.Encoding.ascii.rawValue) as NSString!
                            
                            var sentenceLines:[String] = []
                            let string = urlContent as! String
                            string.enumerateLines { (line, _) in
                                sentenceLines.append(line)
                            }
                            
                            self.scnView!.scene = PrimitivesScene(file: sentenceLines)
                            
                            let cameraNode = SCNNode()
                            let camera = SCNCamera()
                            cameraNode.camera = camera
                            self.scnView!.scene!.rootNode.addChildNode(cameraNode)
                            cameraNode.position = SCNVector3(x: 0, y: 0, z: 35)
                            
                            self.scnView?.scene?.background.contents = UIImage(named: "test.jpg")
                            self.scnView!.backgroundColor = UIColor.white
                            self.scnView!.autoenablesDefaultLighting = true
                            self.scnView!.allowsCameraControl = true
                            
                            self.descriptionLabel.text = "Ligand code " + ligand
                        })
                        
                    } else {
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            // Hide activity indicator
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            
                            let alertController = UIAlertController(title: "Error", message: "Can't load Ligand: \(ligand)", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "GOTCHA", style: .default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        })
                        
                        
                    }
                }
                
            } else {
                
                DispatchQueue.main.async(execute: { () -> Void in
                    // Hide activity indicator
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    
                    let alertController = UIAlertController(title: "Error", message: "Can't load Ligand", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "GOTCHA", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        })
        
        // Hide activity indicator
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        task.resume()
        
        
    }
    
    func didTap(_ tapGR: UITapGestureRecognizer) {
        let v = self.proteinView as! SCNView
        let tapPoint = tapGR.location(in: v)
        let hits = self.scnView!.hitTest(tapPoint, options: nil)
        
        if let tappedNode = hits.first?.node {
            elementLabel.isHidden = false
            elementLabel.text = "Selected Element: " + tappedNode.ligand.name
        }
    }
    
    @IBAction func Shared(_ sender: UIBarButtonItem) {
        let activityVC = UIActivityViewController(activityItems: [scnView.snapshot()], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
}
