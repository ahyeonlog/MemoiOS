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
    
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.textContainerInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
        }
    }

    @IBOutlet weak var textViewBottonConstraints: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        configureViewController()
        textView.delegate = self
        if memo == nil {
            textView.becomeFirstResponder()
        }
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGreen]
        navigationItem.standardAppearance?.buttonAppearance = buttonAppearance
        navigationItem.compactAppearance?.buttonAppearance = buttonAppearance
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // keyboard
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        
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
                
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
    
    @objc private func keyboardWillAppear(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            textViewBottonConstraints.constant -= (keyboardHeight - self.view.safeAreaInsets.bottom)
            
            // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
            guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
            }
            UIView.animate(withDuration: animationDuration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillDisappear(notification: NSNotification) {
        // 애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        self.textViewBottonConstraints.constant = 0

        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
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
