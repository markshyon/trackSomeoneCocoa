//
//  SettingVC.swift
//  trackSomeone
//
//  Created by Shang Chi Cheng on 2017/10/2.
//  Copyright © 2017年 shyon. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var themeBtn: UISegmentedControl!
    
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet var themeLabel: [UILabel]!
    
    @IBAction func themeBtn(_ sender: Any) {
        let index = themeBtn.selectedSegmentIndex
        if index == 0 {
            theme = UIColor.black
        }
        if index == 1 {
            theme = UIColor.purple
        }
        if index == 2 {
            theme = UIColor.green
        }
        view.backgroundColor = theme
    }
    @IBAction func switchBtn(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = theme
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
