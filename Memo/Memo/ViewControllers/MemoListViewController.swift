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
    var favoriteList: Results<Memo>! {
        memoList.filter("isFavorite == true")
    }
    var notFavoriteList: Results<Memo>! {
        memoList.filter("isFavorite == false")
    }
    var filterMemoList: Results<Memo>! {
        memoList.filter("title CONTAINS[c] '\(searchText)' OR content CONTAINS[c] '\(searchText)'")
    }
    
    let realm = try! Realm()
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        
        return isActive
    }
    
    //    var isSearchBarEmpty: Bool {
    //        let searchController = self.navigationItem.searchController
    //        return !searchController?.searchBar.text?.isEmpty
    //    }
    
    var searchText: String = "" {
        didSet {
            tableView.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(NSHomeDirectory())
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
        searchController.searchResultsUpdater = self
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
    func getRow(indexPath: IndexPath) -> Memo {
        if isFiltering {
            return filterMemoList[indexPath.row]
        }
        else if favoriteList.count != 0 && indexPath.section == 0 {
            return favoriteList[indexPath.row]
        } else {
            return notFavoriteList[indexPath.row]
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering || favoriteList.count == 0 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.isFiltering {
            return "\(filterMemoList.count)개의 메모"
        }
        if favoriteList.count != 0 && section == 0 {
            return "고정된 메모"
        } else {
            return "메모"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterMemoList.count
        }
        if favoriteList.count != 0 && section == 0 {
            return favoriteList.count
        } else {
            return notFavoriteList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        let row: Memo = getRow(indexPath: indexPath)
        cell.configureCell(row: row)
        if isFiltering {
            cell.setHighlightedLabel(searchText: searchText)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row: Memo = getRow(indexPath: indexPath)
        
        let vc = CreateUpdateMemoViewController.instantiate()
        vc.memo = row
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // favorite
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row: Memo = getRow(indexPath: indexPath)
        var image: UIImage
        
        image = row.isFavorite ? UIImage(systemName: "pin.slash.fill")! : UIImage(systemName: "pin.fill")!
        
        let favoriteAction = UIContextualAction(style: .normal, title: "고정", handler: { action, view, completionHaldler in
            if self.favoriteList.count >= 5 && row.isFavorite == false {
                self.showAlert(alertTitle: "최대 5개까지 메모를 고정할 수 있습니다.")
                return
            }
            try! self.realm.write {
                row.isFavorite = !row.isFavorite
                self.tableView.reloadData()
            }
            completionHaldler(true)
        })
        favoriteAction.backgroundColor = .systemGreen
        favoriteAction.image = image
        return UISwipeActionsConfiguration(actions: [favoriteAction])
    }
    
    // delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let row: Memo = getRow(indexPath: indexPath)
        
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

extension MemoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.searchText = text
    }
}
