//
//  ViewController.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/08.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        showFirstInfoVC()
        
    }

    func showFirstInfoVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.firstLaunch?.isFirstLaunch == true {
            print("first launch")
            let vc = FirstInfoViewController.instantiate()
            self.present(vc, animated: true, completion: nil)
        } else {
            print("not first")
        }
    }
}

