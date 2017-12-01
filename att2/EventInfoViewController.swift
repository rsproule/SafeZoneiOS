//
//  EventInfoViewController.swift
//  GoogleToolboxForMac
//
//  Created by Ryan Sproule on 12/1/17.
//

import UIKit
import DateTimePicker
import MapKit

class EventInfoViewController: UIViewController {

    @IBOutlet weak var eventNameTextField: UITextField!
    
    @IBOutlet weak var startTimeLbl: UILabel!
    @IBAction func selectStartTimeBtn(_ sender: UIButton) {
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = false // to hide time and show only date picker
        picker.completionHandler = { date in
            self.startTimeLbl.text = date.toString(dateFormat: "MMMM d, YYYY h:mm a")
        }
    }
    
    
    @IBOutlet weak var finishTimeLbl: UILabel!
    @IBAction func selectFinishTimeBtn(_ sender: UIButton) {
        let picker = DateTimePicker.show()
        picker.highlightColor = UIColor(red: 255.0/255.0, green: 138.0/255.0, blue: 138.0/255.0, alpha: 1)
        picker.isDatePickerOnly = false // to hide time and show only date picker
        picker.completionHandler = { date in
            self.finishTimeLbl.text = date.toString(dateFormat: "MMMM d, YYYY h:mm a")
        }
    }
    
    @IBAction func radiusAction(_ sender: Any) {
    }
    @IBOutlet weak var radiusTextField: UITextField!
    @IBAction func radiusStepper(_ sender: UIStepper) {
        print(sender.stepValue)
        sender.minimumValue = 0.0
        
    }
    
    
    
    /// DATA that needs to be passed along
    
    var group: Group = Group(name: "", members: [], events: [])
    var location: CLLocation = CLLocation()
    // Empty initial event
    var newEvent: Event = Event(location: CLLocation(), name: "", date: Date(), Id: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
