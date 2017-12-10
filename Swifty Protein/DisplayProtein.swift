//
//  DisplayProtein.swift
//  Swifty Protein
//
//  Created by Dillon MATHER on 2017/12/08.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//

import UIKit

class DisplayProtein: UIViewController {
    
    var Protein: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Protein
    }
    
    @IBAction func Shared(_ sender: UIBarButtonItem) {
        let activityVC = UIActivityViewController(activityItems: [screenshot()], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func screenshot() -> UIImage {
        let imageSize = UIScreen.main.bounds.size as CGSize;
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let context = UIGraphicsGetCurrentContext()
        for obj : AnyObject in UIApplication.shared.windows {
            if let window = obj as? UIWindow {
                if window.responds(to: #selector(getter: UIWindow.screen)) || window.screen == UIScreen.main {
                    context!.saveGState();
                    context!.translateBy(x: window.center.x, y: window.center .y);
                    context!.concatenate(window.transform);
                    context!.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y);
                    window.layer.render(in: context!)
                    context!.restoreGState();
                }
            }
        }
        let image = UIGraphicsGetImageFromCurrentImageContext();
        return image!
    }
    
}
