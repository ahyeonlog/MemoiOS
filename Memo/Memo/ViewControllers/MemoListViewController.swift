//
//  MemoListViewController.swift
//  Memo
//
//  Created by Ahyeonway on 2021/11/08.
//

import UIKit
import RealmSwift

class MemoListViewController: UIViewController {
    var data: Results<Memo>! {
        didSet {
            self.navigationItem.title = "\(data.count)개의 메모"
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
        print(self, #function)
        print(NSHomeDirectory())
        showFirstInfoVC()
        setNavigationItem()
        tableView.delegate = self
        tableView.dataSource = self
        data = realm.objects(Memo.self)
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
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else {
            return UITableViewCell()
        }
        let row = data[indexPath.row]
        cell.titleLabel.text = row.title
        cell.dateLabel.text = "\(row.createdAt)"
        cell.contentLabel.text = row.content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = CreateUpdateMemoViewController.instantiate()
            vc.memo = data[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
