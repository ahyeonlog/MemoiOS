//
//  CreateUpdateMemoViewController.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/09.
//

import UIKit
import RealmSwift

class CreateUpdateMemoViewController: UIViewController, StoryboardInitializable {
    static var storyboardName: String = "CreateUpdateMemo"
    static var storyboardID: String = "CreateUpdateMemoViewController"
    
    let realm = try! Realm()
    var memo: Memo?
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setNavigationBarButton()
        configureViewController()
        if memo == nil {
            textView.becomeFirstResponder()
        }
    }
    
    func configureViewController() {
        guard let memo = memo else {
            return
        }
        textView.text = memo.title + "\n" + memo.content
    }
    
    private func setNavigationBarButton() {
        let rightDoneBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonClicked))
        let rightShareBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
        navigationItem.setRightBarButtonItems([rightDoneBarButtonItem, rightShareBarButtonItem], animated: false)
    }

    
    @objc func doneButtonClicked() {
        guard let text = textView.text else {
            return
        }
        if text.isEmpty {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        var textViewString: String = text

        let title = "title"
        let content = "content"
        
        // 새로 저장
        guard let memo = memo else {
            try! realm.write {
                realm.add(Memo(title: title, content: content))
            }
            
            self.navigationController?.popViewController(animated: true)
            return
        }
        // 수정
        try! realm.write {
            memo.title = title
            memo.content = title
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonClicked() {
        print("공유")
        
    }
    
    
}
