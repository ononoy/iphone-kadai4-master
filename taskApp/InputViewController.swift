//
//  InputViewController.swift
//  taskApp
//
//  Created by 迫 佑樹 on 2017/05/02.
//  Copyright © 2017年 Yuki Sako. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class InputViewController: UIViewController {

    @IBOutlet weak var titleTexField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    
    var task: Task!
    let realm = try! Realm()
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write{
            self.task.title = self.titleTexField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date as NSDate
            self.task.category = self.categoryTextField.text!
            self.realm.add(self.task, update: true)
        }
        setNotification(task:task)
        super.viewDidDisappear(animated)
        
    }
    
    func setNotification(task:Task){
        let content = UNMutableNotificationContent()
        content.title = task.title
        content.body = task.contents
        content.sound = UNNotificationSound.default()
        
        let calendar = NSCalendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, ], from: task.date as Date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats:false)
        
        let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error)
        }
        
        center.getPendingNotificationRequests { (requests:[UNNotificationRequest]) in
            for request in requests{
                print("--------")
                print(request)
                print("--------")
            }
        }
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void){
        completionHandler([.sound, .alert])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGeture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGeture)
        
        titleTexField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date as Date
        categoryTextField.text = task.category
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
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
