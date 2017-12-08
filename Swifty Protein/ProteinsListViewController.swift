//
//  ProteinsListViewController.swift
//  Swifty Protein
//
//  Created by Dillon MATHER on 2017/12/07.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//

import UIKit

class ProteinsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var Table: UITableView!
    var proteinsList : [String] = []
    var myIndex = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proteinsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.proteinsList[indexPath.row]

        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.init(red: 66.0/255.0, green: 200.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(red: 70.0/255.0, green: 70.0/255.0, blue: 80.0/255.0, alpha: 1.0)
        cell.selectedBackgroundView = bgColorView

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destViewController : DisplayProtein = segue.destination as! DisplayProtein
        destViewController.Protein = proteinsList[myIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "ligands", ofType: "txt")
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: path!) {
            do {
                let content = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
                self.proteinsList = content.components(separatedBy: "\n") as [String]
            } catch let error as NSError {
                print("Error: \(error)")
            }
        } else {
            print("ligands.txt not found")
            createAlert(title: "File not found", message: "The resource \"ligands.txt\" could not be found")
        }
        
        self.Table.separatorColor = UIColor.init(red: 0.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.Table.reloadData()
    }

    /* alert func */
    func createAlert (title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        };
    }
}
