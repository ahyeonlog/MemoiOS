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
        configureViewController()
        textView.delegate = self
        if memo == nil {
            textView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isMovingFromParent {
            saveMemo()
        }
    }

    func configureViewController() {
        guard let memo = memo else {
            return
        }
        textView.text = memo.title + memo.content
    }
    
    private func setNavigationBarButton() {
        var items = [UIBarButtonItem]()
        let rightDoneBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonClicked))
        items.append(rightDoneBarButtonItem)
        if memo != nil {
            let rightShareBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonClicked))
            items.append(rightShareBarButtonItem)
        }
        
        navigationItem.setRightBarButtonItems(items, animated: false)
    }
    
    private func saveMemo() {
        guard let text = textView.text else {
            return
        }
        if text.isEmpty {
            if let memo = memo {
                try! realm.write {
                    realm.delete(memo)
                }
            }
            self.navigationController?.popViewController(animated: true)
            return
        }

        var title = ""
        var content = ""

        if let firstLineEndIndex = text.firstIndex(of: "\n") {
            title = String(text[...firstLineEndIndex])
            content = String(text[text.index(after: firstLineEndIndex)...])
        } else {
            title = text
        }
        // 새로 저장
        guard let memo = memo else {
            try! realm.write {
                realm.add(Memo(title: title, content: content))
            }
            return
        }
        // 수정
        try! realm.write {
            memo.title = title
            memo.content = content
            return
        }
    }
    
    @objc func doneButtonClicked() {
//        saveMemo()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonClicked() {
        guard let memo = memo else {
            return
        }

        let vc = UIActivityViewController(activityItems: ["\(memo.title)\(memo.content)"], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
}

extension CreateUpdateMemoViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setNavigationBarButton()
    }
}
