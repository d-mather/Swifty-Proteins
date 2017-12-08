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
}
