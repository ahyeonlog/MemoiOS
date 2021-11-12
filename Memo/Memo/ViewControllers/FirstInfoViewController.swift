//
//  FirstInfoViewController.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/09.
//

import UIKit

class FirstInfoViewController: UIViewController, StoryboardInitializable {
    static var storyboardName: String = "FirstInfo"
    static var storyboardID: String = "FirstInfoViewController"
    
    @IBOutlet weak var infoView: UIView! {
        didSet {
            infoView.layer.cornerRadius = 10
            infoView.backgroundColor = UIColor(red: 77/255, green: 77/255, blue: 77/255, alpha: 1)
        }
    }
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.text = "처음 오셨군요!\n환영합니다:)\n\n당신만의 메모를 작성하고\n관리해보세요"
            infoLabel.numberOfLines = 0
            infoLabel.font = UIFont().infoFont
        }
    }
    
    @IBOutlet weak var okButton: UIButton! {
        didSet {
            okButton.layer.cornerRadius = 10
            okButton.backgroundColor = .systemGreen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func okButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
