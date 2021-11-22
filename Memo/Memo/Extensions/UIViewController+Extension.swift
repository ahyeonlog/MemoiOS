//
//  UIViewController+Extension.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/09.
//

import UIKit

extension UIViewController {
    func showAlert(alertTitle: String, alertMessage: String, okHandler: @escaping (UIAlertAction)->(), cancelHandler: @escaping (UIAlertAction) -> ()) {
        // 1. UIAlertController 생성: 밑바탕 + 타이틀 + 본문
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        // 2. UIAlertAction 생성: 버튼들..
        let ok = UIAlertAction(title: "삭제", style: .default) { action in
            okHandler(action)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { action in
            cancelHandler(action)
        }
        
        // 3. 1+2
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // 4. present
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(alertTitle: String) {
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

protocol StoryboardInitializable: AnyObject {
    static var storyboardName: String { get set }
    static var storyboardID: String { get set }
    static func instantiate() -> Self
}

extension StoryboardInitializable where Self: UIViewController {

    static func instantiate() -> Self {
        if #available(iOS 13.0, *) {
            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
            return storyboard.instantiateViewController(identifier: storyboardID) { (coder) -> Self? in
                return Self(coder: coder)
            }
        } else {
            let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: storyboardID) as! Self
            return vc
        }
    }
}
