//
//  MainTabBarController.swift
//  
//
//  Created by Ryan Sproule on 11/22/17.
//

import UIKit

class MainTabBarController: UITabBarController {

    var currentUserId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.currentUserId)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
