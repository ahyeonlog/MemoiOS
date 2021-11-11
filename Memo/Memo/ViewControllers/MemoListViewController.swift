//
//  MemoListViewController.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/08.
//

import UIKit
import RealmSwift

class MemoListViewController: UIViewController {
    var memoList: Results<Memo>! {
        didSet {
            self.navigationItem.title = "\(memoList.count)개의 메모"
        }
    }
    let realm = try! Realm()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        showFirstInfoVC()
        setNavigationItem()
        tableView.delegate = self
        tableView.dataSource = self
        memoList = realm.objects(Memo.self).sorted(byKeyPath: "createdAt", ascending: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    private func setNavigationItem() {
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "검색"
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func showFirstInfoVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.firstLaunch?.isFirstLaunch == true {
            print("first launch")
            let vc = FirstInfoViewController.instantiate()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false, completion: nil)
        } else {
            print("not first")
        }
    }
    
    @IBAction func createMemoButtonClicked(_ sender: UIBarButtonItem) {
        let vc = CreateUpdateMemoViewController.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MemoListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "고정된 메모"
        } else {
            return "메모"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return memoList.filter("isFavorite == true").count
        } else {
            return memoList.filter("isFavorite == false").count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        
        let row: Memo
        if indexPath.section == 0 {
            row = memoList.filter("isFavorite == true")[indexPath.row]
        } else {
            row = memoList.filter("isFavorite == false")[indexPath.row]
        }
        
        cell.titleLabel.text = row.title
        cell.dateLabel.text = "\(row.createdAt)"
        cell.contentLabel.text = row.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = CreateUpdateMemoViewController.instantiate()
            vc.memo = memoList[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // favorite
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row: Memo
        let image: UIImage
        
        if indexPath.section == 0 {
            row = memoList.filter("isFavorite == true")[indexPath.row]
            image = UIImage(systemName: "pin.slash.fill")!
        } else {
            row = memoList.filter("isFavorite == false")[indexPath.row]
            image = UIImage(systemName: "pin.fill")!
        }
        
        let favoriteAction = UIContextualAction(style: .normal, title: "고정", handler: { action, view, completionHaldler in
                try! self.realm.write {
                    row.isFavorite = !row.isFavorite
                    self.tableView.reloadData()
                }
                completionHaldler(true)
            })
        favoriteAction.backgroundColor = .systemGreen
        favoriteAction.image = image
         //pin.slash.fill
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    // delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row: Memo
        
        if indexPath.section == 0 {
            row = memoList.filter("isFavorite == true")[indexPath.row]
        } else {
            row = memoList.filter("isFavorite == false")[indexPath.row]
        }
        
        let deleteAction = UIContextualAction(style: .normal, title: "삭제", handler: { action, view, completionHaldler in
                self.showAlert(alertTitle: "메모를 삭제하시겠습니까?", alertMessage: "정말요?") { action in
                    try! self.realm.write {
                        self.realm.delete(row)
                        self.tableView.reloadData()
                    }
                } cancelHandler: { action in
                    return
                }
                completionHaldler(true)
            })
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
