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
        }
    }
    @IBOutlet weak var infoLabel: UILabel! {
        didSet {
            infoLabel.text = "처음 오셨군요!\n환영합니다:)\n\n당신만의 메모를 작성하고\n관리해보세요"
            infoLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func okButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
